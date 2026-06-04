from selenium import webdriver
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
import os
import time

os.environ['WDM_SSL_VERIFY'] = '0'
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service)

# Открытие главной страницы и переход на TSP
driver.get("http://127.0.0.1:8080")
time.sleep(1)

tsp_card = driver.find_element(By.XPATH, "//a[@href='/tsp']")
tsp_card.click()
time.sleep(1)

# Скролл до формы
input_form = driver.find_element(By.ID, "inputForm")
driver.execute_script("arguments[0].scrollIntoView();", input_form)
time.sleep(1)

# Ввод N = 10
n_field = driver.find_element(By.NAME, "n")
n_field.clear()
n_field.send_keys("10")

# Нажатие на кнопку "создать"
create_btn = driver.find_element(By.XPATH, "//button[@name='create']")
create_btn.click()
time.sleep(1)

#  Матрица значений
matrix = [
    [0, 87, 69, 1, 79, 35, 3, 92, 82, 32],
    [87, 0, 10, 80, 99, 41, 90, 92, 66, 40],
    [69, 10, 0, 18, 40, 98, 59, 23, 77, 74],
    [1, 80, 18, 0, 84, 1, 80, 92, 56, 97],
    [79, 99, 40, 84, 0, 24, 65, 84, 41, 80],
    [35, 41, 98, 1, 24, 0, 38, 96, 8, 63],
    [3, 90, 59, 80, 65, 38, 0, 58, 85, 61],
    [92, 92, 23, 92, 84, 96, 58, 0, 9, 36],
    [82, 66, 77, 56, 41, 8, 85, 9, 0, 53],
    [32, 40, 74, 97, 80, 63, 61, 36, 53, 0]
]

for i in range(10):
    for j in range(i+1, 10):
        cell_name = f"m{i+1}{j+1}"
        cell = driver.find_element(By.NAME, cell_name)
        cell.clear()
        cell.send_keys(str(matrix[i][j]))

print("Матрица заполнена значениями")

# 5. Нажатие "Подтвердить ввод"
submit_btn = driver.find_element(By.XPATH, "//button[@name='submit']")
submit_btn.click()
time.sleep(3)

print("Кнопка 'Подтвердить ввод' нажата")

# 6. Скролл до результатов
result_card = driver.find_element(By.CLASS_NAME, "result-card")
driver.execute_script("arguments[0].scrollIntoView();", result_card)
time.sleep(2)

# 7. Открытие "Все возможные маршруты"
routes_summary = driver.find_element(By.XPATH, "//summary[contains(text(), 'Все возможные маршруты')]")
driver.execute_script("arguments[0].scrollIntoView();", routes_summary)
time.sleep(1)
routes_summary.click()
time.sleep(1)

print("Список 'Все возможные маршруты' открыт")

# 8. Нажатие "Сохранить в файл"
save_btn = driver.find_element(By.XPATH, "//button[contains(@class, 'btn-save-tsp')]")
driver.execute_script("arguments[0].scrollIntoView();", save_btn)
time.sleep(0.5)
save_btn.click()
time.sleep(1)

print("Кнопка 'Сохранить в файл' нажата")

time.sleep(5)
driver.quit()