from bottle import request, redirect, template
from datetime import datetime
import random
import itertools
import json
import os



def checking_n(n):
    """Проверяет корректность введённого количества вершин"""
    # Проверка на пустое значение
    if not n or n.strip() == "":
        return False, "Количество вершин не может быть пустым"
    # Проверка, что введено целое число
    try:
        n = int(n)
    except ValueError:
        return False, "Количество вершин должно быть целым числом"

    # Проверка нижней границы
    if n < 2:
        return False, "Количество вершин должно быть не менее 2"

    # Проверка верхней границы
    if n > 12:
        return False, "Количество вершин не должно превышать 12"

    return True, None


def checking_cell(value, i, j):
    """Проверяет корректность значения в ячейке матрицы"""
    # Проверка на пустое значение
    if not value or value.strip() == "":
        return False, f"Ячейка ({i}, {j}) не заполнена. Заполните все ячейки матрицы"

    # Проверка на отрицательное число
    stripped = value.strip()
    if stripped[0] == '-':
        return False, f"Ячейка ({i}, {j}) содержит отрицательное значение. Введите положительное число"

    # Проверка, что строка состоит только из цифр
    if not stripped.isdigit():
        # Проверка, что строка состоит только из целых чисел
        try:
            float_val = float(stripped)
            return False, f"Ячейка ({i}, {j}) содержит дробное число. Введите целое число"
        except ValueError:
            return False, f"Ячейка ({i}, {j}) содержит недопустимые символы. Введите целое положительное число"

    # Проверка, что число больше нуля
    try:
        int_val = int(stripped)
        if int_val <= 0:
            return False, f"Ячейка ({i}, {j}) должна содержать положительное число больше нуля"
    except ValueError:
        return False, f"Ячейка ({i}, {j}) содержит недопустимое значение"

    return True, None


def get_matrix_from_form(n):
    """Собирает матрицу смежности из данных формы"""
    matrix = []
    # Перебор строк
    for i in range(n):
        row = []
        for j in range(n):
            # Диагональ 0 
            if i == j:
                row.append(0)
            else:
                # Значение из формы
                val = request.forms.getunicode(f'm{i+1}{j+1}')
                try:
                    # Преобразование в число
                    row.append(int(val) if val else 0)
                except (ValueError, TypeError):
                    row.append(0)
        # Добавление строки в матрицу
        matrix.append(row)
    return matrix


def get_random_matrix(n):
    """Генерирует случайную симметричную матрицу расстояний"""
    # Создание матрицы NxN
    matrix = [[0]*n for _ in range(n)]
    # Перебор строк
    for i in range(n):
        # Только над диагональю
        for j in range(i+1, n):
            # Заполнение матрицы
            v = random.randint(1, 100)
            matrix[i][j] = v
            matrix[j][i] = v
    return matrix

# Максимальное количество путей для отображения на странице
max_display_paths = 50


def solve_tsp(matrix):
    """Решает задачу коммивояжёра методом полного перебора"""
    # Количество вершин
    n = len(matrix)
    # Список вершин для перестановок
    vertices = list(range(1, n))

    # Минимальное найденное расстояние
    best_distance = float("inf")
    # Лучший найденный маршрут
    best_route = None

    # Список всех маршрутов для отображения 
    all_paths = []
    # Счётчик всех перебранных маршрутов
    total_paths = 0

    # Перебир всех перестановок
    for idx, path in enumerate(itertools.permutations(vertices)):
        # Увеличение счётчика
        total_paths += 1

        # Полный маршрут
        full_path = (0,) + path + (0,)

        # Вес текущего маршрута
        distance = 0
        # Слагаемые для отображения вычислений
        steps = []

        # Счёт расстояния по рёбрам маршрута
        for i in range(len(full_path) - 1):
            # Вес ребра между текущей и следующей вершиной
            w = matrix[full_path[i]][full_path[i+1]]
            # Прибавление к общему весу
            distance += w
            steps.append(str(w))

        # Формирование строки для отображения
        path_str = " → ".join(str(v+1) for v in full_path)
        calc_str = " + ".join(steps) + f" = <strong>{distance}</strong>"

        # Если маршрут короче минимального
        if distance < best_distance:
            best_distance = distance
            best_route = full_path

        # Добавление в список для отображения
        if idx < max_display_paths:
            all_paths.append((path_str, calc_str))

    # Приведение лучшего маршрута к нумерации с 1
    best_route = [v + 1 for v in best_route]

    # Формирование расшифровки вычисления для оптимального маршрута
    best_steps = []
    for i in range(len(best_route) - 1):
        w = matrix[best_route[i]-1][best_route[i+1]-1]
        best_steps.append(str(w))
    best_calc = " + ".join(best_steps) + f" = <strong>{best_distance}</strong>"

    # Формирование HTML со списком всех маршрутов
    result_html = ''

    result_html += '<div class="tsp-paths-list">'

    for path_str, calc_str in all_paths:
        result_html += '<div class="tsp-path-row">'
        result_html += f'<span class="tsp-path-route">{path_str}</span>'
        result_html += f'<span class="tsp-path-separator"></span>'
        result_html += f'<span class="tsp-path-calc">{calc_str}</span>'
        result_html += '</div>'

    result_html += '</div>'

    # Если маршрутов больше лимит
    if total_paths > max_display_paths:
        result_html += (
            '<div class="tsp-paths-info">'
        )
        result_html += f'Показано первых {max_display_paths} маршрутов из {total_paths}'
        result_html += '</div>'

    return result_html, best_route, best_distance, best_calc

