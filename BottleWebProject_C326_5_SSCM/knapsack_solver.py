"""
Решатель задачи о рюкзаке на дереве - УПРОЩЁННАЯ ВЕРСИЯ
"""

def solve_knapsack_tree(edges, weights, values, n, W):
    """
    Простое решение: выбираем вершины с максимальной ценностью,
    которые помещаются по весу и соблюдают условие родитель-потомок
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
        # Если вершина уже выбрана
        if vertex in current_selected:
            return False

        # Проверяем родителей (для дерева, где корень 1)
        # Простая проверка: если вершина не корень, её родитель должен быть выбран
        # Находим родителя в рёбрах
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