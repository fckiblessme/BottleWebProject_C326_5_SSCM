"""
Модульные тесты для задачи о рюкзаке на дереве.
Проверяют корректность алгоритма и валидацию данных.
"""

import unittest
import sys
import os

# Добавляем путь к корневой директории проекта
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from BottleWebProject_C326_5_SSCM.knapsack_solver import solve_knapsack_tree


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