# Путь к файлу с результатами
tsp_result_file = 'static/content/data/tsp_results.json'

def load_tsp_results():
    """Загрузка всех сохранённых результатов TSP"""
    if os.path.exists(tsp_result_file):
        try:
            # Открытие для чтения
            f = open(tsp_result_file, 'r', encoding='utf-8')
            # Загрузка JSON
            results = json.load(f)
            f.close()
            return results
        except:
            return []
    else:
        return []


def save_tsp_result(matrix, best_route, best_distance):
    """Сохраняет результат решения TSP в JSON-файл"""
    folder = os.path.dirname(tsp_result_file)
    if not os.path.exists(folder):
        os.makedirs(folder, exist_ok=True)
    
    # Существующие результаты
    results = load_tsp_results()

    # Запись с данными
    new_result = {
        "datetime": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "matrix": matrix,
        "best_route": best_route,
        "best_distance": best_distance
    }

    # Добавление новой записи в начало списка
    results.insert(0, new_result)

    # Сохранение
    try:
        f = open(tsp_result_file, 'w', encoding='utf-8')
        json.dump(results, f, ensure_ascii=False, indent=4)
        f.close()
        return True
    except Exception as e:
        print(f"Ошибка при записи файла tsp_results.json: {e}")
        return False


def render_tsp_result(n, matrix):
    """Решает TSP для переданной матрицы и возвращает заполненный шаблон"""
    # Решение TSP
    result, route, best_distance, best_calc = solve_tsp(matrix)
    # Формирование строки маршрута
    best_route_str = " → ".join(str(v) for v in route)

    # Возвращение заполненного шаблона
    return template('tsp',
        year=datetime.now().year,
        n=n,
        matrix=matrix,
        error=None,
        result=result,
        route=str(route),
        best_distance=best_distance,
        best_calc=best_calc,
        best_route_str=best_route_str,
        matrix_data=json.dumps(matrix)
    )

def handle_post():
    """Главный обработчик всех POST-запросов к странице TSP"""
    # Если нажата кнопка "Сохранить в файл"
    if request.forms.get('save'):
        # Матрица из скрытого поля
        matrix_str = request.forms.get('matrix_data')
        # Маршрут
        route_str = request.forms.get('route_data')
        # Минимальный вес
        best_distance_str = request.forms.get('best_distance_data')

        try:
            # Преобразование матрицы из JSON-строки в список
            matrix = json.loads(matrix_str)
            # Преобразование маршрута
            route = json.loads(route_str)
            # Преобразование веса в число
            best_distance = int(best_distance_str)

            # Сохранение в файл
            success = save_tsp_result(matrix, route, best_distance)

            if success:
                return json.dumps({"success": True})
            else:
                return json.dumps({"success": False, "error": "Ошибка записи в файл"})
        except Exception as e:
            return json.dumps({"success": False, "error": str(e)})

    # Получение N из формы
    n = request.forms.get('n')

    # Проверка на корректность
    ok, error = checking_n(n)
    # Страница с ошибкой
    if not ok:
        return template('tsp',
            year=datetime.now().year,
            n=None,
            matrix=None,
            error=error,
            result=None,
            route=None,
            best_distance=None,
            best_calc=None,
            best_route_str=None
        )

    # Преобразование N в целое число
    n = int(n)

    # Кнопка "Создать"
    if request.forms.get('create'):
        # Перенаправление на страницу с якорем к форме
        return redirect(f'/tsp?n={n}#inputForm')

    # Кнопка "Случайные значения" 
    if request.forms.get('random'):
        # Генерирация случайной матрицы
        matrix = get_random_matrix(n)
        return render_tsp_result(n, matrix)

    # Кнопка "Подтвердить ввод"
    if request.forms.get('submit'):

        # Проверка всех ячеек матрицы на корректность
        for i in range(1, n+1):
            for j in range(1, n+1):
                if i != j:
                    # Значение ячейки
                    val = request.forms.getunicode(f'm{i}{j}')
                    # Проверка
                    ok, error = checking_cell(val, i, j)
                    # При ошибке сбор матрицы без конвертации
                    if not ok:
                        matrix = []
                        for ii in range(n):
                            row = []
                            for jj in range(n):
                                if ii == jj:
                                    row.append(0)
                                else:
                                    raw_val = request.forms.getunicode(f'm{ii+1}{jj+1}')
                                    row.append(raw_val if raw_val else 0)
                            # Сохранение
                            matrix.append(row)
                        # Возвращение страницы с ошибкой
                        return template('tsp',
                            year=datetime.now().year,
                            n=n,
                            matrix=matrix,
                            error=error,
                            result=None,
                            route=None,
                            best_distance=None,
                            best_calc=None,
                            best_route_str=None
                        )
        # Сбор матрицы из формы
        matrix = get_matrix_from_form(n)
        return render_tsp_result(n, matrix)

    return redirect(f'/tsp?n={n}#inputForm')