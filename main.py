from PyQt6.QtCharts import QChart, QValueAxis, QChartView, QBarSeries, QBarCategoryAxis, QBarSet
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QFont
from PyQt6.QtWidgets import QMainWindow, QApplication, QPushButton
from ui_py_files.order import OrderManagementWidget
from ui_py_files.waiter_ui import Waiter_UI
from ui_py_files.order_info import OrderInfoWidget
from menu_and_cart import MenuWin
from bd import *

class WaiterWin(QMainWindow, Waiter_UI):
    def __init__(self, user_id, parent=None):
        super().__init__(parent)
        self.setupUi(self)
        self.styles = {
            'free': 'background-color: rgb(126, 180, 138);',
            'occupied': 'background-color: rgb(216, 63, 66);',
            'cleaning_required': 'background-color: rgb(241, 230, 166);',
            'reserved': 'background-color: rgb(241, 171, 148);',}
        self.tables_info = []
        self.waiter_id = user_id

        self.set_tables()
        menu = MenuWin(self.waiter_id)
        menu.order_created.connect(self.load_active_orders)
        menu.order_created.connect(self.set_tables)
        self.menuLayout.addWidget(menu)
        self.load_active_orders()
        self.set_chart()

    def set_tables(self):
        while self.gridLayout_2.count():
            item = self.gridLayout_2.takeAt(0)
            if item.widget():
                item.widget().deleteLater()

        self.tables_info = select_query("SELECT * FROM tables;")
        self.tables = []
        for i, table in enumerate(self.tables_info):
            table_id = table[0]
            button = QPushButton(f'Столик №{table_id}')
            button.setFixedSize(90, 90)
            button.setFont(QFont('Arial', 10))
            state = table[1]
            if state == "Свободен":
                state = 'free'
            elif state == "Занят":
                state = 'occupied'
            elif state == "Не убран":
                state = 'cleaning_required'
            elif state == "Зарезервировано":
                state = 'reserved'
            button.setStyleSheet(self.styles[state])
            self.tables.append({'button': button, 'state': state})
            button.clicked.connect(lambda checked, idx=i, tb_i=table_id: self.toggle_table_state(idx, tb_i))
            row = i // 5
            col = i % 5
            self.gridLayout_2.addWidget(button, row, col)

    def toggle_table_state(self, idx, table_id):
        try:
            states = ['free', 'occupied', 'reserved', 'cleaning_required']
            current_state = self.tables[idx]['state']
            next_state_idx = (states.index(current_state) + 1) % len(states)
            new_state = states[next_state_idx]
            self.tables[idx]['button'].setStyleSheet(self.styles[new_state])
            self.tables[idx]['state'] = new_state

            states_rus = ["Свободен", "Занят", "Зарезервировано", "Не убран"]
            query = """UPDATE tables SET status = %s WHERE table_id = %s"""
            new_status = states_rus[next_state_idx]
            update_query(query, (new_status, table_id, ))
        except Exception as e:
            print(e)


    def load_active_orders(self):
        query = """
        SELECT o.order_id, o.table_id, o.status, b.full_sum, o.order_time
        FROM orders o
        LEFT JOIN bills b ON o.order_id = b.order_id
        WHERE o.status != 'Завершен' AND o.waiter_id = %s
        ORDER BY o.order_time DESC
        """
        orders = select_query(query, (self.waiter_id,))

        while self.ordersLayout.count():
            child = self.ordersLayout.takeAt(0)
            if child.widget():
                child.widget().deleteLater()

        for order in orders:
            card = OrderManagementWidget(order)
            card.cancelOrder.clicked.connect(lambda checked, ordr=order: self.cancel_order(ordr))
            card.endOrder.clicked.connect(lambda checked, ordr=order: self.end_order(ordr))
            card.openOrder.clicked.connect(lambda checked, ordr=order: self.view_order(ordr))
            self.ordersLayout.addWidget(card)

    def cancel_order(self, order):
        try:
            order_id = order[0]
            table_id = order[1]
            update_query("DELETE FROM bills WHERE order_id = %s", (order_id,))
            update_query("DELETE FROM order_items WHERE order_id = %s", (order_id,))
            update_query("DELETE FROM orders WHERE order_id = %s", (order_id,))
            update_query("UPDATE tables SET status='Свободен' WHERE table_id = %s", (table_id, ))
            self.load_active_orders()
            self.set_tables()
        except Exception as e:
            print(f"cancel_order() - {e}")

    def view_order(self, order):
        try:
            query = """SELECT d.name, d.price, o.quantity FROM order_items o JOIN dishes d ON d.dish_id = o.dish_id WHERE o.order_id = %s;"""
            res = select_query(query, order[0])
            self.widget = OrderInfoWidget(res)
            self.widget.show()
            self.load_active_orders()
        except Exception as e:
            print(f"view_order() - {e}")

    def end_order(self, order):
        try:
            query = "UPDATE orders SET status = 'Завершен' WHERE order_id = %s"
            update_query(query, order[0])
            table_id = order[1]
            query2 = "UPDATE tables SET status = 'Свободен' WHERE table_id = %s"
            update_query(query2, (table_id,))
            self.load_active_orders()
            self.set_tables()
        except Exception as e:
            print(f"end_order() - {e}")

    def set_chart(self):
        """Метод для построения графика"""
        # очищаем layout от виджетов
        self.chartsLayout.takeAt(0)

        query = """SELECT DATE(order_time) as day, SUM(full_sum) as daily_revenue FROM orders o 
        JOIN bills b ON o.order_id = b.order_id WHERE o.waiter_id = %s AND o.status = 'Завершен' 
        GROUP BY DATE(order_time) ORDER BY day LIMIT 7;"""
        data = select_query(query, (self.waiter_id, ))

        bar_set = QBarSet("Выручка")
        categories = []

        for date, order_sum in data:
            date = str(date)
            day_date = date[8:] + "." + date[5:7]
            categories.append(day_date)

            bar_set.append(order_sum)

        bar_series = QBarSeries()
        bar_series.append(bar_set)

        chart = QChart()
        chart.addSeries(bar_series)
        chart.setTitle("Выручка за последнюю неделю по дням")

        axis_x = QBarCategoryAxis()
        axis_x.append(categories)
        axis_x.setTitleText("Дата")
        chart.addAxis(axis_x, Qt.AlignmentFlag.AlignBottom)
        bar_series.attachAxis(axis_x)

        axis_y = QValueAxis()
        axis_y.setTitleText("Выручка")
        axis_y.setLabelFormat("%.2f")
        chart.addAxis(axis_y, Qt.AlignmentFlag.AlignLeft)
        bar_series.attachAxis(axis_y)

        chart_view = QChartView(chart)
        self.chartsLayout.addWidget(chart_view)


if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    window = WaiterWin(1)
    window.show()
    sys.exit(app.exec())