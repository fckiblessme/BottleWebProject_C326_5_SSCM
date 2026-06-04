
from handlers.kos_form import kosaraju, safe_json, g_from_form, validate_G, generate_solution_text
from bottle import route, template

@route('/')
def index():
    return template('index.tpl', title='Главная', year=2026)

from bottle import route, view, template, request
from datetime import datetime
import json
from knapsack_solver import solve_knapsack_tree


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
            # Защита от выхода за границы динамического массива вершин
            if u in adj and v in adj:
                adj[u].append(v)
                adj[v].append(u)

        lines = []

        # Рекурсивный обход в глубину (DFS)
        def dfs(node, parent, prefix=""):
            w = weights[node - 1]
            v = values[node - 1]
            mark = "✅" if node in selected else "❌" # Сделали метку невыбранных нагляднее
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


@route('/')
@route('/home')
@view('index')
def home():
    return dict(year=datetime.now().year)


@route('/about')
def about():
    return template('about.tpl', title='О нас', year=2026)



# --- ЗАДАЧА КОСАРАЙЮ ---
@route('/kos')
def kos():
    return template('kos.tpl', title='Компоненты сильной связности', 
        year=datetime.now().year,
        result=False,
        error=None,
        count=None,
        components=[],
        n=None,
        G=None,
        solution_text=None)

@route('/kos/decision', method='POST')
def kos_decision():
    #Получение размера графа из формы
    n = int(request.forms.get('n', 0))
    #Получение текстового представления графа
    g_text = request.forms.get('G', '').strip()

    try:
        #Преобразование текста в матрицу смежности
        G = g_from_form(g_text, n)
    
    #При ошибке возврат страницу с сообщением об ошибке
    except ValueError as e:
        return template('kos.tpl', 
            title='Компоненты сильной связности',
            year=datetime.now().year,
            n=n,
            result=False,
            error=str(e),
            count=None,
            components=[],
            G=g_text
        )
    
    #Проверка корректности матрицы смежности
    valid, error_msg = validate_G(G, n)

    #Если матрица некорректна
    if not valid:
        return template('kos.tpl', 
            title='Компоненты сильной связности',
            year=datetime.now().year,
            n=n,
            result=False,
            error=error_msg,
            count=None,
            components=[],
            G=g_text
        )
    

    try:
        #Выполнение алгоритма, получение количества и списка компонентов
        count, components = kosaraju(G, n)

        #Генерация текстового описания решения
        solution_text = generate_solution_text(G, n, components)
        
        #Сохранение результатов 
        safe_json(n, G, count, components)
        
        #Возврат страницы с успешным результатом
        return template('kos.tpl',
            title='Компоненты сильной связности',
            year=datetime.now().year,
            n=n,
            result=True,
            error=None,
            count=count,
            components=components,
            G=G,
            solution_text=solution_text
        )

    #Возврат страницы с ошибкой при ошибке в вычислении алгоритма
    except Exception as e:
        return template('kos.tpl',
            title='Компоненты сильной связности',
            year=datetime.now().year,
            n=n,
            result=False,
            error=f"Ошибка при вычислении: {str(e)}",
            count=None,
            components=[],
            G=g_text
        )









# --- ЗАДАЧА КОММИВОЯЖЁРА (Новый роут, чтобы ссылка из меню работала) ---
@route('/tsp_form')
def tsp_form():
    return template('tsp_form', 
                    title='Задача коммивояжёра', 
                    year=datetime.now().year,
                    error=None,
                    result=None)


# --- МИНИМАЛЬНОЕ ВЕРШИННОЕ ПОКРЫТИЕ ---
@route('/vertex_cover')
def vertex_cover():
    return template('vertex_cover',
                    title='Минимальное вершинное покрытие',
                    year=datetime.now().year,
                    n_left=None, 
                    n_right=None,
                    n='', w_max='', weights='', values='', edges='',
                    result=None, error=None,
                    max_value=None, selected_vertices=None, total_weight=None,
                    tree_html=None)


# --- ЗАДАЧА О РЮКЗАКЕ НА ДЕРЕВЕ ---
@route('/knapsack_tree')
def knapsack_tree():
    return template('knapsack_tree',
                    title='Задача о рюкзаке на дереве',
                    year=datetime.now().year,
                    n='', w_max='', weights='', values='', edges='',
                    result=None, error=None,
                    max_value=None, selected_vertices=None, total_weight=None,
                    tree_html=None)


@route('/knapsack_tree/solve', method='POST')
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

        # Валидация входных параметров
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

        # Вызов алгоритма решения
        max_value, selected_set = solve_knapsack_tree(edges, weights, values, n, w_max)
        total_weight = sum(weights[v] for v in selected_set)
        selected_vertices_str = ' '.join(str(v) for v in sorted(selected_set))

        # Генерируем красивое текстовое дерево
        tree_html = build_tree_string(weights_str, values_str, edges_str, selected_vertices_str)

        return template('knapsack_tree',
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
        return template('knapsack_tree',
                        title='Задача о рюкзаке на дереве',
                        year=datetime.now().year,
                        n=n_str, w_max=w_max_str,
                        weights=weights_str, values=values_str, edges=edges_str,
                        result=True, error=str(e),
                        max_value=None, selected_vertices=None, total_weight=None,
                        tree_html=None)
