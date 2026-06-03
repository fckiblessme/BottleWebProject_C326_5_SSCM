import unittest
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from handlers.tsp_form import solve_tsp, checking_n, checking_cell, get_random_matrix


class TestTSPSolver(unittest.TestCase):
    """Тесты для алгоритма задачи коммивояжёра"""

    # ТЕСТ 1: Структурная целостность маршрута
    def test_route_structure(self):
        """TC-01: Маршрут является гамильтоновым циклом"""
        matrix = get_random_matrix(5)
        result_html, best_route, best_distance, best_calc, best_route_str, best_routes = solve_tsp(matrix)

        # Замкнутость
        self.assertEqual(best_route[0], best_route[-1])
        # Длина N+1
        self.assertEqual(len(best_route), len(matrix) + 1)
        # Все вершины посещены
        visited = best_route[:-1]
        for i in range(1, len(matrix) + 1):
            self.assertIn(i, visited)
        # Нет дубликатов
        self.assertEqual(len(set(visited)), len(matrix))

    # ТЕСТ 2: Базовый пример из задания (N=4)
    def test_basic_example(self):
        """TC-02: Базовый пример (матрица 4×4)"""
        matrix = [
            [0, 10, 15, 20],
            [10, 0, 35, 25],
            [15, 35, 0, 30],
            [20, 25, 30, 0]
        ]
        # Вызов функции решения
        result_html, best_route, best_distance, best_calc, best_route_str, best_routes = solve_tsp(matrix)

        # Проверка минимального веса
        self.assertEqual(best_distance, 80)
        # Проверка количества оптимальных маршрутов
        self.assertEqual(len(best_routes), 2)
        # Проверка конкретных оптимальных маршрутов
        expected_routes = [
            [1, 2, 4, 3, 1],
            [1, 3, 4, 2, 1]
        ]
        for expected in expected_routes:
            self.assertIn(expected, best_routes)

    # ТЕСТ 3: Минимальный граф (N=2)
    def test_minimal_graph(self):
        """TC-03: Граф из 2 вершин"""
        matrix = [
            [0, 5],
            [5, 0]
        ]
        # Вызов функции решения
        result_html, best_route, best_distance, best_calc, best_route_str, best_routes = solve_tsp(matrix)

        # Проверка веса
        self.assertEqual(best_distance, 10)
        # Проверка маршрута
        self.assertEqual(best_route, [1, 2, 1])

    # ТЕСТ 4: Граф из 8 вершин 
    def test_twelve_vertices(self):
        """TC-04: Граф из 8 вершин"""
        matrix = [
            [0, 12, 45, 23, 67, 34, 56, 78],
            [12, 0, 89, 34, 21, 43, 65, 90],
            [45, 89, 0, 11, 76, 54, 32, 87],
            [23, 34, 11, 0, 43, 21, 98, 65],
            [67, 21, 76, 43, 0, 33, 44, 55],
            [34, 43, 54, 21, 33, 0, 66, 77],
            [56, 65, 32, 98, 44, 66, 0, 88],
            [78, 90, 87, 65, 55, 77, 88, 0]
        ]
        
        # Вызов функции решения
        result_html, best_route, best_distance, best_calc, best_route_str, best_routes = solve_tsp(matrix)

        # Все оптимальные маршруты 
        expected_routes = [
            [1, 2, 5, 8, 7, 3, 4, 6, 1],
            [1, 6, 4, 3, 7, 8, 5, 2, 1]
        ]
        
        # Проверка минимального веса
        self.assertEqual(best_distance, 274)
        # Проверка количества оптимальных маршрутов
        self.assertEqual(len(best_routes), 2)
        # Проверка, что все ожидаемые маршруты найдены
        for expected in expected_routes:
            self.assertIn(expected, best_routes)

    # ТЕСТ 5: Все маршруты оптимальны
    def test_equal_weights(self):
        """TC-05: Все рёбра одного веса"""
        matrix = [
            [0, 10, 10, 10],
            [10, 0, 10, 10],
            [10, 10, 0, 10],
            [10, 10, 10, 0]
        ]
        # Вызов функции решения
        result_html, best_route, best_distance, best_calc, best_route_str, best_routes = solve_tsp(matrix)

        # Проверка веса (4 ребра × 10)
        self.assertEqual(best_distance, 40)
        # Проверка, что все 6 перестановок сохранены как оптимальные
        self.assertEqual(len(best_routes), 6)



if __name__ == '__main__':
    unittest.main(verbosity=2)