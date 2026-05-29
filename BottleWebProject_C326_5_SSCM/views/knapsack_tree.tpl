% # knapsack_tree.tpl - Задача о рюкзаке на дереве
% rebase('layout.tpl', title='Задача о рюкзаке на дереве')



<div class="container">
    <div class="header">
        <h1>Задача о рюкзаке на дереве</h1>
        <p>Динамическое программирование на деревьях | Сложность O(N²·W²)</p>
    </div>

    <!-- ТЕОРИЯ с якорем -->
    <div class="theory">
        <h2>📖 Теория метода</h2>
        <p><strong>Суть алгоритма:</strong> Задача о рюкзаке на дереве — обобщение классической задачи о рюкзаке на древовидные структуры. Каждая вершина имеет вес и ценность.</p>
        <h3>📋 Условия задачи</h3>
        <ul>
            <li>Суммарный вес выбранных вершин не превышал заданный лимит <strong>W</strong></li>
            <li>Если вершина выбрана, то её родительская вершина также выбрана</li>
            <li>Максимизировать суммарную ценность выбранных вершин</li>
        </ul>
        <h3>⚙️ Как работает алгоритм</h3>
        <ol>
            <li>Выбирается корень дерева (обычно вершина 1)</li>
            <li>Выполняется обход в глубину (DFS) от корня</li>
            <li>Для каждой вершины вычисляется DP[вес] = максимальная ценность в её поддереве</li>
            <li>При слиянии результатов детей используется классическая задача о рюкзаке</li>
        </ol>
        <h3>📐 Сложность</h3>
        <p><strong>O(N²·W²)</strong>, где N ≤ 50, W ≤ 100.</p>
        <!-- ЯКОРЬ НА ФОРМУ -->
        <a href="#inputForm" class="anchor-link">📝 Перейти к форме ввода →</a>
    </div>

    <!-- ПРИМЕР -->
    <div class="example">
        <h2>💡 Пример</h2>
        <div class="example-tree">
            <strong>Дерево:</strong><br>
            1 (2,10)<br>
            ├── 2 (3,20)<br>
            │   └── 4 (2,5)<br>
            └── 3 (1,5)<br>
            &nbsp;&nbsp;&nbsp;&nbsp;└── 5 (1,100)<br>
            <strong>W=7 → Решение:</strong> вершины 1,2,3,5 → Ценность: 135
        </div>
    </div>

    <!-- ФОРМА с якорем -->
    <div class="form-card" id="inputForm">
        <h2>📝 Ввод данных</h2>

        <!-- КНОПКИ ДЛЯ РАБОТЫ С ФАЙЛАМИ -->
        <div class="file-buttons">
            <button class="btn-file" onclick="saveToJSON()">💾 Сохранить в JSON</button>
            <label class="btn-file" style="cursor: pointer;">📂 Загрузить из JSON
                <input type="file" id="jsonFileInput" accept=".json" style="display: none;" onchange="loadFromJSON(event)">
            </label>
        </div>

        <form action="/knapsack_tree/solve" method="post" id="mainForm">
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <div style="flex: 1;">
                    <div class="form-group">
                        <label>🔢 Вершин (N ≤ 50)</label>
                        <input type="number" name="n" id="inputN" value="{{n or '5'}}" min="1" max="50" required>
                    </div>
                </div>
                <div style="flex: 1;">
                    <div class="form-group">
                        <label>⚖️ Макс. вес (W ≤ 100)</label>
                        <input type="number" name="w_max" id="inputW" value="{{w_max or '7'}}" min="1" max="100" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>🏋️ Веса вершин</label>
                <input type="text" name="weights" id="inputWeights" value="{{weights or '2 3 1 2 1'}}" placeholder="2 3 1 2 1">
                <span class="small-text">через пробел, количество = N</span>
            </div>

            <div class="form-group">
                <label>💎 Ценности вершин</label>
                <input type="text" name="values" id="inputValues" value="{{values or '10 20 5 5 100'}}" placeholder="10 20 5 5 100">
                <span class="small-text">через пробел, количество = N</span>
            </div>

            <div class="form-group">
                <label>🔗 Рёбра дерева</label>
                <textarea name="edges" id="inputEdges" rows="4" placeholder="1 2&#10;1 3&#10;2 4">{{edges or '1 2\n1 3\n2 4\n2 5'}}</textarea>
                <span class="small-text">формат: родитель потомок (N-1 строк)</span>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-solve">🔍 РЕШИТЬ ЗАДАЧУ</button>
                <button type="reset" class="btn-reset">🗑️ Очистить</button>
            </div>
        </form>
        <button class="btn-generate" onclick="generateExample()">🎲 Загрузить пример</button>
    </div>

    <!-- РЕЗУЛЬТАТ -->
    <div class="result-card">
        <h2>📊 Результат</h2>

        % if result is not None and not error:
            <div class="result-box">
                <div class="max-value">{{max_value}}</div>
                <div style="margin-bottom: 12px;">максимальная ценность</div>

                <div><strong>✅ Выбранные вершины:</strong></div>
                <div class="selected-list">
                    % if selected_vertices:
                        % for v in selected_vertices.split():
                            <span class="tag">Вершина {{v}}</span>
                        % end
                    % else:
                        <span class="tag">Нет</span>
                    % end
                </div>

                <div style="margin-top: 10px;">
                    <strong>⚖️ Общий вес:</strong> {{total_weight}} / {{w_max}}
                </div>
            </div>
        % elif error:
            <div class="error-msg">
                <strong>⚠️ Ошибка:</strong> {{error}}
            </div>
        % else:
            <div style="text-align:center; padding: 30px; color: #888;">
                <div style="font-size: 40px;">🎒</div>
                <p>Введите данные и нажмите «РЕШИТЬ ЗАДАЧУ»</p>
            </div>
        % end
    </div>

    <!-- ТЕКСТОВОЕ ДЕРЕВО -->
    % if result is not None and not error and tree_html:
    <div class="result-card">
        <h2>🌳 Структура дерева</h2>
        <div class="tree-container">
            <pre>{{!tree_html}}</pre>
        </div>
        <div class="tree-legend">
            ✅ - вершина входит в оптимальное решение
        </div>
    </div>
    % end

    <!-- НАВИГАЦИЯ -->
    <div class="nav-links">
        <a href="/" class="nav-btn">🏠 Домой</a>
        <button onclick="window.print();" class="nav-btn">🖨️ Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">⬅️ Назад</a>
    </div>
