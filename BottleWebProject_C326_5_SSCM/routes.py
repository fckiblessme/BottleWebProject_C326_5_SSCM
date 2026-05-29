from bottle import route, view, template, request
from datetime import datetime
import json

# Импорт решателя
from knapsack_solver import solve_knapsack_tree


@route('/')
@route('/home')
@view('index')
def home():
    return dict(year=datetime.now().year)


@route('/about')
@view('about')
def about():
    return dict(
        title='О проекте',
        message='Описание проекта',
        year=datetime.now().year
    )


@route('/knapsack_tree')
def knapsack_tree():
    """Страница с формой ввода данных."""
    return template('knapsack_tree',
                    title='Задача о рюкзаке на дереве',
                    year=datetime.now().year,
                    n='', w_max='', weights='', values='', edges='',
                    result=None, error=None, max_value=None,
                    selected_vertices=None, total_weight=None,
                    edges_json='[]', weights_json='{}', values_json='{}', selected_json='[]')


@route('/knapsack_tree/solve', method='POST')
def knapsack_tree_solve():
    """Обрабатывает форму и возвращает результат."""
    n_str = request.forms.get('n', '')
    w_max_str = request.forms.get('w_max', '')
    weights_str = request.forms.get('weights', '')
    values_str = request.forms.get('values', '')
    edges_str = request.forms.get('edges', '')

    try:
        n = int(n_str)
        w_max = int(w_max_str)
        weights_list = [0] + list(map(int, weights_str.split()))  # сдвиг индекса
        values_list = [0] + list(map(int, values_str.split()))    # сдвиг индекса
        
        edges = []
        for line in edges_str.strip().split('\n'):
            if line.strip():
                u, v = map(int, line.strip().split())
                edges.append((u, v))

        # Валидация
        if n < 1 or n > 50:
            raise ValueError("N должно быть от 1 до 50")
        if w_max < 1 or w_max > 100:
            raise ValueError("W должно быть от 1 до 100")
        if len(weights_list) - 1 != n:
            raise ValueError(f"Ожидалось {n} весов, получено {len(weights_list)-1}")
        if len(values_list) - 1 != n:
            raise ValueError(f"Ожидалось {n} ценностей, получено {len(values_list)-1}")
        if len(edges) != n - 1:
            raise ValueError(f"Ожидалось {n-1} рёбер, получено {len(edges)}")

        # Решение
        max_value, selected_set = solve_knapsack_tree(edges, weights_list, values_list, n, w_max)
        total_weight = sum(weights_list[v] for v in selected_set)
        selected_vertices = sorted(selected_set)

        return template('knapsack_tree',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=None,
                        max_value=max_value,
                        selected_vertices=' '.join(str(v) for v in selected_vertices),
                        total_weight=total_weight,
                        edges_json=json.dumps(edges),
                        weights_json=json.dumps({i: weights_list[i] for i in range(1, n+1)}),
                        values_json=json.dumps({i: values_list[i] for i in range(1, n+1)}),
                        selected_json=json.dumps(selected_vertices))

    except Exception as e:
        return template('knapsack_tree',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=str(e),
                        max_value=None, selected_vertices=None, total_weight=None,
                        edges_json='[]', weights_json='{}', values_json='{}', selected_json='[]')