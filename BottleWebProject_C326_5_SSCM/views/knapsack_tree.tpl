% # knapsack_tree.tpl - Задача о рюкзаке на дереве
% rebase('layout.tpl', title='Задача о рюкзаке на дереве')

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        background: #dfd8c8;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-size: 14px;
    }

    .container {
        max-width: 1000px;
        margin: 0 auto;
        padding: 20px;
    }

    /* Хедер */
    .header {
        background: #52575d;
        border-radius: 20px;
        padding: 25px;
        margin-bottom: 25px;
        text-align: center;
        color: #dfd8c8;
    }

    .header h1 {
        font-size: 22px;
        color: #cabfab;
        margin-bottom: 8px;
    }

    /* Теория */
    .theory {
        background: #ffffff;
        border-radius: 20px;
        padding: 20px;
        margin-bottom: 25px;
        border-left: 5px solid #cabfab;
    }

    .theory h2 {
        color: #41444b;
        margin-bottom: 12px;
        font-size: 18px;
    }

    .theory h3 {
        color: #41444b;
        margin: 12px 0 8px;
        font-size: 16px;
    }

    .theory p {
        line-height: 1.5;
        color: #52575d;
        margin-bottom: 10px;
        font-size: 14px;
    }

    .theory ul, .theory ol {
        margin-left: 20px;
        margin-bottom: 12px;
        color: #52575d;
        font-size: 14px;
    }

    .anchor-link {
        display: inline-block;
        margin-top: 15px;
        color: #cabfab;
        text-decoration: none;
        font-weight: 600;
    }

    .anchor-link:hover {
        color: #41444b;
    }

    /* Пример */
    .example {
        background: #ffffff;
        border-radius: 20px;
        padding: 20px;
        margin-bottom: 25px;
        border: 2px solid #cabfab;
    }

    .example h2 {
        color: #41444b;
        margin-bottom: 12px;
        font-size: 18px;
    }

    .example-tree {
        background: #faf9f6;
        padding: 12px;
        border-radius: 12px;
        font-family: monospace;
        margin: 10px 0;
        font-size: 13px;
    }

    .example-result {
        background: #e8f5e9;
        padding: 12px;
        border-radius: 12px;
        margin-top: 10px;
        font-size: 14px;
    }

    /* Форма */
    .form-card {
        background: #ffffff;
        border-radius: 20px;
        padding: 20px;
        margin-bottom: 25px;
        border-top: 4px solid #cabfab;
        scroll-margin-top: 20px;
    }

    .form-card h2 {
        color: #41444b;
        margin-bottom: 15px;
        padding-bottom: 8px;
        border-bottom: 2px solid #dfd8c8;
        font-size: 18px;
    }

    .form-group {
        margin-bottom: 15px;
    }

    .form-group label {
        display: block;
        font-weight: 600;
        color: #41444b;
        margin-bottom: 6px;
        font-size: 13px;
    }

    .form-group input,
    .form-group textarea {
        width: 100%;
        padding: 8px 10px;
        border: 2px solid #dfd8c8;
        border-radius: 10px;
        font-size: 14px;
        font-family: 'Courier New', monospace;
        background: #faf9f6;
    }

    .form-group input:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: #cabfab;
        background: #ffffff;
    }

    .small-text {
        font-size: 12px;
        color: #888;
        margin-top: 4px;
        display: block;
    }

    .btn-group {
        display: flex;
        gap: 12px;
        margin-top: 20px;
        flex-wrap: wrap;
    }

    .btn-solve {
        flex: 2;
        padding: 10px;
        background: #41444b;
        color: #dfd8c8;
        border: none;
        border-radius: 30px;
        font-weight: 600;
        cursor: pointer;
        font-size: 14px;
    }

    .btn-solve:hover {
        background: #52575d;
    }

    .btn-reset {
        flex: 1;
        padding: 10px;
        background: #dfd8c8;
        color: #41444b;
        border: 2px solid #cabfab;
        border-radius: 30px;
        font-weight: 600;
        cursor: pointer;
        font-size: 14px;
    }

    .btn-reset:hover {
        background: #cabfab;
    }

    .btn-generate {
        width: 100%;
        margin-top: 12px;
        padding: 10px;
        background: #cabfab;
        color: #41444b;
        border: none;
        border-radius: 30px;
        font-weight: 600;
        cursor: pointer;
        font-size: 14px;
    }

    .btn-generate:hover {
        background: #b8a98e;
    }

    .btn-file {
        width: 48%;
        padding: 8px;
        background: #faf9f6;
        color: #41444b;
        border: 2px solid #cabfab;
        border-radius: 30px;
        font-weight: 600;
        cursor: pointer;
        font-size: 13px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
    }

    .btn-file:hover {
        background: #cabfab;
    }

    .file-buttons {
        display: flex;
        gap: 10px;
        margin-top: 15px;
    }

    /* Результат */
    .result-card {
        background: #ffffff;
        border-radius: 20px;
        padding: 20px;
        border-top: 4px solid #52575d;
    }

    .result-card h2 {
        color: #41444b;
        margin-bottom: 15px;
        padding-bottom: 8px;
        border-bottom: 2px solid #dfd8c8;
        font-size: 18px;
    }

    .result-box {
        background: #faf9f6;
        border-radius: 12px;
        padding: 15px;
        border-left: 4px solid #52575d;
    }

    .max-value {
        font-size: 32px;
        font-weight: bold;
        color: #41444b;
    }

    .selected-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin: 12px 0;
    }

    .tag {
        background: #cabfab;
        color: #41444b;
        padding: 4px 12px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 13px;
    }

    .error-msg {
        background: #ffebee;
        border-left: 4px solid #c62828;
        padding: 12px;
        border-radius: 8px;
        color: #c62828;
        font-size: 14px;
    }

    .nav-links {
        margin-top: 25px;
        padding-top: 15px;
        border-top: 1px solid #cabfab;
        text-align: center;
        display: flex;
        justify-content: center;
        gap: 15px;
        flex-wrap: wrap;
    }

    .nav-btn {
        color: #52575d;
        text-decoration: none;
        padding: 8px 20px;
        border-radius: 30px;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: all 0.3s;
        background: #faf9f6;
        border: 1px solid #cabfab;
        cursor: pointer;
        font-size: 13px;
    }

    .nav-btn:hover {
        background: #cabfab;
        color: #41444b;
    }

    @media (max-width: 768px) {
        .container {
            padding: 10px;
        }
        .btn-group {
            flex-direction: column;
        }
        .file-buttons {
            flex-direction: column;
        }
        .btn-file {
            width: 100%;
        }
    }
