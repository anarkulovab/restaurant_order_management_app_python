import datetime
from PyQt6.QtCore import pyqtSignal
from PyQt6.QtGui import QPixmap
from PyQt6.QtWidgets import QMainWindow, QApplication, QMessageBox
from ui_py_files.menu_ui_result import *
from ui_py_files.dish_long_label import DishMenu_UI
from ui_py_files.item_in_cart import CartItem_UI
from bd import *

class DishCardWidget(QtWidgets.QWidget):
    def __init__(self, dish_data, parent=None):
        super().__init__(parent)
        self.ui = DishMenu_UI()
        self.ui.setupUi(self)

        timedelta = datetime.timedelta(seconds=900)
        minutes = timedelta.seconds // 60
        self.ui.label_2.setText(dish_data[1])
        self.ui.label_3.setText(f"{dish_data[-1]}\n"
                                f"Время готовки: {minutes} минут\n")
        self.ui.label_4.setText(f"{dish_data[3]} ₽.\n")
        pixmap = QPixmap(dish_data[2]).scaled(200, 200, QtCore.Qt.AspectRatioMode.KeepAspectRatio)
        self.ui.label.setPixmap(pixmap)
        self.setFixedSize(1000, 240)


class DishInCartWidget(QtWidgets.QWidget):
    def __init__(self, dish_data, parent=None):
        super().__init__(parent)
        self.ui = CartItem_UI()
        self.ui.setupUi(self)
        pixmap = QPixmap(dish_data[2]).scaled(161, 131, QtCore.Qt.AspectRatioMode.KeepAspectRatio)
        self.ui.label.setPixmap(pixmap)
        self.ui.label_2.setText(dish_data[1])
        self.ui.label_4.setText(f"{dish_data[3]} ₽")
        self.setFixedSize(900, 196)


