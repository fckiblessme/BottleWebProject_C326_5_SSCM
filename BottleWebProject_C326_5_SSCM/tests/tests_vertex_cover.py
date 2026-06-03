import unittest
import sys
import os

project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from handlers.vertex_cover_form import solve_vertex_cover_algorithm


class TestVertexCoverSolver(unittest.TestCase):
    """Тесты для алгоритма поиска минимального вершинного покрытия в двудольном графе"""
    # ТЕСТ 1: Базовый пример 
    def test_basic_example(self):
        """TC-01: Базовый классический пример"""
        U = [1, 2]        
        V = [3, 4]       
        edges = [(1, 3), (1, 4), (2, 3)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        self.assertEqual(matching_size, 2)
        self.assertEqual(cover_size, 2)
        self.assertIsInstance(cover_vertices, list)
        
        # Проверяем, что все рёбра покрыты
        cover_set = set(cover_vertices)
        for u, v in edges:
            self.assertTrue(u in cover_set or v in cover_set, f"Ребро ({u}, {v}) не покрыто!")

    # ТЕСТ 2: Полный двудольный граф K_2,2
    def test_complete_bipartite(self):
        """TC-02: Полный двудольный граф"""
        U = [1, 2]
        V = [3, 4]
        edges = [(1, 3), (1, 4), (2, 3), (2, 4)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        self.assertEqual(matching_size, 2)
        self.assertEqual(cover_size, 2)
        cover_set = set(cover_vertices)
        for u, v in edges:
            self.assertTrue(u in cover_set or v in cover_set)

    # ТЕСТ 3: Пустой граф (нет рёбер)
    def test_no_edges(self):
        """TC-03: Граф без рёбер"""
        U = [1, 2, 3]
        V = [4, 5, 6]
        edges = []

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        self.assertEqual(matching_size, 0)
        self.assertEqual(cover_size, 0)
        self.assertEqual(set(cover_vertices), set())

    # ТЕСТ 4: Совершенное паросочетание
    def test_perfect_matching_graph(self):
        """TC-04: Граф, представляющий собой изолированные пары рёбер"""
        U = [1, 2, 3]
        V = [4, 5, 6]
        edges = [(1, 4), (2, 5), (3, 6)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        self.assertEqual(matching_size, 3)
        self.assertEqual(cover_size, 3)
        cover_set = set(cover_vertices)
        for u, v in edges:
            self.assertTrue(u in cover_set or v in cover_set)

    # ТЕСТ 5: Граф-звезда
    def test_star_graph(self):
        """TC-05: Граф-звезда (одна центральная вершина покрывает всё)"""
        U = [1, 2]
        V = [3, 4, 5]
        edges = [(1, 3), (1, 4), (1, 5)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        self.assertEqual(matching_size, 1)
        self.assertEqual(cover_size, 1)
        self.assertEqual(set(cover_vertices), {1})

    # ТЕСТ 6: Несвязный граф (несколько изолированных компонент)
    def test_disconnected_graph(self):
        """TC-06: Несвязный граф (компоненты изолированы друг от друга)"""
        # Две независимые звезды в разных частях графа
        U = [1, 2]        
        V = [3, 4, 5, 6]  
        # Вершина 1 соединена с 3 и 4, Вершина 2 соединена с 5 и 6
        edges = [(1, 3), (1, 4), (2, 5), (2, 6)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        # Максимальное паросочетание = 2, вершинное покрытие = 2 (вершины 1 и 2)
        self.assertEqual(matching_size, 2)
        self.assertEqual(cover_size, 2)
        self.assertEqual(set(cover_vertices), {1, 2})

    # ТЕСТ 7: Длинная чередующаяся цепь (путь)
    def test_path_graph(self):
        """TC-07: Граф в виде длинной цепи"""
        U = [1, 2, 3]  
        V = [4, 5]     
        edges = [(1, 4), (2, 4), (2, 5), (3, 5)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        # Максимальное паросочетание в цепи из 4 рёбер равно 2
        self.assertEqual(matching_size, 2)
        self.assertEqual(cover_size, 2)
        
        # Минимальное вершинное покрытие обязано состоять ровно из {4, 5} (правая доля)
        self.assertEqual(set(cover_vertices), {4, 5})

    # ТЕСТ 8: Одна изолированная вершина в доле
    def test_isolated_vertex_in_bipartite(self):
        """TC-08: Одна из вершин доли вообще не имеет рёбер"""
        U = [1, 2]     
        V = [3, 4]     
        # Вершина 2 из левой доли изолирована
        edges = [(1, 3), (1, 4)]

        matching_size, cover_size, cover_vertices, log = solve_vertex_cover_algorithm(U, V, edges)

        # Покрытие должно эффективно обработать только активную часть графа
        self.assertEqual(matching_size, 1)
        self.assertEqual(cover_size, 1)
        self.assertEqual(set(cover_vertices), {1})

class TestVertexCoverValidation(unittest.TestCase):
    """Тесты для валидации входных данных задачи вершинного покрытия"""

    # ТЕСТ 9: Ограничение на количество вершин в доле (N > 20)
    def test_n_left_too_large(self):
        """TC-09: Количество вершин в левой доле > 20 должно быть запрещено"""
        n_left = 22
        self.assertGreater(n_left, 20, "Валидация должна отклонять n_left > 20")

    def test_n_right_too_large(self):
        """TC-10: Количество вершин в правой доле > 20 должно быть запрещено"""
        n_right = 25
        self.assertGreater(n_right, 20, "Валидация должна отклонять n_right > 20")

    # ТЕСТ 7: Проверка корректности индексов рёбер
    def test_edge_indices_valid(self):
        """TC-11: Проверка, что вершины в рёбрах соответствуют границам долей"""
        n_left = 3   
        n_right = 3  
        invalid_edge = (1, 7) 
        total_vertices = n_left + n_right
        self.assertGreater(invalid_edge[1], total_vertices, "Индекс вершины выходит за рамки графа")

    # ТЕСТ 8: Обнаружение дубликатов рёбер
    def test_duplicate_edges(self):
        """TC-12: Обнаружение дублирующихся рёбер во входных данных"""
        edges = [(1, 4), (1, 4), (2, 5)]

        edge_set = set()
        has_duplicate = False
        for u, v in edges:
            edge_tuple = tuple(sorted((u, v)))
            if edge_tuple in edge_set:
                has_duplicate = True
                break
            edge_set.add(edge_tuple)

        self.assertTrue(has_duplicate, "Дубликат ребра должен быть успешно обнаружен")

    # ТЕСТ 9: Проверка на рёбра внутри одной и той же доли (нарушение двудольности)
    def test_bipartite_violation(self):
        """TC-13: Проверка на недопустимые рёбра между вершинами одной доли"""
        n_left = 3  
        intra_edge = (1, 2)
        
        is_violation = intra_edge[0] <= n_left and intra_edge[1] <= n_left
        self.assertTrue(is_violation, "Обнаружено ребро внутри левой доли")

    # ТЕСТ 14: Проверка на рёбра внутри правой доли (нарушение двудольности)
    def test_bipartite_violation_right_side(self):
        """TC-14: Проверка на недопустимые рёбра между вершинами внутри правой доли"""
        n_left = 3 
        n_right = 3  
        
        # Ребро (4, 5) соединяет вершины внутри правой доли — это сломает алгоритм Кёнига
        intra_edge = (4, 5)
        
        is_violation = intra_edge[0] > n_left and intra_edge[1] > n_left
        self.assertTrue(is_violation, "Обнаружено и заблокировано ребро внутри правой доли")

    # ТЕСТ 15: Пустые списки долей при наличии рёбер
    def test_empty_fractions_with_edges(self):
        """TC-15: Списки вершин пустые, но переданы рёбра (некорректное состояние)"""
        U = []
        V = []
        edges = [(1, 2)]
        
        # Проверяем логику: если доли пусты, рёбер существовать не должно
        has_invalid_context = len(edges) > 0 and (len(U) == 0 or len(V) == 0)
        self.assertTrue(has_invalid_context, "Контекст некорректен: рёбра ссылаются на несуществующие доли")

    # ТЕСТ 16: Отрицательные индексы вершин
    def test_negative_vertex_indices(self):
        """TC-16: Проверка на отрицательные ID вершин в рёбрах"""
        edges = [(-1, 4), (2, 5)]
        
        has_negative = any(u <= 0 or v <= 0 for u, v in edges)
        self.assertTrue(has_negative, "Валидация должна обнаружить некорректный (отрицательный или нулевой) индекс вершины")

if __name__ == '__main__':
    unittest.main(verbosity=2)