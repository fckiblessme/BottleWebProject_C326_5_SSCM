from bottle import route, view, template, request, post
from datetime import datetime
import json
import os
import uuid
import math


# Импорты алгоритмов
from knapsack_solver import solve_knapsack_tree
from handlers.tsp_form import handle_post
from handlers.vertex_cover_form import solve_vertex_cover_algorithm


def generate_tree_image(edges, weights_list, values_list, selected_vertices, filename):
    """Генерирует изображение дерева с подсветкой выбранных вершин."""
    try:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt

        n = len(weights_list) - 1

        if n == 0:
            return None

        # Динамический размер в зависимости от количества вершин
        if n <= 5:
            radius = 0.35
            font_size_id = 16  # было 14
            font_size_text = 12  # было 10
            circle_size = 0.08  # было 0.07
        elif n <= 10:
            radius = 0.40
            font_size_id = 14  # было 12
            font_size_text = 10  # было 8
            circle_size = 0.07  # было 0.06
        elif n <= 20:
            radius = 0.45
            font_size_id = 12  # было 10
            font_size_text = 9  # было 7
            circle_size = 0.06  # было 0.05
        else:
            radius = 0.50
            font_size_id = 10  # было 8
            font_size_text = 8  # было 6
            circle_size = 0.05  # было 0.04

        # Координаты вершин
        vertices = []
        center_x, center_y = 0.5, 0.55

        for i in range(1, n + 1):
            angle = (i - 1) * 2 * math.pi / n - math.pi / 2
            x = center_x + radius * math.cos(angle)
            y = center_y + radius * math.sin(angle)
            vertices.append({
                'id': i,
                'weight': weights_list[i],
                'value': values_list[i],
                'x': x,
                'y': y
            })

        fig, ax = plt.subplots(figsize=(14, 12))
        ax.set_xlim(-0.05, 1.05)
        ax.set_ylim(-0.05, 1.05)
        ax.set_aspect('equal')
        ax.axis('off')

        colors = {
            'bg': '#dfd8c8',
            'vertex_normal': '#dfd8c8',
            'vertex_selected': '#41444b',
            'edge': '#cabfab',
            'text_dark': '#41444b',
            'text_light': '#dfd8c8'
        }

        # Рисуем рёбра
        for u, v in edges:
            u_vert = next(vt for vt in vertices if vt['id'] == u)
            v_vert = next(vt for vt in vertices if vt['id'] == v)
            ax.plot([u_vert['x'], v_vert['x']], [u_vert['y'], v_vert['y']],
                    color=colors['edge'], linewidth=2, zorder=1)

        # Рисуем вершины
        for v in vertices:
            is_selected = v['id'] in selected_vertices
            circle = plt.Circle((v['x'], v['y']), circle_size,
                                facecolor=colors['vertex_selected'] if is_selected else colors['vertex_normal'],
                                edgecolor=colors['edge'], linewidth=2, zorder=2)
            ax.add_patch(circle)

            text_color = '#ffffff' if is_selected else colors['text_dark']  # золотой

            # ID вершины
            ax.text(v['x'], v['y'] + 0.04, str(v['id']), ha='center', va='center',
                    fontsize=font_size_id, fontweight='bold', color=text_color)

            # Вес (w) - поднял выше (было -0.08, стало -0.06)
            ax.text(v['x'], v['y'] - 0.02, f"w={v['weight']}", ha='center', va='center',
                    fontsize=font_size_text, color=text_color)

            # Ценность (v) - поднял выше (было -0.14, стало -0.11)
            ax.text(v['x'], v['y'] - 0.05, f"v={v['value']}", ha='center', va='center',
                    fontsize=font_size_text, color=text_color, fontweight='bold')

        # Сохраняем
        static_dir = os.path.join(os.path.dirname(__file__), 'static', 'content')
        os.makedirs(static_dir, exist_ok=True)

        output_path = os.path.join(static_dir, f'{filename}.png')
        plt.savefig(output_path, dpi=150, bbox_inches='tight', facecolor=colors['bg'])
        plt.close()

        print(f"✅ Изображение сохранено: {output_path}")
        return f'/static/content/{filename}.png'

    except Exception as e:
        print(f"❌ Ошибка генерации изображения: {e}")
        return None

DATA_FILE = 'data/calculations.json'


def save_calculation(data):
    # Создаём папку data если её нет
    os.makedirs('data', exist_ok=True)

    # Формируем запись с текущей датой и временем
    record = {
        'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        **data
    }

    # Загружаем существующие записи
    existing = []
    if os.path.exists(DATA_FILE):
        try:
            with open(DATA_FILE, 'r', encoding='utf-8') as f:
                existing = json.load(f)
        except:
            existing = []

    # Добавляем новую запись
    existing.append(record)

    # Сохраняем обратно (дозаписываем)
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(existing, f, ensure_ascii=False, indent=2)

    print(f"✅ Данные сохранены в {DATA_FILE}")

