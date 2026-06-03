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

class TestTSPValidation(unittest.TestCase):
    """Тесты валидации входных данных"""

    # ТЕСТ 6: N меньше 2
    def test_n_too_small(self):
        """TC-06: N < 2"""
        # Проверка пустого значения, 0 и 1
        for n in ['', '0', '1']:
            ok, error = checking_n(n)
            self.assertFalse(ok)

    # ТЕСТ 7: N больше 12
    def test_n_too_large(self):
        """TC-07: N > 12"""
        # Проверка значений 13 и 20
        for n in ['13', '20']:
            ok, error = checking_n(n)
            self.assertFalse(ok)

    # ТЕСТ 8: Корректные N
    def test_n_valid(self):
        """TC-08: N от 2 до 12"""
        # Проверка граничных и среднего значений
        for n in ['2', '5', '12']:
            ok, error = checking_n(n)
            self.assertTrue(ok)


    # ТЕСТ 9: Пустая ячейка
    def test_cell_empty(self):
        """TC-09: Пустая ячейка матрицы"""
        ok, error = checking_cell('', 1, 2)
        self.assertFalse(ok)

    # ТЕСТ 10: Отрицательное значение
    def test_cell_negative(self):
        """TC-10: Отрицательное значение ячейки матрицы"""
        ok, error = checking_cell('-5', 1, 2)
        self.assertFalse(ok)

    # ТЕСТ 11: Дробное значение
    def test_cell_float(self):
        """TC-11: Дробное значение"""
        ok, error = checking_cell('5.5', 1, 2)
        self.assertFalse(ok)

    # ТЕСТ 12: Текстовое значение
    def test_cell_text(self):
        """TC-12: Недопустимые символы"""
        ok, error = checking_cell('abc', 1, 2)
        self.assertFalse(ok)

    # ТЕСТ 13: Нулевое значение
    def test_cell_zero(self):
        """TC-13: Ноль"""
        ok, error = checking_cell('0', 1, 2)
        self.assertFalse(ok)

    # ТЕСТ 14: Корректная ячейка
    def test_cell_valid(self):
        """TC-14: Корректные значения"""
        # Проверка минимального, среднего и большого значений
        for v in ['1', '50', '999']:
            ok, error = checking_cell(v, 1, 2)
            self.assertTrue(ok)

class TestTSPRandomMatrix(unittest.TestCase):
    """Тесты генерации случайной матрицы"""

    # ТЕСТ 15: Размер матрицы
    def test_matrix_size(self):
        """TC-15: Матрица имеет размер N×N"""
        # Проверка для разных размеров
        for n in [2, 5, 8]:
            m = get_random_matrix(n)
            # Проверка количества строк
            self.assertEqual(len(m), n)
            # Проверка количества столбцов в каждой строке
            for row in m:
                self.assertEqual(len(row), n)

    # ТЕСТ 16: Симметричность матрицы
    def test_matrix_symmetry(self):
        """TC-16: Матрица симметрична"""
        m = get_random_matrix(5)
        # Проверка симметричности над диагональю
        for i in range(5):
            for j in range(i + 1, 5):
                self.assertEqual(m[i][j], m[j][i])

    # ТЕСТ 17: Диапазон значений
    def test_matrix_values(self):
        """TC-17: Значения от 1 до 99"""
        m = get_random_matrix(5)
        # Проверка диапазона для всех рёбер
        for i in range(5):
            for j in range(i + 1, 5):
                self.assertGreaterEqual(m[i][j], 1)
                self.assertLessEqual(m[i][j], 99)


if __name__ == '__main__':
    unittest.main(verbosity=2)