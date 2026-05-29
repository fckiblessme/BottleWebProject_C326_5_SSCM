% rebase('layout.tpl', title='Задача коммивояжёра')

<div class="container">
    <div class="header">
        <h1>Задача коммивояжёра</h1>
        <p>Поиск гамильтонова цикла минимального веса | Метод полного перебора | Сложность O(N!)</p>
    </div>

    <div class="theory">
        <h2>Теория метода</h2>
        <p><strong>Суть задачи:</strong> Найти кратчайший замкнутый маршрут, проходящий через все города ровно по одному разу и возвращающийся в исходный.</p>
        
        <h3>Важные факты и алгоритм</h3>
        <ul>
            <li><strong>Гамильтонов цикл:</strong> Цикл, проходящий через каждую вершину графа ровно один раз.</li>
            <li><strong>Метод решения:</strong> Полный перебор всех возможных перестановок вершин (кроме фиксированной первой) для поиска цикла минимального веса.</li>
            <li><strong>Сложность:</strong> O(N!), где N ≤ 12.</li>
        </ul>
 
        <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
    </div>

    <div class="example">
        <h2>Подробный пример (N=4)</h2>
        <div class="example-tree">
            <strong>Матрица расстояний:</strong>
            <pre>   1   2   3   4
1  0  10  15  20
2 10   0  35  25
3 15  35   0  30
4 20  25  30   0</pre>
            
            <strong>Все возможные маршруты (фиксируем начало в вершине 1):</strong>
            <div class="example-paths">
                <div class="path-item">
                    <span class="path-route">1 → 2 → 3 → 4 → 1</span>
                    <span class="path-weight">= 10 + 35 + 30 + 20 = <strong>95</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 2 → 4 → 3 → 1</span>
                    <span class="path-weight">= 10 + 25 + 30 + 15 = <strong>80</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 3 → 2 → 4 → 1</span>
                    <span class="path-weight">= 15 + 35 + 25 + 20 = <strong>95</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 3 → 4 → 2 → 1</span>
                    <span class="path-weight">= 15 + 30 + 25 + 10 = <strong>80</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 4 → 2 → 3 → 1</span>
                    <span class="path-weight">= 20 + 25 + 35 + 15 = <strong>95</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 4 → 3 → 2 → 1</span>
                    <span class="path-weight">= 20 + 30 + 35 + 10 = <strong>95</strong></span>
                </div>
            </div>
            
            <div class="example-result-detail">
                <span class="result-badge">✅ Минимальный вес: <strong>80</strong></span>
                <span class="result-badge">📌 Оптимальные маршруты: 1 → 2 → 4 → 3 → 1  и  1 → 3 → 4 → 2 → 1</span>
            </div>
        </div>
    </div>

    <div class="form-card" id="inputForm">
        <h2>Ввод данных графа</h2>

        <form action="/tsp/solve" method="post">
            <div class="form-group">
                <label>Количество городов (N ≤ 12)</label>
                <div class="input-row-flex">
                    <input type="number" name="n" value="4" min="2" max="12" required>
                    <button type="submit" name="create" value="1" class="btn-generate">Создать</button>
                </div>
            </div>

            <div class="form-group">
                <label>Матрица расстояний</label>
                <div class="matrix-wrapper">
                    <table class="matrix-table">
                        <thead>
                            <tr>
                                <th></th>
                                <th>1</th>
                                <th>2</th>
                                <th>3</th>
                                <th>4</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="matrix-label">1</td>
                                <td><input type="number" name="m11" value="0" disabled class="matrix-cell"></td>
                                <td><input type="number" name="m12" value="10" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m13" value="15" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m14" value="20" step="1" min="1" class="matrix-cell"></td>
                            </tr>
                            <tr>
                                <td class="matrix-label">2</td>
                                <td><input type="number" name="m21" value="10" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m22" value="0" disabled class="matrix-cell"></td>
                                <td><input type="number" name="m23" value="35" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m24" value="25" step="1" min="1" class="matrix-cell"></td>
                            </tr>
                            <tr>
                                <td class="matrix-label">3</td>
                                <td><input type="number" name="m31" value="15" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m32" value="35" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m33" value="0" disabled class="matrix-cell"></td>
                                <td><input type="number" name="m34" value="30" step="1" min="1" class="matrix-cell"></td>
                            </tr>
                            <tr>
                                <td class="matrix-label">4</td>
                                <td><input type="number" name="m41" value="20" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m42" value="25" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m43" value="30" step="1" min="1" class="matrix-cell"></td>
                                <td><input type="number" name="m44" value="0" disabled class="matrix-cell"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="button-row">
                    <button type="submit" name="random" value="1" class="btn-file">Случайные значения</button>
                    <button type="submit" name="submit" value="1" class="btn-solve">Подтвердить ввод</button>
                </div>
            </div>
        </form>
    </div>

    <div class="result-card">
        <h2>Результат</h2>
        <div class="result-placeholder">
            <div style="font-size: 40px;">🗺️</div>
            <p>Результат появится после решения задачи</p>
        </div>
    </div>

    <div class="nav-links">
        <a href="/" class="nav-btn">Домой</a>
        <button onclick="window.print();" class="nav-btn">Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">Назад</a>
    </div>
</div>