</style>

<div class="container">
    <!-- ХЕДЕР -->
    <div class="header">
        <h1>Задача о рюкзаке на дереве</h1>
        <p>Динамическое программирование на деревьях | Сложность O(N²·W²)</p>
    </div>

    <!-- ТЕОРИЯ -->
    <div class="theory">
        <h2>📖 Теория метода</h2>
        <p><strong>Суть алгоритма:</strong> Задача о рюкзаке на дереве — обобщение классической задачи о рюкзаке на древовидные структуры. Каждая вершина имеет вес и ценность.</p>

        <h3>📋 Условия задачи</h3>
        <p>Необходимо выбрать подмножество вершин так, чтобы:</p>
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
        <p><strong>O(N²·W²)</strong>, где N — количество вершин (≤ 50), W — максимальный вес (≤ 100).</p>

        <!-- ЯКОРЬ НА ФОРМУ -->
        <a href="#inputForm" class="anchor-link">📝 Перейти к форме ввода →</a>
    </div>

    <!-- ПРИМЕР -->
    <div class="example">
        <h2>💡 Пример</h2>
        <div class="example-tree">
            <strong>Дерево:</strong><br>
            1 (вес=2, ценность=10)<br>
            ├── 2 (вес=3, ценность=20)<br>
            │   └── 4 (вес=2, ценность=5)<br>
            └── 3 (вес=1, ценность=5)<br>
            &nbsp;&nbsp;&nbsp;&nbsp;└── 5 (вес=1, ценность=100)
        </div>
        <div class="example-result">
            <strong>Параметры:</strong> N=5, W=7<br>
            <strong>Решение:</strong> вершины 1, 2, 3, 5<br>
            <strong>Вес:</strong> 7 | <strong>Ценность:</strong> 135
        </div>
    </div>

    <!-- ФОРМА (с якорем) -->
    <div class="form-card" id="inputForm">
        <h2>📝 Ввод данных</h2>

        <!-- Кнопки работы с файлами -->
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

        % if result is not None:
            % if not error:
                <div class="result-box">
                    <div class="max-value">{{max_value}}</div>
                    <div style="margin-bottom: 12px;">максимальная ценность</div>

                    <div><strong>✅ Выбранные вершины:</strong></div>
                    <div class="selected-list">
                        % selected_list = selected_vertices.split() if selected_vertices else []
                        % for v in selected_list:
                            <span class="tag">Вершина {{v}}</span>
                        % end
                    </div>

                    <div style="margin-top: 10px;">
                        <strong>⚖️ Общий вес:</strong> {{total_weight}} / {{w_max}}
                    </div>
                </div>
            % else:
                <div class="error-msg">
                    <strong>⚠️ Ошибка:</strong> {{error}}
                </div>
            % end
        % else:
            <div style="text-align:center; padding: 30px; color: #888;">
                <div style="font-size: 40px;">🎒</div>
                <p>Введите данные и нажмите «РЕШИТЬ ЗАДАЧУ»</p>
            </div>
        % end
    </div>

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

// Сохранение в JSON файл
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

// Загрузка из JSON файла
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
            alert('Ошибка при загрузке JSON файла: ' + error.message);
        }
    };
    reader.readAsText(file);
}
</script>