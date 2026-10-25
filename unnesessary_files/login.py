from PyQt6.QtWidgets import QApplication, QWidget, QMessageBox
from unnesessary_files.avtorization_ui import LoginForm
import pymysql as psql
from main import WaiterWin

try:
    conn = psql.connect(host="localhost", user="root", password="", database="restaurant")
    print("BD connect OK")
except Exception as e:
    print(e)

def universal_query(sql, params=None):
    cursor = conn.cursor()
    if params:
        cursor.execute(sql, params)
    else:
        cursor.execute(sql)
    res = cursor.fetchall()
    cursor.close()
    return res


class LogWin(QWidget, LoginForm):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.pushButton.clicked.connect(self.check_login)

    def check_login(self):
        try:
            login = self.lineEdit.text().strip()
            passw = self.lineEdit_2.text().strip()
            result = universal_query("SELECT role FROM users WHERE username = %s AND password = %s", (login, passw))
            if not result:
                QMessageBox.information(self, "Ошибка", "Введен неправильный логин или пароль")
                self.lineEdit.clear()
                self.lineEdit_2.clear()
                return

            role = result[0][0]
            user_id = universal_query("SELECT user_id FROM users WHERE username = %s", (login,))[0][0]
            if role == 'официант':
                self.new_window = WaiterWin(user_id)
            self.new_window.show()
            self.close()
        except Exception as e:
            print(e)

if __name__ == "__main__":
    import sys
    app = QApplication(sys.argv)
    window = LogWin()
    window.show()
    sys.exit(app.exec())