import unittest
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from handlers.kos_form import kosaraju, g_from_form, validate_G


class TestKosaraju(unittest.TestCase):
    """Тесты алгоритма Косарайю"""

    #ТЕСТ 1
    def test_single_vertex(self):
        """Граф из одной вершины"""
        G = [[0]]
        count, components = kosaraju(G, 1)

        self.assertEqual(count, 1)
        self.assertEqual(components, [[1]])

    #ТЕСТ 2
    def test_two_connected_vertexes(self):
        """Две вершины образуют компоненту сильной связности"""
        G = [
            [0, 1],
            [1, 0]
        ]

        count, components = kosaraju(G, 2)

        self.assertEqual(count, 1)
        self.assertEqual(components, [[1, 2]])

    #ТЕСТ 3
    def test_two_unconnected_vertexes(self):
        """Две вершины без ребер"""
        G = [
            [0, 0],
            [0, 0]
        ]

        count, components = kosaraju(G, 2)

        self.assertEqual(count, 2)

    #ТЕСТ 4
    def test_chain_graph(self):
        """Цепочка 1-2-3 - все вершины в разных компонентах (нет обратных путей)"""
        G = [
            [0, 1, 0],
            [0, 0, 1],
            [0, 0, 0]
        ]

        count, components = kosaraju(G, 3)

        self.assertEqual(count, 3)

    #ТЕСТ 5
    def test_cycle_graph(self):
        """Цикл 1-2-3-1 - все вершины в одной компоненте"""
        G = [
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 0]
        ]

        count, components = kosaraju(G, 3)

        self.assertEqual(count, 1)
        self.assertEqual(len(components[0]), 3)

    #ТЕСТ 6
    def test_two_components(self):
        """Две компоненты сильной связности"""
        G = [
            [0,1,0,0],
            [1,0,0,0],
            [0,0,0,1],
            [0,0,1,0]
        ]

        count, components = kosaraju(G, 4)

        self.assertEqual(count, 2)

    #ТЕСТ 7
    def test_complete_graph(self):
        """Полносвязный ориентированный граф"""
        G = [
            [0,1,1],
            [1,0,1],
            [1,1,0]
        ]

        count, components = kosaraju(G, 3)

        self.assertEqual(count, 1)

    #ТЕСТ 8
    def test_no_edges(self):
        """Граф без ребер"""
        G = [
            [0,0,0],
            [0,0,0],
            [0,0,0]
        ]

        count, components = kosaraju(G, 3)

        self.assertEqual(count, 3)

    #ТЕСТ 9
    def test_large_cycle(self):
        """Цикл из 5 вершин"""
        G = [
            [0,1,0,0,0],
            [0,0,1,0,0],
            [0,0,0,1,0],
            [0,0,0,0,1],
            [1,0,0,0,0]
        ]

        count, components = kosaraju(G, 5)
        self.assertEqual(count, 1)
    
    #ТЕСТ 10
    def test_max_vertexes_cycle(self):
        """Цикл из максимального количества вершин(14)"""
        n = 14
        G = [[0] * n for _ in range(n)]
        for i in range(n):
            G[i][(i+1) % n] = 1
        count, components = kosaraju(G, n)
        self.assertEqual(count, 1)
    
    #ТЕСТ 11
    def test_all_vertexes_present(self):
        """Проверка что все вершины распределены по компонентам"""
        G = [
            [0, 1, 0, 0],
            [1, 0, 0, 0],
            [0, 0, 0, 1],
            [0, 0, 1, 0]
        ]
        count, components = kosaraju(G, 4)
        all_vertexes = []
        for component in components:
            all_vertexes.extend(component)
        self.assertEqual(sorted(all_vertexes), [1, 2, 3, 4])

    

class TestParseMatrix(unittest.TestCase): 
    """Тесты преобразования текста в матрицу смежности"""

    #ТЕСТ 12
    def test_parse_simple_matrix(self):
        """Обычная матрица 3х3"""
        text = "0 1 0\n1 0 1\n0 0 0"
        G = g_from_form(text, 3)
        self.assertEqual(G, [[0,1,0], [1,0,1], [0,0,0]])

    #ТЕСТ 13
    def test_parse_with_extra_spaces(self):
            """Матрица с лишними пробелами"""
            text = "  0   1  0  \n  1  0  1  \n  0  0  0  "
            G = g_from_form(text, 3)
            self.assertEqual(G, [[0,1,0], [1,0,1], [0,0,0]])

    #ТЕСТ 14
    def test_parse_negative_numbers(self):
        """Отрицательные числа"""
        text = "0 -1 0\n1 0 1\n0 0 0"
        with self.assertRaises(ValueError):
            g_from_form(text, 3)



class TestValidateMatrix(unittest.TestCase):
    """Тесты проверки корректности матрицы смежности"""

    #ТЕСТ 15
    def test_valid_matrix(self):
        """Корректная матрица"""
        G = [[0,1,0], [1,0,1], [0,0,0]]
        valid, error = validate_G(G, 3)
        self.assertTrue(valid)
        self.assertIsNone(error)

    #ТЕСТ 16
    def test_invalid_diagonal(self):
        """На диагонали не может быть 1"""
        G = [
            [1,0],
            [0,0]
        ]
        valid, error = validate_G(G, 2)
        self.assertFalse(valid)

    #ТЕСТ 17
    def test_invalid_value(self):
        """Элементы матрицы быть только 0 или 1"""
        G = [
            [0,2],
            [0,0]
        ]
        valid, error = validate_G(G, 2)
        self.assertFalse(valid)



if __name__ == "__main__":
    unittest.main(verbosity=2)