def solve_knapsack_tree(edges, weights, values, n, W):
    """
    Решает задачу о рюкзаке на дереве с использованием жадного алгоритма.

    Алгоритм работы:
    1. Сортирует все вершины по убыванию ценности
    2. Последовательно пытается добавить каждую вершину, проверяя:
       - Не превышает ли общий вес максимальный W
       - Выбраны ли все родители данной вершины
    3. После первого прохода делает дополнительный проход для добавления
       пропущенных вершин, которые теперь могут поместиться

    Условие задачи:
    - Каждая вершина имеет вес и ценность
    - Если вершина выбрана, то её родительская вершина также должна быть выбрана
    - Необходимо максимизировать суммарную ценность при ограничении на общий вес

    edges : list of tuples
        Список рёбер дерева. Каждое ребро представлено кортежем (u, v),
        где u и v — номера вершин (от 1 до n).

    weights : list
        Список весов вершин. Индексация начинается с 1!
        weights[0] — фиктивный элемент (обычно 0),
        weights[i] — вес вершины i (где i от 1 до n).

    values : list
        Список ценностей вершин. Индексация начинается с 1!
        values[0] — фиктивный элемент (обычно 0),
        values[i] — ценность вершины i (где i от 1 до n).

    n : int
        Количество вершин в дереве (1 ≤ n ≤ 20 по ограничениям)

    W : int
        Максимальный вес рюкзака (вместимость).
        Ограничение: 1 ≤ W ≤ 100

    Возвращаемое значение:
        - max_value (int): максимальная достигнутая суммарная ценность
        - selected_vertices (set): множество выбранных вершин (номера от 1 до n)

    - Данная реализация использует жадный подход и не гарантирует
      нахождение глобального оптимума для всех случаев.
    - Алгоритм работает за O(n²) времени, где n — количество вершин.
    - Для точного решения рекомендуется использовать динамическое
      программирование (DP на дереве).
    - Входные данные должны представлять корректное дерево (связный граф без циклов).

    - n ≤ 20 (по интерфейсу, но алгоритм может работать и с большими значениями)
    - W ≤ 100
    - Веса и ценности — целые положительные числа
    - Количество рёбер должно быть ровно n-1
    """

    # Создаём список вершин
    items = []
    for i in range(1, n + 1):
        items.append({
            'id': i,
            'weight': weights[i],
            'value': values[i]
        })

    # Сортируем по ценности (от большей к меньшей)
    items.sort(key=lambda x: x['value'], reverse=True)

    selected = set()
    current_weight = 0
    current_value = 0

    # Строим дерево для проверки родителей
    children = {}
    parents = {}
    for u, v in edges:
        children.setdefault(u, []).append(v)
        children.setdefault(v, []).append(u)
        parents[v] = u
        parents[u] = v

    # Функция проверки, можно ли добавить вершину
    def can_add(vertex, current_selected):
        """
        Проверяет, можно ли добавить вершину в текущее решение.

        Параметры:
            vertex (int): номер проверяемой вершины
            current_selected (set): множество уже выбранных вершин

        Возвращает:
            bool: True если вершину можно добавить, иначе False
        """
        # Если вершина уже выбрана
        if vertex in current_selected:
            return False

        # Проверяем родителей (для дерева, где корень 1)
        # Простая проверка: если вершина не корень, её родитель должен быть выбран
        for u, v in edges:
            if v == vertex and u not in current_selected and u != vertex:
                # Родитель не выбран - нельзя
                return False
            if u == vertex and v not in current_selected and v != vertex:
                # Это родитель для кого-то, но это не страшно
                pass
        return True

    # Выбираем вершины
    for item in items:
        if current_weight + item['weight'] <= W and can_add(item['id'], selected):
            selected.add(item['id'])
            current_weight += item['weight']
            current_value += item['value']

    # Дополнительный проход: проверяем, можно ли добавить что-то ещё
    changed = True
    while changed:
        changed = False
        for item in items:
            if item['id'] not in selected and current_weight + item['weight'] <= W:
                # Проверяем, что все родители выбраны
                ok = True
                for u, v in edges:
                    if v == item['id'] and u not in selected:
                        ok = False
                        break
                    if u == item['id'] and v not in selected:
                        # Это нормально, дети могут быть не выбраны
                        pass
                if ok:
                    selected.add(item['id'])
                    current_weight += item['weight']
                    current_value += item['value']
                    changed = True

    return current_value, selected

def build_graph(edges, n):
    """
    Строит граф из списка рёбер.

    Параметры:
        edges (list): список рёбер [(u1, v1), (u2, v2), ...]
        n (int): количество вершин

    Возвращает:
        dict: словарь смежности {vertex: [neighbors]}

    """
    g = {i: [] for i in range(1, n + 1)}
    for u, v in edges:
        g[u].append(v)
        g[v].append(u)
    return g


def calculate_total_weight(selected, weights):
    """
    Вычисляет суммарный вес выбранных вершин.

    Параметры:
        selected (set): множество выбранных вершин
        weights (list): список весов (индексация с 1)

    Возвращает:
        int: суммарный вес
    """
    return sum(weights[v] for v in selected)


def calculate_total_value(selected, values):
    """
    Вычисляет суммарную ценность выбранных вершин.

    Параметры:
        selected (set): множество выбранных вершин
        values (list): список ценностей (индексация с 1)

    Возвращает:
        int: суммарная ценность
    """
    return sum(values[v] for v in selected)