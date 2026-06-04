import os
import json
import time
import unittest
import shutil
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import UnexpectedAlertPresentException, TimeoutException, NoAlertPresentException

class VertexCoverInterfaceTest(unittest.TestCase):

    def setUp(self):
        # Создаем изолированную директорию для скачивания внутри папки тестов
        self.current_dir = os.path.dirname(os.path.abspath(__file__))
        self.download_dir = os.path.join(self.current_dir, "sel_downloads")
        if not os.path.exists(self.download_dir):
            os.makedirs(self.download_dir)

        options = webdriver.ChromeOptions()
        options.add_argument("--start-maximized")
        options.add_argument("--disable-extensions")
        
        # Настройка Chrome для скачивания файлов 
        prefs = {
            "download.default_directory": self.download_dir,
            "download.prompt_for_download": False,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": True
        }
        options.add_experimental_option("prefs", prefs)

        self.driver = webdriver.Chrome(options=options)
    
        self.base_url = "http://127.0.0.1:5555/vertex_cover" 
        
        project_dir = os.path.dirname(self.current_dir)
        json_path = os.path.join(project_dir, "static", "content", "data", "sel_ver.json")
        
        try:
            with open(json_path, "r", encoding="utf-8") as f:
                self.test_data = json.load(f)
        except FileNotFoundError:
            self.test_data = {"tests": []}
            print(f"Файл не найден по пути {json_path}")

    def test_vertex_cover_form_processing(self):
        """Тестирование стандартных сценариев из JSON-файла"""
        driver = self.driver
        if not self.test_data.get("tests"):
            self.skipTest("Нет тестовых сценариев в JSON-файле для запуска")
        
        for test_case in self.test_data["tests"]:
            print(f"\nЗапуск сценария: {test_case['test_id']}")
            driver.get(self.base_url)
            
            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.ID, "graphForm"))
            )
            
            left_input = driver.find_element(By.ID, "inputNLeft")
            right_input = driver.find_element(By.ID, "inputNRight")
            
            left_input.clear()
            left_input.send_keys(str(test_case["n_left"]))
            right_input.clear()
            right_input.send_keys(str(test_case["n_right"]))
            time.sleep(1.5)
            
            clear_btn = driver.find_element(By.CLASS_NAME, "btn-reset")
            driver.execute_script("arguments[0].click();", clear_btn)
            time.sleep(1)
            
            add_edge_btn = driver.find_element(By.CLASS_NAME, "btn-add-edge")
            
            for index, edge in enumerate(test_case["edges"]):
                if index > 0:
                    driver.execute_script("arguments[0].click();", add_edge_btn)
                    time.sleep(0.5) 
                
                from_inputs = driver.find_elements(By.CLASS_NAME, "edge-from")
                to_inputs = driver.find_elements(By.CLASS_NAME, "edge-to")
                
                from_inputs[-1].clear()
                from_inputs[-1].send_keys(str(edge["from"]))
                to_inputs[-1].clear()
                to_inputs[-1].send_keys(str(edge["to"]))
                time.sleep(1)  
            
            print(" Нажатие кнопки расчета")
            time.sleep(1.5)  
            submit_btn = driver.find_element(By.CLASS_NAME, "btn-solve")
            driver.execute_script("arguments[0].click();", submit_btn)
            
            WebDriverWait(driver, 10).until(
                EC.visibility_of_element_located((By.ID, "results-block"))
            )
            
            actual_cover_size = int(driver.find_element(By.ID, "cover-size-output").text)
            expected_cover_size = test_case["expected_cover_size"]
            
            self.assertEqual(actual_cover_size, expected_cover_size,
                             f"Ошибка в {test_case['test_id']}: Получено {actual_cover_size}, ожидалось {expected_cover_size}!")
            
            print(f"Сценарий {test_case['test_id']} успешно выполнен! Ответ совпадает с ожидаемым")
            time.sleep(4)  

    def test_vertex_cover_invalid_inputs(self):
        """Тестирование валидации некорректных значений"""
        driver = self.driver
        driver.get(self.base_url)
        
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "graphForm"))
        )
        
        left_input = driver.find_element(By.ID, "inputNLeft")
        right_input = driver.find_element(By.ID, "inputNRight")
        
        left_input.clear()
        left_input.send_keys("5")
        right_input.clear()
        right_input.send_keys("5")
        time.sleep(2)  
        
        print("Ввод невалидного ребра")
        from_input = driver.find_element(By.CLASS_NAME, "edge-from")
        to_input = driver.find_element(By.CLASS_NAME, "edge-to")
        
        from_input.clear()
        from_input.send_keys("1")
        to_input.clear()
        to_input.send_keys("20") 
        time.sleep(3)  
        
        try:
            submit_btn = driver.find_element(By.XPATH, "//*[contains(text(), 'Найти минимальное покрытие')]")
        except:
            submit_btn = driver.find_element(By.CLASS_NAME, "btn-solve")
            
        driver.execute_script("arguments[0].click();", submit_btn)
        
        time.sleep(4) 
        try:
            alert = driver.switch_to.alert
            alert_text = alert.text
            print(f"Текст перехваченной ошибки во время запуска: {alert_text}")
            
            self.assertIn("Ошибка", alert_text)
            time.sleep(2) 
            alert.accept() 
            print("Тест валидации границ успешно пройден")
            time.sleep(2)  
        except NoAlertPresentException:
            self.fail("Кнопка расчета нажата, но предупреждение исчезло или не появилось")

    def test_vertex_cover_export_to_json(self):
        """Тестирование сохранения введенного графа в файл JSON"""
        driver = self.driver
        driver.get(self.base_url)
        
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "graphForm"))
        )
        
        left_input = driver.find_element(By.ID, "inputNLeft")
        right_input = driver.find_element(By.ID, "inputNRight")
        
        left_input.clear()
        left_input.send_keys("3")
        right_input.clear()
        right_input.send_keys("3")
        time.sleep(1.5)
        
        from_input = driver.find_element(By.CLASS_NAME, "edge-from")
        to_input = driver.find_element(By.CLASS_NAME, "edge-to")
        from_input.clear()
        from_input.send_keys("1")
        to_input.clear()
        to_input.send_keys("4")
        time.sleep(2)  
        
        # Поиск кнопки сохранения по тексту или классу
        try:
            export_btn = driver.find_element(By.XPATH, "//*[contains(text(), 'Сохранить') or contains(text(), 'JSON')]")
        except:
            export_btn = driver.find_element(By.CLASS_NAME, "btn-export") 
            
        print("Нажатие кнопки сохранения")
        driver.execute_script("arguments[0].click();", export_btn)

        time.sleep(3) 

        # Цикл ожидания появления любого .json файла в изолированной папке скачивания 
        downloaded_file = None
        for _ in range(10):
            files = [f for f in os.listdir(self.download_dir) if f.endswith('.json')]
            if files:
                downloaded_file = os.path.join(self.download_dir, files[0])
                break
            time.sleep(0.5)
                
        self.assertIsNotNone(downloaded_file, "Файл JSON не был скачан или кнопка не сработала")
        print(f"Файл успешно перехвачен: {os.path.basename(downloaded_file)}")
        
        # Читаем скачанный файл и проверяем, что структура внутри валидна
        with open(downloaded_file, "r", encoding="utf-8") as f:
            exported_data = json.load(f)
        
        print(f"Содержимое скачанного файла: {exported_data}")
        
        self.assertTrue("n_left" in exported_data or "left" in exported_data or "edges" in exported_data, 
                        "Структура экспортированного JSON не содержит ожидаемых параметров графа")
        
        print("Тест на сохранение в JSON успешно выполнен")
        time.sleep(3)  

    def test_vertex_cover_maximum_limits(self):
        """Тестирование на максимальных лимитах (20х20 вершин, полный граф = 400 рёбер)"""
        driver = self.driver
        driver.get(self.base_url)
        
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "graphForm"))
        )
        
        left_input = driver.find_element(By.ID, "inputNLeft")
        right_input = driver.find_element(By.ID, "inputNRight")
        
        left_input.clear()
        left_input.send_keys("20")
        right_input.clear()
        right_input.send_keys("20")
        time.sleep(1.5)

        driver.execute_async_script("""
            const callback = arguments[arguments.length - 1];
            const addButton = document.querySelector(".btn-add-edge");
            const totalEdges = 400;
            let currentEdges = document.querySelectorAll(".edge-from").length;
            
            function addRowAsync() {
                if (currentEdges >= totalEdges) {
                    callback("Генерация структуры завершена");
                    return;
                }
                addButton.click();
                currentEdges++;
                setTimeout(addRowAsync, 0);
            }
            
            addRowAsync();
        """)
        
        print("Заполнение полей")
        driver.execute_script("""
            const fromInputs = document.querySelectorAll(".edge-from");
            const toInputs = document.querySelectorAll(".edge-to");
            
            const nLeft = 20;
            const nRight = 20;
            let index = 0;
            
            for (let left = 1; left <= nLeft; left++) {
                for (let right = 1; right <= nRight; right++) {
                    const globalRightIndex = nLeft + right;
                    
                    if (fromInputs[index] && toInputs[index]) {
                        fromInputs[index].value = left;
                        toInputs[index].value = globalRightIndex;
                        
                        fromInputs[index].dispatchEvent(new Event('input', { bubbles: true }));
                        toInputs[index].dispatchEvent(new Event('change', { bubbles: true }));
                    }
                    index++;
                }
            }
        """)
        
        print("Все 400 рёбер созданы")
        time.sleep(3)
        
        try:
            submit_btn = driver.find_element(By.XPATH, "//*[contains(text(), 'Найти минимальное покрытие')]")
        except:
            submit_btn = driver.find_element(By.CLASS_NAME, "btn-solve")
            
        driver.execute_script("arguments[0].click();", submit_btn)
        
        WebDriverWait(driver, 45).until(
            EC.visibility_of_element_located((By.ID, "results-block"))
        )
        
        actual_cover_size = int(driver.find_element(By.ID, "cover-size-output").text)
        print(f"Результат успешно получен! Размер минимального вершинного покрытия: {actual_cover_size}")
        
        self.assertEqual(actual_cover_size, 20, f"Получено: {actual_cover_size}")
        time.sleep(10)

    def tearDown(self):
        self.driver.quit()
        if os.path.exists(self.download_dir):
            shutil.rmtree(self.download_dir)

if __name__ == "__main__":
    unittest.main()