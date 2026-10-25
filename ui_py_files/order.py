from PyQt6 import QtCore
from PyQt6.QtWidgets import QWidget, QApplication, QPushButton, QHBoxLayout, QLabel, QFrame


class OrderManagementWidget(QWidget):
    def __init__(self, order_data, parent=None):
        super().__init__(parent)

        self.frame = QFrame(self)
        self.frame.setStyleSheet("border:1px solid grey; border-radius:15px;")
        self.frame.setFixedSize(1000, 90)
        self.horizontalLayout = QHBoxLayout(self)

        self.table_label = QLabel()
        self.table_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.table_label.setStyleSheet("border:0px;font-size:16px;font-weight:bold;")
        self.horizontalLayout.addWidget(self.table_label)

        self.status_label = QLabel()
        self.status_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.status_label.setStyleSheet("border:0px;font-size:16px;color:red;")
        self.horizontalLayout.addWidget(self.status_label)

        self.order_sum_label = QLabel()
        self.order_sum_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.order_sum_label.setStyleSheet("border:0px;font-size:16px;")
        self.horizontalLayout.addWidget(self.order_sum_label)

        self.time_label = QLabel()
        self.time_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.time_label.setStyleSheet("border:0px;font-size:16px;")
        self.horizontalLayout.addWidget(self.time_label)

        self.openOrder = QPushButton("Открыть заказ")
        self.openOrder.setMaximumSize(QtCore.QSize(120, 50))
        self.openOrder.setStyleSheet("border-radius:15px; background-color: rgb(144, 174, 200);border:0px;")
        self.horizontalLayout.addWidget(self.openOrder)

        self.endOrder = QPushButton("Завершить")
        self.endOrder.setMaximumSize(QtCore.QSize(120, 50))
        self.endOrder.setStyleSheet("border-radius:15px; background-color: rgb(143, 202, 155);border:0px;")
        self.horizontalLayout.addWidget(self.endOrder)

        self.cancelOrder = QPushButton("Отменить")
        self.cancelOrder.setMaximumSize(QtCore.QSize(120, 50))
        self.cancelOrder.setStyleSheet("border-radius:15px; background-color: rgb(255, 0, 0);color:white;border:0px solid white;")
        self.horizontalLayout.addWidget(self.cancelOrder)

        self.table_label.setText(f"Стол №{order_data[1]}")
        self.order_sum_label.setText(f"{order_data[3]} руб.")
        self.time_label.setText(f"{order_data[4]}")
        self.status_label.setText(f"{order_data[2]}")
        self.frame.setLayout(self.horizontalLayout)


if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    window = OrderManagementWidget((1, 5, "В работе", 1250, "19:30"))
    window.show()
    sys.exit(app.exec())