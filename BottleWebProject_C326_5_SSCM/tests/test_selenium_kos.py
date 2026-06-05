import unittest
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException


class TestKosarajuUI(unittest.TestCase):
    """Тесты интерфейса страницы алгоритма Косарайю"""

    @classmethod
    def setUpClass(cls):
        """Подготовка к запуску тестов. Запускается один раз перед всеми тестами"""
        cls.driver = webdriver.Chrome()
        cls.driver.maximize_window()
        cls.wait = WebDriverWait(cls.driver, 15)
        cls.base_url = "http://localhost:5555/kos"

    @classmethod
    def tearDownClass(cls):
        """Закрытие браузера. Запускается один раз после всех тестов"""
        time.sleep(3)
        cls.driver.quit()

    def setUp(self):
        """Подготовка перед тесстом (Открытие страницы с формой ввода).Запускается перед каждым тестом"""
        self.driver.get(self.base_url)
        time.sleep(2)


    def fill_G_and_solve(self, matrix_data, n):
        """
        Заполнение матрицы смежности и нажатие кнопки "Найти компоненты"
        Возвращает текст результата или ошибки
        """
        #Установка количества вершин
        #Поиск поля для ввода
        input_n = self.driver.find_element(By.ID, "inputN")
        input_n.clear()
        time.sleep(0.5)
        #Ввод значения
        input_n.send_keys(str(n))
        time.sleep(1)

        #Нажатие для появления матрицы
        body = self.driver.find_element(By.TAG_NAME, "body")
        body.click()
        time.sleep(4)

        #Заполнение ячеек матрицы (кроме диагонали)
        for u in range(n):
            for v in range(n):
                if u != v:
                    cell = self.driver.find_element(
                        By.CSS_SELECTOR, 
                        f"input.matrix-cell[data-row='{u}'][data-col='{v}']"
                    )
                    cell.clear()
                    time.sleep(0.1)
                    cell.send_keys(str(matrix_data[u][v]))
        
        time.sleep(3)
        
        #Нажатие кнопки "Найти компоненты"
        submit_btn = self.driver.find_element(By.CLASS_NAME, "btn-solve")
        submit_btn.click()
        time.sleep(10)

        try:
            result = self.wait.until(
                EC.presence_of_element_located((By.CLASS_NAME, "result-success")))
            return "success", result.text
        except TimeoutException:
            self.fail("Результат не появился на странице")




    def test_ui_01(self):
        """UI-01: Четыре вершины - две компоненты"""
        # Данные: цикл 1→2→3→1
        G = [
            [0, 1, 0, 0],
            [1, 0, 0, 0],
            [0, 0, 0, 1],
            [0, 0, 1, 0]
        ]
        
        status, text = self.fill_G_and_solve(G, 4)
        
        #Проверка статуса
        self.assertEqual(status, "success", f"Ожидался успех, получено: {text}")
        
        #Проверка текста
        self.assertIn("Найдено компонент", text)
        
        #Ожидание отрисовки графа
        time.sleep(2)


    def test_ui_02_no_edges(self):
        """UI-03: Граф без рёбер — каждая вершина отдельная компонента"""
        G = [
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ]
        
        status, text = self.fill_G_and_solve(G, 4)
        
        self.assertEqual(status, "success", f"Ожидался успех, получено: {text}")
    
        # Главная проверка: результат есть на странице
        self.assertIn("Найдено компонент", text)
        
        # Ждём отрисовки графа
        time.sleep(2)
        

    def test_ui_03_invalid_input(self):
        """UI-04: Ввод букв вместо цифр — ошибка"""
        # Устанавливаем размер
        input_n = self.driver.find_element(By.ID, "inputN")
        input_n.clear()
        time.sleep(0.5)
        input_n.send_keys("3")
        time.sleep(1.5)

        body = self.driver.find_element(By.TAG_NAME, "body")
        body.click()
        time.sleep(3)
        
        #Ввод буквы в ячейку
        cell = self.driver.find_element(
            By.CSS_SELECTOR, 
            "input.matrix-cell[data-row='0'][data-col='1']"
        )
        cell.clear()
        time.sleep(0.3)
        cell.send_keys("a")
        
        time.sleep(0.5)
        
        #Отправка формы
        submit_btn = self.driver.find_element(By.CLASS_NAME, "btn-solve")
        submit_btn.click()
        time.sleep(5)
        
        #Проверка на ошибку
        error_block = self.driver.find_element(By.CLASS_NAME, "error-msg")
        self.assertIsNotNone(error_block, "Сообщение об ошибке не появилось")



    def test_ui_04_max_G(self):
        """UI-05: Работа с максимальным количеством вершин (14)"""
        n = 14
    
        #Установка количества вершин
        input_n = self.driver.find_element(By.ID, "inputN")
        input_n.clear()
        time.sleep(0.5)
        input_n.send_keys(str(n))
        time.sleep(3)

        body = self.driver.find_element(By.TAG_NAME, "body")
        body.click()
        time.sleep(3)
    
        #Нажатие кнопки "Случайные значения"
        example_btn = self.driver.find_element(By.ID, "btnLoadExample")
        example_btn.click()
        time.sleep(2)
    
        #Отправка формы
        submit_btn = self.driver.find_element(By.CLASS_NAME, "btn-solve")
        submit_btn.click()
        time.sleep(5)
    
        #Проверка, что появился результат
        try:
            result = self.wait.until(EC.presence_of_element_located((By.CLASS_NAME, "result-success")))
            status = "success"
        except TimeoutException:
            status = "error"
    
        #Проверка, что решение успешное
        self.assertEqual(status, "success", "Решение не получено")
    
        #Отрисовка графа
        time.sleep(3)


if __name__ == "__main__":
    unittest.main(verbosity=2)