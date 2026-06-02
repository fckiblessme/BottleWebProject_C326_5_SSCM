import json
from datetime import datetime
from bottle import route, post, template, request, view

# Импорты алгоритмов
from knapsack_solver import solve_knapsack_tree
from vertex_cover_form import solve_vertex_cover_algorithm


def build_tree_string(weights_str, values_str, edges_str, selected_str):
    """Строит текстовое представление дерева с подсветкой выбранных вершин."""
    try:
        if not weights_str or not values_str:
            return "Данные дерева отсутствуют"

        weights = [int(x) for x in weights_str.split()]
        values = [int(x) for x in values_str.split()]
        selected = set(int(x) for x in selected_str.split()) if selected_str else set()

        n = len(weights)

        # Строим список смежности (безопасно парсим переносы строк и пробелы)
        adj = {i + 1: [] for i in range(n)}
        
        # Разбиваем и по строкам, и по пробелам, чтобы получить чистые числа рёбер
        edge_nums = []
        for line in edges_str.strip().split('\n'):
            if line.strip():
                edge_nums.extend(map(int, line.strip().split()))

        for i in range(0, len(edge_nums) - 1, 2):
            u, v = edge_nums[i], edge_nums[i + 1]
            if u in adj and v in adj:
                adj[u].append(v)
                adj[v].append(u)

        lines = []

        def dfs(node, parent, prefix=""):
            w = weights[node - 1]
            v = values[node - 1]
            mark = "✅" if node in selected else "❌"
            lines.append(f"{prefix}├── {mark} Вершина {node} (w={w}, v={v})")

            children = [c for c in adj[node] if c != parent]
            for i, child in enumerate(children):
                if i == len(children) - 1:
                    dfs(child, node, prefix + "    ")
                else:
                    dfs(child, node, prefix + "│   ")

        if n > 0:
            dfs(1, -1, "")
        return "<br>".join(lines) if lines else "Дерево пустое"

    except Exception as e:
        return f"Ошибка визуализации дерева: {str(e)}"


# --- ГЛАВНАЯ СТРАНИЦА И СЛУЖЕБНЫЕ ---

@route('/')
@route('/home')
def index():
    return template('index.tpl', title='Главная', year=datetime.now().year)


@route('/about')
def about():
    return template('about.tpl', title='О нас', year=datetime.now().year)


@route('/kos')
def kos():
    return template('kos_form.tpl', title='Компоненты связности', year=datetime.now().year)


# --- ЗАДАЧА КОММИВОЯЖЁРА ---
@route('/tsp_form')
def tsp_form():
    return template('tsp_form.tpl', title='Задача коммивояжёра', year=datetime.now().year, error=None, result=None)


# --- МИНИМАЛЬНОЕ ВЕРШИННОЕ ПОКРЫТИЕ (КУН-КЁНИГ) ---

# --- МИНИМАЛЬНОЕ ВЕРШИННОЕ ПОКРЫТИЕ (КУН-КЁНИГ) ---

@route('/vertex_cover')
def vertex_cover_page():
    return template('vertex_cover.tpl', 
                    title='Минимальное вершинное покрытие',
                    year=datetime.now().year, 
                    n_left='5', 
                    n_right='4', 
                    edges='',
                    result=False,
                    error=None,
                    cover_size=0,
                    matching_size=0,
                    cover_vertices='', 
                    matching_html='')


