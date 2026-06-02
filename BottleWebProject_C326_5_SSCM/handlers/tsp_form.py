from bottle import request, redirect, template
from datetime import datetime
import random
import itertools
import json
import os



def checking_n(n):
    if not n or n.strip() == "":
        return False, "Количество вершин не может быть пустым"

    try:
        n = int(n)
    except ValueError:
        return False, "Количество вершин должно быть целым числом"

    if n < 2:
        return False, "Количество вершин должно быть не менее 2"

    if n > 12:
        return False, "Количество вершин не должно превышать 12"

    return True, None


def checking_cell(value, i, j):
    if not value or value.strip() == "":
        return False, f"Ячейка ({i}, {j}) не заполнена. Заполните все ячейки матрицы"

    stripped = value.strip()
    if stripped[0] == '-':
        return False, f"Ячейка ({i}, {j}) содержит отрицательное значение. Введите положительное число"

    if not stripped.isdigit():
        try:
            float_val = float(stripped)
            return False, f"Ячейка ({i}, {j}) содержит дробное число. Введите целое число"
        except ValueError:
            return False, f"Ячейка ({i}, {j}) содержит недопустимые символы. Введите целое положительное число"

    try:
        int_val = int(stripped)
        if int_val <= 0:
            return False, f"Ячейка ({i}, {j}) должна содержать положительное число больше нуля"
    except ValueError:
        return False, f"Ячейка ({i}, {j}) содержит недопустимое значение"

    return True, None


def get_matrix_from_form(n):
    matrix = []
    for i in range(n):
        row = []
        for j in range(n):
            if i == j:
                row.append(0)
            else:
                val = request.forms.getunicode(f'm{i+1}{j+1}')
                try:
                    row.append(int(val) if val else 0)
                except (ValueError, TypeError):
                    row.append(0)
        matrix.append(row)
    return matrix

def get_random_matrix(n):
    matrix = [[0]*n for _ in range(n)]
    for i in range(n):
        for j in range(i+1, n):
            v = random.randint(1, 100)
            matrix[i][j] = v
            matrix[j][i] = v
    return matrix

max_display_paths = 50

def solve_tsp(matrix):
    n = len(matrix)

    vertices = list(range(1, n))

    best_distance = float("inf")
    best_route = None

    all_paths = []
    total_paths = 0

    for idx, path in enumerate(itertools.permutations(vertices)):
        total_paths += 1

        full_path = (0,) + path + (0,)

        distance = 0
        steps = []

        for i in range(len(full_path) - 1):
            w = matrix[full_path[i]][full_path[i+1]]
            distance += w
            steps.append(str(w))

        path_str = " → ".join(str(v+1) for v in full_path)
        calc_str = " + ".join(steps) + f" = <strong>{distance}</strong>"

        if distance < best_distance:
            best_distance = distance
            best_route = full_path

        if idx < max_display_paths:
            all_paths.append((path_str, calc_str))

    best_route = [v + 1 for v in best_route]

    best_steps = []
    for i in range(len(best_route) - 1):
        w = matrix[best_route[i]-1][best_route[i+1]-1]
        best_steps.append(str(w))
    best_calc = " + ".join(best_steps) + f" = <strong>{best_distance}</strong>"

    result_html = ''

    result_html += '<div class="tsp-paths-list">'

    for path_str, calc_str in all_paths:
        result_html += '<div class="tsp-path-row">'
        result_html += f'<span class="tsp-path-route">{path_str}</span>'
        result_html += f'<span class="tsp-path-separator"></span>'
        result_html += f'<span class="tsp-path-calc">{calc_str}</span>'
        result_html += '</div>'

    result_html += '</div>'

    if total_paths > max_display_paths:
        result_html += (
            '<div class="tsp-paths-info">'
        )
        result_html += f'Показано первых {max_display_paths} маршрутов из {total_paths}'
        result_html += '</div>'

    return result_html, best_route, best_distance, best_calc

tsp_result_file = 'static/content/data/tsp_results.json'

def load_tsp_results():
    """Загрузка всех сохранённых результатов TSP"""
    if os.path.exists(tsp_result_file):
        try:
            f = open(tsp_result_file, 'r', encoding='utf-8')
            results = json.load(f)
            f.close()
            return results
        except:
            return []
    else:
        return []


def save_tsp_result(matrix, best_route, best_distance):
    folder = os.path.dirname(tsp_result_file)
    if not os.path.exists(folder):
        os.makedirs(folder, exist_ok=True)

    results = load_tsp_results()

    new_result = {
        "datetime": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "matrix": matrix,
        "best_route": best_route,
        "best_distance": best_distance
    }

    results.insert(0, new_result)

    try:
        f = open(tsp_result_file, 'w', encoding='utf-8')
        json.dump(results, f, ensure_ascii=False, indent=4)
        f.close()
        return True
    except Exception as e:
        print(f"Ошибка при записи файла tsp_results.json: {e}")
        return False

def handle_post():

    if request.forms.get('save'):
        matrix_str = request.forms.get('matrix_data')
        route_str = request.forms.get('route_data')
        best_distance_str = request.forms.get('best_distance_data')

        try:
            matrix = json.loads(matrix_str)
            route = json.loads(route_str)
            best_distance = int(best_distance_str)

            success = save_tsp_result(matrix, route, best_distance)

            if success:
                return json.dumps({"success": True})
            else:
                return json.dumps({"success": False, "error": "Ошибка записи в файл"})
        except Exception as e:
            return json.dumps({"success": False, "error": str(e)})

    n = request.forms.get('n')

    ok, error = checking_n(n)

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

    n = int(n)

    if request.forms.get('create'):
        return redirect(f'/tsp?n={n}#inputForm')

    if request.forms.get('random'):
        matrix = get_random_matrix(n)
        result, route, best_distance, best_calc = solve_tsp(matrix)
        best_route_str = " → ".join(str(v) for v in route)

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

    if request.forms.get('submit'):

        for i in range(1, n+1):
            for j in range(1, n+1):
                if i != j:
                    val = request.forms.getunicode(f'm{i}{j}')
                    ok, error = checking_cell(val, i, j)
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
                            matrix.append(row)

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

        matrix = get_matrix_from_form(n)
        result, route, best_distance, best_calc = solve_tsp(matrix)
        best_route_str = " → ".join(str(v) for v in route)

        return template('tsp',
            year=datetime.now().year,
            n=n,
            matrix=matrix,
            error=error,
            result=result,
            route=str(route),
            best_distance=best_distance,
            best_calc=best_calc,
            best_route_str=best_route_str,
            matrix_data=json.dumps(matrix)
        )

    return redirect(f'/tsp?n={n}#inputForm')