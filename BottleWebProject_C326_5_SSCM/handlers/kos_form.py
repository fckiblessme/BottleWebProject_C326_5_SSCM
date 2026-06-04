from bottle import route, request, redirect, template
import json
from datetime import datetime
import os

#название папки для хранения данных 
DATA_DIR = 'data'
#формирование полного пути к файлу с результатами
KOS_FILE = os.path.join(DATA_DIR, 'kos_result.json')

def kosaraju(G, n):

#Построение транспонированной матрицы
    GT = [[0] * n for _ in range(n)]
    for u in range(n):
        for v in range(n):
            if G[u][v] == 1:
                GT[v][u] = 1

#Первый обход DFS1
    visited = [False] * n
    stack = []

    def dfs1(v):
        visited[v] = True 
        for u in range(n):
            if G[v][u] == 1 and not visited[u]:
                dfs1(u)
        stack.append(v)

# Запуск dfs1 для всех вершин, которые ещё не посещены
    for v in range(n):
        if not visited[v]:
            dfs1(v)

#Второй обход DFS2 
    visited = [False] * n
    components = []
    count = 0

    def dfs2(v, current_component):
        visited[v] = True
        current_component.append(v + 1)
        for u in range(n):
            if GT[v][u] == 1 and not visited[u]:
                dfs2(u, current_component)

#Извлечение вершины из стека
    while stack:
        v = stack.pop()
        if not visited[v]:
            count += 1
            current_component = []
            dfs2(v, current_component)
            components.append(current_component)

    return count, components

#Сохранение результатов вычислений
def safe_json(n, G, result_count, result_components, input_filename = None):
    #Время
    timestamp = datetime.now()

    #Формирование данных для сохранения
    current_data = {
        "Время": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "Ввод": {
            "N": n,
            "G": G 
            },
        "Вывод": {
            "count": result_count,
            "components": result_components
            }
        }

    #Сохранение информации о данных, если были загружены из файла
    if input_filename:
        current_data["source_file"] = input_filename

    #Создание папки data, если её ещё нет
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)

    #Чтение старой истории для дозаписи
    history = []
    
    #Если файл уже существует и не пустой, считываем его
    if os.path.exists(KOS_FILE) and os.path.getsize(KOS_FILE) > 0:
        try:
            with open(KOS_FILE, 'r', encoding='utf-8') as f:
                history = json.load(f)
                if not isinstance(history, list):
                    history = [history]
        except (json.JSONDecodeError, IOError):
            #Если файл поврежден, перезапишем его как новый список
            history = []

    #Добавляем новый запуск в список
    history.append(current_data)

    #Запись в файл
    with open(KOS_FILE, 'w', encoding='utf-8') as f:
        json.dump(history, f, ensure_ascii=False, indent=2)
        
    return KOS_FILE

#Преобразование текста из формы в матрицу смежности
def g_from_form(g_text, n):
    G = [[0] * n for _ in range(n)]
    #Разбитие текста на отдельные строки
    rows = g_text.strip().split('\n')
    
    #Проход по вем строкам матрицы
    for u in range(n):
        if u >= len(rows):
            raise ValueError(f"Не хватает строк. Ожидается {n} строк, получено {len(rows)}")
        
        #Разбитие текущей строки на отдельные числа
        values = rows[u].strip().split()
        
        #Проход по всем столбцам матрицы
        for v in range(n):
            if v >= len(values):
                raise ValueError(f"Строка {u+1}: не хватает чисел. Ожидается {n} чисел")
            
            #Преобразование значения в целое число 
            try:
                val = int(values[v])
            except ValueError:
                raise ValueError(f"В строке {u+1}, столбце {v+1}: введено не число. Нужно 0 или 1")
            
            #Проверка, чтобы значение было 0 или 1
            if val not in [0, 1]:
                raise ValueError(f"В строке {u+1}, столбце {v+1}: значение {val} не подходит. Нужно 0 или 1")
            
            #Запись значения в матрицу
            G[u][v] = val
    #Возврат заполненной матрицы
    return G

#Проверка на корректность матрицы смежности
def validate_G(G, n):
    if len(G) != n:
        return False, f"Размер матрицы {len(G)}x{len(G)} не соответствует n = {n}"
    for u in range(n):
        if len(G[u]) != n:
            return False, f"Строка {u+1} имеет неверную длину"
        
        #Проход по всем элементам строки
        for v in range(n):
            #Элемент должен быть числом
            if not isinstance(G[u][v], (int, float)):
                return False, f"Элемент [{u+1}][{v+1}] должен быть числом (0 или 1)"
            #На главной диагонали должны быть 0
            if u == v and G[u][v] != 0:
                return False, f"Элемент на диагонали [{u+1}][{u+1}] должен быть 0"
            #Значение должно быть 0 или 1
            if G[u][v] not in [0, 1]:
                return False, f"Элемент [{u+1}][{v+1}] должен быть 0 или 1"

#При прохождении всех проверок, возвращем True
    return True, None

#Генерация текстового описания решения
def generate_solution_text(G, n, components):

    #Создание пустого списка для накопления строк результата 
    lines = []

    #Заголовок списка ребер
    lines.append("Ребра графа:")

    #Флаг для отслеживания наличия ребер
    has_edges = False
    #Проход по всей матрице для поиска ребер
    for u in range(n):
        for v in range(n):
            #Если есть ребро из u в v
            if G[u][v] == 1:
                #Добавление строки с ребром
                lines.append(f"{u+1} → {v+1}")
                has_edges = True

    #Вывод сообщения при отсутствии ребер
    if not has_edges:
        lines.append("Граф не содержит рёбер")

    #Добавление пустой строки для разделения
    lines.append("")
    #Склейка всех строк через перенос строки
    return "\n".join(lines)




    