def clean_old_images(keep=10):
    """Удаляет старые изображения"""
    try:
        static_dir = os.path.join(os.path.dirname(__file__), 'static', 'content')
        if not os.path.exists(static_dir):
            return

        images = [f for f in os.listdir(static_dir) if f.startswith('tree_') and f.endswith('.png')]
        images.sort(key=lambda x: os.path.getmtime(os.path.join(static_dir, x)), reverse=True)

        for img in images[keep:]:
            os.remove(os.path.join(static_dir, img))
            print(f"🗑️ Удалено старое изображение: {img}")
    except Exception as e:
        print(f"Ошибка очистки: {e}")


def build_tree_string(weights_str, values_str, edges_str, selected_str, max_lines=50):
    """Строит текстовое представление дерева с ограничением на количество строк"""
    try:
        if not weights_str or not values_str:
            return "Данные дерева отсутствуют"

        weights = [int(x) for x in weights_str.split()]
        values = [int(x) for x in values_str.split()]
        selected = set(int(x) for x in selected_str.split()) if selected_str else set()

        n = len(weights)

        # Если вершин слишком много, показываем сокращённый вывод
        if n > 30:
            return f"⚠️ Дерево слишком большое ({n} вершин). Для отображения рекомендуется N ≤ 30."

        adj = {i + 1: [] for i in range(n)}

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
        line_count = 0

        def dfs(node, parent, prefix=""):
            nonlocal line_count
            if line_count >= max_lines:
                return
            w = weights[node - 1]
            v = values[node - 1]
            mark = "✅" if node in selected else "❌"
            lines.append(f"{prefix}├── {mark} Вершина {node} (w={w}, v={v})")
            line_count += 1

            children = [c for c in adj[node] if c != parent]
            for i, child in enumerate(children):
                if line_count >= max_lines:
                    lines.append(f"{prefix}│   ... (и ещё {len(children) - i} детей не показано)")
                    return
                if i == len(children) - 1:
                    dfs(child, node, prefix + "    ")
                else:
                    dfs(child, node, prefix + "│   ")

        if n > 0:
            dfs(1, -1, "")

        if line_count >= max_lines:
            lines.append("... (достигнут лимит отображения)")

        return "<br>".join(lines) if lines else "Дерево пустое"

    except Exception as e:
        return f"Ошибка визуализации: {str(e)}"


# МАРШРУТЫ

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



# ЗАДАЧА КОММИВОЯЖЁРА
@route('/tsp', method=['GET', 'POST'])
def tsp_page():
    if request.method == 'POST':
        request.forms.encoding = 'utf-8'
        return handle_post()

    n = request.query.get('n')
    n = int(n) if n else None

    error = request.query.get('error')
    result = request.query.get('result')
    route_data = request.query.get('route')

    matrix = None

    if n:
        matrix = []
        for i in range(n):
            row = []
            for j in range(n):
                if i == j:
                    row.append(0)
                else:
                    val = request.query.get(f'm{i+1}{j+1}')
                    row.append(int(val) if val else 0)
            matrix.append(row)

    return template(
        'tsp',
        n=n,
        matrix=matrix,
        error=error,
        result=result,
        route=route_data,
        year=None
    )
# --- МИНИМАЛЬНОЕ ВЕРШИННОЕ ПОКРЫТИЕ ---

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

                # Валидация по границам долей
                if u_val < 1 or u_val > n_left:
                    raise ValueError(f"Вершина левой доли {u_val} выходит за рамки размера доли L (1..{n_left}).")
                if v_val <= n_left or v_val > (n_left + n_right):
                    raise ValueError(f"Вершина правой доли {v_val} выходит за рамки размера доли R ({n_left + 1}..{n_left + n_right}).")

                edges.append((u_val, v_val))
                U_set.add(u_val)
                V_set.add(v_val)

        # Формируем полные списки вершин обеих долей 
        U = sorted(list(U_set.union(set(range(1, n_left + 1)))))
        V = sorted(list(V_set.union(set(range(n_left + 1, n_left + n_right + 1)))))
        
        matching_size, cover_size, Cover_list, matching_html = solve_vertex_cover_algorithm(U, V, edges)
        cover_vertices = " ".join(map(str, Cover_list)) if Cover_list else "Покрытие пустое"

    except Exception as e:
        error = str(e)
        matching_html = f"Вычисления прерваны ошибкой: {error}"
    
    # Возвращаем чистый JSON 
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
                    tree_html=None,
                    tree_image='/static/content/tree_example.png')