@post('/vertex_cover/solve')
def solve_vertex_cover():
    """Обработчик расчёта минимального вершинного покрытия с динамическим сбором долей"""
    error = None
    matching_size = 0
    cover_size = 0
    cover_vertices = ""
    matching_html = ""
    
    n_left_raw = request.forms.get('n_left', '5').strip()
    n_right_raw = request.forms.get('n_right', '4').strip()
    edges_raw = request.forms.get('edges', '').strip()

    try:
        if not n_left_raw or not n_right_raw:
            raise ValueError("Не указана размерность долей графа.")

        n_left = int(n_left_raw)
        n_right = int(n_right_raw)
        
        if n_left > 20 or n_right > 20:
            raise ValueError("Размерность долей превышает ограничение (макс. 20 вершин).")

        edges = []
        U_set = set()  # Множество для динамического сбора реальных вершин левой доли
        V_set = set()  # Множество для динамического сбора реальных вершин правой доли

        if edges_raw:
            for line_idx, line in enumerate(edges_raw.splitlines(), 1):
                parts = line.strip().split()
                if not parts:
                    continue
                if len(parts) != 2:
                    raise ValueError(f"Строка {line_idx}: Неверный формат ребра '{line}'. Должно быть два числа через пробел.")
                
                try:
                    u_val = int(parts[0])
                    v_val = int(parts[1])
                except ValueError:
                    raise ValueError(f"Строка {line_idx}: Вершины должны быть целыми числами.")

                # Валидация по границам долей, чтобы избежать хаоса в индексах
                if u_val < 1 or u_val > n_left:
                    raise ValueError(f"Вершина левой доли {u_val} выходит за рамки размера доли L (1..{n_left}).")
                if v_val <= n_left or v_val > (n_left + n_right):
                    raise ValueError(f"Вершина правой доли {v_val} выходит за рамки размера доли R ({n_left + 1}..{n_left + n_right}).")

                edges.append((u_val, v_val))
                U_set.add(u_val)
                V_set.add(v_val)

        # Формируем полные списки вершин обеих долей (включая изолированные, если рёбер к ним нет)
        U = sorted(list(U_set.union(set(range(1, n_left + 1)))))
        V = sorted(list(V_set.union(set(range(n_left + 1, n_left + n_right + 1)))))
        
        # Безопасный вызов самого алгоритма
        matching_size, cover_size, Cover_list, matching_html = solve_vertex_cover_algorithm(U, V, edges)
        cover_vertices = " ".join(map(str, Cover_list)) if Cover_list else "Покрытие пустое"

    except Exception as e:
        error = str(e)
        matching_html = f"Вычисления прерваны ошибкой: {error}"
    
    # Возвращаем чистый JSON для фронтенда
    return {
        "success": error is None,
        "error": error,
        "cover_size": cover_size,
        "matching_size": matching_size,
        "cover_vertices": cover_vertices,
        "matching_html": matching_html
    }
# --- ЗАДАЧА О РЮКЗАКЕ НА ДЕРЕВЕ ---

@route('/knapsack_tree')
def knapsack_tree():
    return template('knapsack_tree.tpl',
                    title='Задача о рюкзаке на регионе',
                    year=datetime.now().year,
                    n='', w_max='', weights='', values='', edges='',
                    result=None, error=None,
                    max_value=None, selected_vertices=None, total_weight=None,
                    tree_html=None)


@post('/knapsack_tree/solve')
def knapsack_tree_solve():
    n_str = request.forms.get('n', '').strip()
    w_max_str = request.forms.get('w_max', '').strip()
    weights_str = request.forms.get('weights', '').strip()
    values_str = request.forms.get('values', '').strip()
    edges_str = request.forms.get('edges', '').strip()

    try:
        n = int(n_str)
        w_max = int(w_max_str)

        weights_list_0 = list(map(int, weights_str.split()))
        values_list_0 = list(map(int, values_str.split()))
        weights = [0] + weights_list_0
        values = [0] + values_list_0

        edges = []
        for line in edges_str.split('\n'):
            if line.strip():
                u, v = map(int, line.strip().split())
                edges.append((u, v))

        if n < 1 or n > 50:
            raise ValueError("Количество вершин N должно быть от 1 до 50")
        if w_max < 1 or w_max > 100:
            raise ValueError("Максимальный вес W должно быть от 1 до 100")
        if len(weights_list_0) != n:
            raise ValueError(f"Ожидалось {n} весов, получено {len(weights_list_0)}")
        if len(values_list_0) != n:
            raise ValueError(f"Ожидалось {n} ценностей, получено {len(values_list_0)}")
        if len(edges) != n - 1:
            raise ValueError(f"Ожидалось {n - 1} рёбер, получено {len(edges)}")

        max_value, selected_set = solve_knapsack_tree(edges, weights, values, n, w_max)
        total_weight = sum(weights[v] for v in selected_set)
        selected_vertices_str = ' '.join(str(v) for v in sorted(selected_set))

        tree_html = build_tree_string(weights_str, values_str, edges_str, selected_vertices_str)

        return template('knapsack_tree.tpl',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=None,
                        max_value=max_value,
                        selected_vertices=selected_vertices_str,
                        total_weight=total_weight,
                        tree_html=tree_html)

    except Exception as e:
        return template('knapsack_tree.tpl',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=str(e),
                        max_value=None, selected_vertices=None, total_weight=None,
                        tree_html=None)