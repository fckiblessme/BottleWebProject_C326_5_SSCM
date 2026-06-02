from bottle import request, redirect, template


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