def validate_tree_edges(edges, n):
    """
    Проверяет, что рёбра образуют корректное дерево:
    1. Количество рёбер = n-1
    2. Нет дублирующихся рёбер
    3. Нет рёбер вида (u, u) (петли)
    4. Граф связный (из любой вершины есть путь к вершине 1)
    """
    if len(edges) != n - 1:
        raise ValueError(f"Количество рёбер должно быть {n - 1}, получено {len(edges)}")

    # Проверка на дубликаты и петли
    edge_set = set()
    for u, v in edges:
        # Проверка на петлю (ребро из вершины в саму себя)
        if u == v:
            raise ValueError(f"Обнаружена петля: вершина {u} соединена сама с собой")

        # Проверка на дубликат
        edge_tuple = tuple(sorted((u, v)))
        if edge_tuple in edge_set:
            raise ValueError(f"Обнаружено дублирующееся ребро: ({u}, {v})")
        edge_set.add(edge_tuple)

        # Проверка на корректные номера вершин
        if u < 1 or u > n or v < 1 or v > n:
            raise ValueError(f"Некорректный номер вершины в ребре ({u}, {v}). Допустимы вершины от 1 до {n}")

    # Проверка связности (из любой вершины есть путь к 1)
    from collections import deque
    adj = {i: [] for i in range(1, n + 1)}
    for u, v in edges:
        adj[u].append(v)
        adj[v].append(u)

    # BFS от вершины 1
    visited = set()
    queue = deque([1])
    visited.add(1)

    while queue:
        node = queue.popleft()
        for neighbor in adj[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(neighbor)

    # Проверяем, что все вершины достижимы
    if len(visited) != n:
        missing = set(range(1, n + 1)) - visited
        raise ValueError(f"Граф не связный! Следующие вершины недостижимы из корня 1: {sorted(missing)}")

    return True


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

        # Парсим рёбра
        edges = []
        for line in edges_str.split('\n'):
            if line.strip():
                parts = line.strip().split()
                if len(parts) != 2:
                    raise ValueError(f"Некорректный формат ребра: '{line}'. Ожидается формат 'u v'")
                u, v = map(int, parts)
                edges.append((u, v))

        save_calculation({
            'n': n_str,
            'W': w_max_str,
            'weights': weights_str,
            'values': values_str,
            'edges': edges_str
        })

        if len(edges) != n - 1:
            raise ValueError(f"Количество рёбер должно быть {n - 1}, получено {len(edges)}")

        edge_set = set()
        for u, v in edges:
            if u == v:
                raise ValueError(f"Обнаружена петля: вершина {u} соединена сама с собой")
            if u < 1 or u > n or v < 1 or v > n:
                raise ValueError(f"Некорректный номер вершины в ребре ({u}, {v}). Допустимы вершины от 1 до {n}")

            edge_tuple = tuple(sorted((u, v)))
            if edge_tuple in edge_set:
                raise ValueError(f"Обнаружено дублирующееся ребро: ({u}, {v})")
            edge_set.add(edge_tuple)

        from collections import deque
        adj = {i: [] for i in range(1, n + 1)}
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        # Проверка, что нет изолированных вершин
        for i in range(1, n + 1):
            if len(adj[i]) == 0 and n > 1:
                raise ValueError(f"Вершина {i} изолирована (нет ни одного ребра). Дерево должно быть связным.")

        visited = set()
        queue = deque([1])
        visited.add(1)

        while queue:
            node = queue.popleft()
            for neighbor in adj[node]:
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)

        if len(visited) != n:
            missing = sorted(set(range(1, n + 1)) - visited)
            raise ValueError(f"Граф не связный! Вершины {missing} недостижимы из корня 1")

        if n < 1 or n > 20:
            raise ValueError("N должно быть от 1 до 20")
        if w_max < 1 or w_max > 100:
            raise ValueError("W должно быть от 1 до 100")
        if len(weights_list_0) != n:
            raise ValueError(f"Ожидалось {n} весов, получено {len(weights_list_0)}")
        if len(values_list_0) != n:
            raise ValueError(f"Ожидалось {n} ценностей, получено {len(values_list_0)}")

        max_value, selected_set = solve_knapsack_tree(edges, weights, values, n, w_max)
        total_weight = sum(weights[v] for v in selected_set)
        selected_vertices_str = ' '.join(str(v) for v in sorted(selected_set))

        image_id = str(uuid.uuid4())[:8]
        tree_image = generate_tree_image(edges, weights, values, selected_set, f'tree_{image_id}')

        clean_old_images(10)

        return template('knapsack_tree.tpl',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=None,
                        max_value=max_value,
                        selected_vertices=selected_vertices_str,
                        total_weight=total_weight,
                        tree_html=None,
                        tree_image=tree_image)

    except Exception as e:
        print(f"❌ Ошибка: {e}")
        return template('knapsack_tree',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=str(e),
                        max_value=None, selected_vertices=None, total_weight=None,
                        tree_html=None,
                        tree_image=None)