class MenuWin(QMainWindow, Ui_MainWindow):
    order_created = pyqtSignal()
    def __init__(self, user_id, parent=None):
        super().__init__(parent)
        self.setupUi(self)
        self.dishes_lst = list(select_query("SELECT * FROM dishes;"))
        self.set_menu(self.dishes_lst)
        self.searchButton.clicked.connect(self.search)
        self.toolButton.clicked.connect(self.to_cart)
        self.backButton.clicked.connect(self.to_menu)
        self.pushButton_2.clicked.connect(self.new_order)
        self.total_price = 0
        self.cart_widgets = {}
        self.tabWidget.tabBar().hide()
        self.load_tables()
        self.waiter_id = user_id
        self.filterComboBox.addItems(["По умолчанию", "По названию", "По цене (возр.)", "По цене (убыв.)"])
        self.filterComboBox.currentTextChanged.connect(self.filter)

    def set_menu(self, data):
        try:
            self.clear()
            for i, dish in enumerate(data):
                card = DishCardWidget(dish)
                self.menuLayout.addWidget(card)
                card.ui.pushButton.clicked.connect(lambda checked, d=dish: self.add_to_cart(d))
        except Exception as e:
            print(f"set_menu - {e}")

    def load_tables(self):
        try:
            tables = select_query("SELECT table_id FROM tables")
            self.tableComboBox.clear()
            self.tableComboBox.addItem("Выберите столик", None)
            for table in tables:
                self.tableComboBox.addItem(f"Столик №{table[0]}", table[0])
        except Exception as e:
            print(f"load_tables - {e}")

    def clear(self):
        try:
            while self.menuLayout.count():
                item = self.menuLayout.takeAt(0)
                if item.widget():
                    item.widget().deleteLater()
        except Exception as e:
            print(e)

    def search(self):
        try:
            search_text = self.searchLineEdit.text().lower()
            filter_type = self.filterComboBox.currentText()
            filtered_dishes = [dish for dish in self.dishes_lst if search_text in dish[1].lower()]
            if filter_type:
                if filter_type == "По названию":
                    filtered_dishes.sort(key=lambda x: x[1])
                elif filter_type == "По цене (возр.)":
                    filtered_dishes.sort(key=lambda x: x[3])
                elif filter_type == "По цене (убыв.)":
                    filtered_dishes.sort(key=lambda x: x[3], reverse=True)
            self.set_menu(filtered_dishes)
        except Exception as e:
            print(e)

    def filter(self):
        filter_type = self.filterComboBox.currentText()
        filtered_dishes = self.dishes_lst
        if filter_type:
            if filter_type == "По названию":
                filtered_dishes.sort(key=lambda x: x[1])
            elif filter_type == "По цене (возр.)":
                filtered_dishes.sort(key=lambda x: x[3])
            elif filter_type == "По цене (убыв.)":
                filtered_dishes.sort(key=lambda x: x[3], reverse=True)
        self.set_menu(filtered_dishes)

    def to_cart(self):
        self.tabWidget.setCurrentIndex(1)

    def to_menu(self):
        self.tabWidget.setCurrentIndex(0)

    def add_to_cart(self, dish):
        try:
            if dish[0] not in self.cart_widgets:
                card = DishInCartWidget(dish)
                self.cart_widgets[dish[0]] = card
                self.cartLayout.addWidget(card)
                card.ui.toolButton.clicked.connect(lambda checked, d=dish: self.minus_dish(d))
                card.ui.toolButton_2.clicked.connect(lambda checked, d=dish: self.plus_dish(d))
                card.ui.toolButton_3.clicked.connect(lambda checked, d=dish:self.delete_dish(d))
            else:
                widget = self.cart_widgets[dish[0]]
                amount = int(widget.ui.label_3.text())
                widget.ui.label_3.setText(str(amount + 1))
            self.price_count(dish[3])
        except Exception as e:
            print(e)

    def price_count(self, price, mode="+"):
        try:
            if self.total_price >= 0:
                if mode == "+":
                    self.total_price += price
                else:
                    self.total_price -= price
                self.label_3.setText(f"{self.total_price} ₽")
        except Exception as e:
            print(e)

    def plus_dish(self, dish):
        try:
            if dish[0] in self.cart_widgets:
                widget = self.cart_widgets[dish[0]]
                amount = int(widget.ui.label_3.text())
                widget.ui.label_3.setText(str(amount + 1))
                self.price_count(dish[3])
        except Exception as e:
            print(e)

    def minus_dish(self, dish):
        try:
            if dish[0] in self.cart_widgets:
                widget = self.cart_widgets[dish[0]]
                amount = int(widget.ui.label_3.text())
                if amount > 1:
                    widget.ui.label_3.setText(str(amount - 1))
                    self.price_count(dish[3], mode="-")
                elif amount == 1:
                    self.delete_dish(dish)
        except Exception as e:
            print(e)

    def delete_dish(self, dish):
        if dish[0] in self.cart_widgets:
            widget = self.cart_widgets[dish[0]]
            amount = int(widget.ui.label_3.text())
            self.price_count(dish[3] * amount, mode="-")
            self.cartLayout.removeWidget(widget)
            widget.deleteLater()
            del self.cart_widgets[dish[0]]

    def new_order(self):
        try:
            table_id = self.tableComboBox.currentData()
            if not table_id:
                QMessageBox.warning(self, "Ошибка", "Выберите столик!")
                return

            comment = self.lineEdit.text()
            order_query = """INSERT INTO orders (comments, waiter_id, table_id, order_time, status) VALUES (%s, %s, %s, NOW(), 'Обрабатывается')"""
            update_query(order_query, (comment, self.waiter_id, table_id, ))
            order_id = select_query("SELECT LAST_INSERT_ID()")[0][0]

            for dish_id, widget in self.cart_widgets.items():
                amount = int(widget.ui.label_3.text())
                items_query = "INSERT INTO order_items (order_id, dish_id, quantity) VALUES (%s, %s, %s)"
                update_query(items_query, (order_id, dish_id, amount))

            bill_query = """INSERT INTO bills(order_id, tip_amount, discount, full_sum) VALUES(%s, 0, 0, %s)"""
            update_query(bill_query, (order_id, self.total_price))

            table_query = """UPDATE tables SET status='Занят' WHERE table_id = %s"""
            update_query(table_query, (table_id, ))
            self.clear_cart()
            self.order_created.emit()
            QMessageBox.information(self, "Успех", f"Заказ №{order_id} создан!")

        except Exception as e:
            print(e)
            QMessageBox.critical(self, "Ошибка", str(e))

    def clear_cart(self):
        for widget in self.cart_widgets.values():
            self.cartLayout.removeWidget(widget)
            widget.deleteLater()
        self.cart_widgets.clear()
        self.total_price = 0
        self.label_3.setText("0 ₽")
        self.lineEdit.clear()


if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    window = MenuWin(1)
    window.show()
    sys.exit(app.exec())