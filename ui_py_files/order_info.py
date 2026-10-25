from PyQt6 import QtCore
from PyQt6.QtWidgets import QWidget, QApplication, QPushButton, QHBoxLayout, QLabel, QFrame, QVBoxLayout


class OrderInfoWidget(QWidget):
    def __init__(self, order_data, parent=None):
        super().__init__(parent)
        main_layout = QVBoxLayout(self)

        self.frame = QFrame(self)
        self.frame.setStyleSheet("border:1px solid grey; border-radius:15px;")
        self.frame.setFixedSize(400, 100)
        frameLayout = QVBoxLayout(self.frame)
        for dish in order_data:
            dish_layout = QHBoxLayout()

            name_label = QLabel(dish[0])
            name_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
            name_label.setStyleSheet("border:0px;font-size:14px;font-weight:bold;")

            price_label = QLabel(f"{dish[1]} руб.")
            price_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
            price_label.setStyleSheet("border:0px;font-size:14px;color:red;")

            amount_label = QLabel(f"{dish[2]}")
            amount_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
            amount_label.setStyleSheet("border:0px;font-size:14px;")

            dish_layout.addWidget(name_label)
            dish_layout.addWidget(price_label)
            dish_layout.addWidget(amount_label)

            frameLayout.addLayout(dish_layout)
        main_layout.addWidget(self.frame)

if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    test_order = [
        ("Цезарь", 450, 2),
        ("Борщ", 320, 1),
        ("Чизкейк", 350, 3)
    ]

    window = OrderInfoWidget(test_order)
    window.show()
    sys.exit(app.exec())