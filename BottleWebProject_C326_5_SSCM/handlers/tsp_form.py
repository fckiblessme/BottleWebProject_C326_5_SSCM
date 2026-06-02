from bottle import request, redirect, template
import random
import itertools


max_display_paths = 50

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

