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


