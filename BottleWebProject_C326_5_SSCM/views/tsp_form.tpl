% rebase('layout.tpl', title='Задача коммивояжёра')

<div class="task-hero">
    <h1>Задача коммивояжёра</h1>
    <p class="task-subtitle">Поиск гамильтонова цикла минимального веса методом полного перебора</p>
</div>

<div class="task-container">
    
    <div class="task-section">
        <h2>Условие задачи</h2>
        <div class="task-description">
            <p>Дан полный взвешенный неориентированный граф из <strong>N</strong> вершин (N ≤ 12).</p>
            <p>Требуется найти <strong>гамильтонов цикл минимального веса</strong> — замкнутый путь, проходящий через каждую вершину ровно один раз.</p>
        </div>
        
        <div class="task-details">
            <div class="detail-item">
                <span class="detail-icon">📥</span>
                <div>
                    <h4>Формат ввода</h4>
                    <p>Матрица расстояний размером N×N, где элемент A[i][j] — вес ребра между вершинами i и j.</p>
                </div>
            </div>
            <div class="detail-item">
                <span class="detail-icon">⚙️</span>
                <div>
                    <h4>Алгоритм</h4>
                    <p>Полный перебор всех возможных гамильтоновых циклов с выбором минимального по весу.</p>
                </div>
            </div>
            <div class="detail-item">
                <span class="detail-icon">📤</span>
                <div>
                    <h4>Формат вывода</h4>
                    <p>Минимальный вес цикла и последовательность вершин в оптимальном маршруте.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="task-section">
        <h2>Ввод данных</h2>
        
        <div class="input-block">
            <div class="input-header">
                <h3>Размер графа</h3>
                <p class="input-hint">Введите количество вершин (от 2 до 12)</p>
            </div>
            <div class="input-row">
                <label class="input-label" for="vertex-count">N =</label>
                <input type="number" id="vertex-count" class="input-field input-small" min="2" max="12" value="4" placeholder="4">
                <button class="btn-generate">Сгенерировать матрицу</button>
            </div>
        </div>

        <div class="input-block">
            <div class="input-header">
                <h3>Матрица расстояний</h3>
                <p class="input-hint">Введите веса рёбер. Диагональные элементы заполнены нулями, матрица симметрична</p>
            </div>
            
            <div class="matrix-container">
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
                            <td><input type="text" class="matrix-cell" value="0" disabled></td>
                            <td><input type="text" class="matrix-cell" value="10" placeholder="1-2"></td>
                            <td><input type="text" class="matrix-cell" value="15" placeholder="1-3"></td>
                            <td><input type="text" class="matrix-cell" value="20" placeholder="1-4"></td>
                        </tr>
                        <tr>
                            <td class="matrix-label">2</td>
                            <td><input type="text" class="matrix-cell" value="10" disabled></td>
                            <td><input type="text" class="matrix-cell" value="0" disabled></td>
                            <td><input type="text" class="matrix-cell" value="35" placeholder="2-3"></td>
                            <td><input type="text" class="matrix-cell" value="25" placeholder="2-4"></td>
                        </tr>
                        <tr>
                            <td class="matrix-label">3</td>
                            <td><input type="text" class="matrix-cell" value="15" disabled></td>
                            <td><input type="text" class="matrix-cell" value="35" disabled></td>
                            <td><input type="text" class="matrix-cell" value="0" disabled></td>
                            <td><input type="text" class="matrix-cell" value="30" placeholder="3-4"></td>
                        </tr>
                        <tr>
                            <td class="matrix-label">4</td>
                            <td><input type="text" class="matrix-cell" value="20" disabled></td>
                            <td><input type="text" class="matrix-cell" value="25" disabled></td>
                            <td><input type="text" class="matrix-cell" value="30" disabled></td>
                            <td><input type="text" class="matrix-cell" value="0" disabled></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="button-block">
            <button class="btn-solve">Решить задачу</button>
            <button class="btn-clear">Очистить</button>
        </div>
    </div>

    <div class="task-section">
        <h2>Результат</h2>
        
        <div class="result-block">
            <div class="result-placeholder">
                <span class="result-icon">🔍</span>
                <p>Здесь появится результат после нажатия кнопки «Решить задачу»</p>
            </div>
        </div>
    </div>

    <div class="task-section">
        <h2>Пример работы</h2>
        
        <div class="example-block">
            <h4>Входные данные (N = 4):</h4>
            <div class="example-matrix">
                <pre> 0 10 15 20
10  0 35 25
15 35  0 30
20 25 30  0</pre>
            </div>
            
            <div class="example-arrow">↓</div>
            
            <h4>Результат:</h4>
            <div class="example-result">
                <p><strong>Минимальный вес:</strong> 80</p>
                <p><strong>Оптимальный маршрут:</strong> 1 → 2 → 4 → 3 → 1</p>
            </div>
        </div>
    </div>
</div>