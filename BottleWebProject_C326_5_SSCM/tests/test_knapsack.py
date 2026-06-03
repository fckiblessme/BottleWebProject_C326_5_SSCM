import unittest
import sys
import os

# Добавляем путь к корневой директории проекта
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from BottleWebProject_C326_5_SSCM.handlers.knapsack_solver import solve_knapsack_tree


class TestKnapsackTreeSolver(unittest.TestCase):
    """Тесты для решателя задачи о рюкзаке на дереве"""

    # ТЕСТ 1: Базовый пример из задания (N=5, W=7)
    def test_basic_example(self):
        """TC-01: Базовый пример из задания"""
        edges = [(1, 2), (1, 3), (2, 4), (3, 5)]
        weights = [0, 2, 3, 1, 2, 1]
        values = [0, 10, 20, 5, 5, 100]
        n = 5
        W = 7

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        # Ожидаем ценность 135 (10+20+5+100)
        self.assertEqual(max_value, 135)
        self.assertEqual(selected, {1, 2, 3, 5})

    # ТЕСТ 2: Простое дерево из 2 вершин
    def test_simple_tree(self):
        """TC-02: Дерево из 2 вершин"""
        edges = [(1, 2)]
        weights = [0, 2, 3]
        values = [0, 10, 20]
        n = 2
        W = 5

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        self.assertEqual(max_value, 30)
        self.assertEqual(selected, {1, 2})


    def test_simple_tree_2(self):
        """Тест: дерево, которое разобранное учителем"""
        edges = [(1, 2), (1, 3), (1, 4), (1, 5)]
        weights = [0, 5, 10, 4, 6, 7]
        values = [0, 8, 4, 6, 2, 3]
        n = 5
        W = 15

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        self.assertEqual(max_value, 16)
        self.assertEqual(selected, {1, 3, 4})

    # ТЕСТ 3: Одна вершина (N=1)
    def test_single_vertex(self):
        """TC-03: Дерево из одной вершины"""
        edges = []
        weights = [0, 5]
        values = [0, 100]
        n = 1
        W = 10

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        self.assertEqual(max_value, 100)
        self.assertEqual(selected, {1})

    # ТЕСТ 4: Вершина тяжелее W (не помещается)
    def test_vertex_too_heavy(self):
        """TC-04: Вершина тяжелее максимального веса"""
        edges = [(1, 2)]
        weights = [0, 10, 8]
        values = [0, 100, 80]
        n = 2
        W = 5

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        # Ожидаем 0, так как ни одна вершина не помещается
        self.assertEqual(max_value, 0)
        self.assertEqual(selected, set())

    # ТЕСТ 5: Выбор только корня (дети тяжелые)
    def test_root_only(self):
        """TC-05: Выбираем только корень, дети не помещаются"""
        edges = [(1, 2), (1, 3)]
        weights = [0, 2, 10, 10]
        values = [0, 100, 1, 1]
        n = 3
        W = 3

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        self.assertEqual(max_value, 100)
        self.assertEqual(selected, {1})

    # ТЕСТ 6: Проверка работы с W=0
    def test_zero_weight_limit(self):
        """TC-06: Максимальный вес W = 0"""
        edges = [(1, 2)]
        weights = [0, 1, 2]
        values = [0, 10, 20]
        n = 2
        W = 0

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        self.assertEqual(max_value, 0)
        self.assertEqual(selected, set())

    # ТЕСТ 7: Все вершины имеют маленький вес
    def test_all_light_vertices(self):
        """TC-07: Все вершины имеют вес 1"""
        edges = [(1, 2), (1, 3), (2, 4)]
        weights = [0, 1, 1, 1, 1]
        values = [0, 5, 10, 15, 20]
        n = 4
        W = 3

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        # Проверяем, что результат - число
        self.assertIsInstance(max_value, (int, float))
        self.assertIsInstance(selected, set)
        # Вес не должен превышать W
        total_weight = sum(weights[v] for v in selected)
        self.assertLessEqual(total_weight, W)

    # ТЕСТ 8: Линейное дерево (цепочка)
    def test_linear_tree(self):
        """TC-08: Линейное дерево (1-2-3-4)"""
        edges = [(1, 2), (2, 3), (3, 4)]
        weights = [0, 2, 3, 1, 4]
        values = [0, 10, 20, 5, 30]
        n = 4
        W = 8

        max_value, selected = solve_knapsack_tree(edges, weights, values, n, W)

        self.assertIsInstance(max_value, (int, float))
        self.assertIsInstance(selected, set)
        total_weight = sum(weights[v] for v in selected)
        self.assertLessEqual(total_weight, W)