</div>

<script>
// Генерация примера
function generateExample() {
    document.getElementById('inputN').value = '5';
    document.getElementById('inputW').value = '7';
    document.getElementById('inputWeights').value = '2 3 1 2 1';
    document.getElementById('inputValues').value = '10 20 5 5 100';
    document.getElementById('inputEdges').value = '1 2\n1 3\n2 4\n2 5';
    document.getElementById('mainForm').submit();
}

// Сохранение в JSON
function saveToJSON() {
    const data = {
        n: parseInt(document.getElementById('inputN').value),
        W: parseInt(document.getElementById('inputW').value),
        weights: document.getElementById('inputWeights').value.split(' ').map(Number),
        values: document.getElementById('inputValues').value.split(' ').map(Number),
        edges: document.getElementById('inputEdges').value.trim().split('\n').map(line => {
            const parts = line.trim().split(' ');
            return [parseInt(parts[0]), parseInt(parts[1])];
        })
    };

    const jsonStr = JSON.stringify(data, null, 2);
    const blob = new Blob([jsonStr], {type: 'application/json'});
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'knapsack_data.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// Загрузка из JSON
function loadFromJSON(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function(e) {
        try {
            const data = JSON.parse(e.target.result);

            document.getElementById('inputN').value = data.n || '';
            document.getElementById('inputW').value = data.W || '';
            document.getElementById('inputWeights').value = data.weights ? data.weights.join(' ') : '';
            document.getElementById('inputValues').value = data.values ? data.values.join(' ') : '';

            let edgesStr = '';
            if (data.edges && Array.isArray(data.edges)) {
                edgesStr = data.edges.map(edge => edge[0] + ' ' + edge[1]).join('\n');
            }
            document.getElementById('inputEdges').value = edgesStr;

        } catch (error) {
            alert('Ошибка при загрузке JSON: ' + error.message);
        }
    };
    reader.readAsText(file);
}
</script>