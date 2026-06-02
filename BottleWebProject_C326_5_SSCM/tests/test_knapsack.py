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