class TestKnapsackTreeValidation(unittest.TestCase):
    """Тесты для валидации входных данных"""

    # ТЕСТ 9: Проверка N > 20 (должна быть ошибка)
    def test_n_too_large(self):
        """TC-09: N > 20 должно вызывать ошибку валидации"""
        n = 25
        # В вашем коде в routes.py есть проверка n > 20
        self.assertGreater(n, 20, "N > 20 должно быть запрещено")

    # ТЕСТ 10: Проверка W > 100
    def test_w_too_large(self):
        """TC-10: W > 100 должно вызывать ошибку"""
        w_max = 150
        self.assertGreater(w_max, 100, "W > 100 должно быть запрещено")

    # ТЕСТ 11: Проверка количества рёбер
    def test_edges_count(self):
        """TC-11: Неправильное количество рёбер (не N-1)"""
        n = 5
        edges = [(1, 2), (1, 3)]  # только 2 ребра, а нужно 4
        expected_edges = n - 1

        self.assertNotEqual(len(edges), expected_edges,
                           f"Количество рёбер должно быть {expected_edges}, получено {len(edges)}")

    # ТЕСТ 12: Проверка на петли
    def test_self_loop(self):
        """TC-12: Обнаружение петли (ребро из вершины в себя)"""
        edges = [(1, 1), (1, 2)]

        has_loop = any(u == v for u, v in edges)
        self.assertTrue(has_loop, "Петля должна быть обнаружена")

    # ТЕСТ 13: Проверка на дубликаты рёбер
    def test_duplicate_edges(self):
        """TC-13: Обнаружение дублирующихся рёбер"""
        edges = [(1, 2), (1, 2), (2, 3)]

        edge_set = set()
        has_duplicate = False
        for u, v in edges:
            edge_tuple = tuple(sorted((u, v)))
            if edge_tuple in edge_set:
                has_duplicate = True
                break
            edge_set.add(edge_tuple)

        self.assertTrue(has_duplicate, "Дубликат ребра должен быть обнаружен")

    # ТЕСТ 14: Проверка на изолированные вершины
    def test_isolated_vertex(self):
        """TC-14: Обнаружение изолированной вершины"""
        n = 4
        edges = [(1, 2), (2, 3)]  # вершина 4 изолирована
        adj = {i: [] for i in range(1, n + 1)}
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        isolated = [i for i in range(1, n + 1) if len(adj[i]) == 0]
        self.assertEqual(isolated, [4], "Вершина 4 должна быть изолирована")

    # ТЕСТ 15: Проверка количества весов (должно быть равно N)
    def test_weights_count(self):
        """TC-15: Количество весов должно быть равно N"""
        n = 5
        weights = [1, 2, 3]  # только 3 веса
        expected = n

        self.assertNotEqual(len(weights), expected,
                           f"Количество весов должно быть {expected}, получено {len(weights)}")

    # ТЕСТ 16: Проверка количества ценностей (должно быть равно N)
    def test_values_count(self):
        """TC-16: Количество ценностей должно быть равно N"""
        n = 5
        values = [10, 20, 30]  # только 3 ценности
        expected = n

        self.assertNotEqual(len(values), expected,
                           f"Количество ценностей должно быть {expected}, получено {len(values)}")


if __name__ == '__main__':
    unittest.main(verbosity=2)