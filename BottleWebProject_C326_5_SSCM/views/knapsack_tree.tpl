% # knapsack_tree.tpl - Задача о рюкзаке на дереве
% rebase('layout.tpl', title='Задача о рюкзаке на дереве')

<link rel="stylesheet" href="/static/content/knapsack_tree.css">

<div class="container">
    <div class="header">
        <h1>Задача о рюкзаке на дереве</h1>
        <p>Динамическое программирование на деревьях | Сложность O(N²·W²)</p>
    </div>

    <div class="task-section">
        <h2>📖 Теория метода</h2>
        <div class="theory-block">
            <h3>🌳 Что такое дерево?</h3>
            <p>Дерево — это связный граф без циклов. В нашем случае дерево состоит из вершин (узлов) и рёбер (связей между ними). Одна вершина является корнем (обычно вершина 1), а остальные образуют иерархию: у каждой вершины есть родитель и может быть несколько детей.</p>
        </div>
        <div class="theory-block">
            <h3>🎯 Что такое задача о рюкзаке на дереве?</h3>
            <p>Это обобщение классической задачи о рюкзаке на древовидные структуры. Каждая вершина имеет вес (weight) и ценность (value). Нужно выбрать подмножество вершин так, чтобы:</p>
            <ul class="theory-list">
                <li>Суммарный вес выбранных вершин ≤ W (вместимость рюкзака)</li>
                <li>Если вершина выбрана, то её родитель тоже выбран</li>
                <li>Максимизировать суммарную ценность</li>
            </ul>
        </div>
        <div class="theory-block">
            <h3>⚙️ Как работает алгоритм (ДП на деревьях)</h3>
            <ul class="theory-list">
                <li><strong>Выбор корня:</strong> Фиксируем корень (вершина 1)</li>
                <li><strong>Обход в глубину (DFS):</strong> Рекурсивно обрабатываем детей, затем родителя</li>
                <li><strong>DP для вершины:</strong> Для каждой вершины u вычисляем dp[w] — макс. ценность в поддереве u при весе w</li>
                <li><strong>Слияние детей:</strong> dp_new[w1+w2] = max(dp_new[w1+w2], dp_parent[w1] + dp_child[w2])</li>
                <li><strong>Ответ:</strong> max(dp[root][w]) для всех w ≤ W</li>
            </ul>
        </div>
        <div class="theory-block">
            <h3>📐 Сложность</h3>
            <p><strong>O(N²·W²)</strong>, где N ≤ 50, W ≤ 100. Выполняется за доли секунды.</p>
        </div>
        <div style="margin-top: 10px;">
            <a href="#inputForm" style="color: #cabfab; text-decoration: none; font-weight: 600;">📝 Перейти к форме ввода →</a>
        </div>
    </div>

    <!-- РАЗОБРАННЫЙ ПРИМЕР -->
    <div class="task-section">
        <h2>💡 Разобранный пример</h2>

        <div class="example-content">
            <div class="example-image-side">
                <img src="/static/content/tree_example.png" alt="Дерево">
                <p style="font-size: 12px; color: #888; margin-top: 8px;">🌳 Дерево (тёмные кружки — оптимальное решение)</p>
            </div>
            <div class="example-text-side">
                <div class="example-params">
                    <strong>📊 Параметры задачи</strong><br>
                    N = 5, W = 7<br>
                    Веса: [2, 3, 1, 2, 1]<br>
                    Ценности: [10, 20, 5, 5, 100]<br>
                    Рёбра: (1-2), (1-3), (2-4), (3-5)
                </div>
                <div class="example-solution">
                    <strong>✅ Оптимальное решение</strong><br>
                    Выбранные вершины: 1, 2, 3, 5<br>
                    Вес: 2+3+1+1 = 7<br>
                    Ценность: <strong style="color:#2e7d32;">135</strong>
                </div>
            </div>
        </div>

        <div class="example-explanation">
            <strong>🔍 Почему эти вершины?</strong>
            <ul>
                <li><strong>Вершина 5</strong> (w=1, v=100) — самая выгодная, берём</li>
                <li><strong>Вершина 3</strong> (w=1, v=5) — родитель вершины 5</li>
                <li><strong>Вершина 2</strong> (w=3, v=20) — выгодная</li>
                <li><strong>Вершина 4</strong> (w=2, v=5) — невыгодная, пропускаем</li>
                <li><strong>Вершина 1</strong> (w=2, v=10) — корень</li>
            </ul>
        </div>
    </div>

    <!-- ФОРМА ВВОДА -->
    <div class="task-section" id="inputForm">
        <h2>📝 Ввод данных</h2>

        <div class="file-row">
            <button type="button" class="btn-file" id="saveJsonBtn">💾 Сохранить в JSON</button>
            <label class="btn-file" style="cursor:pointer;">📂 Загрузить из JSON
                <input type="file" id="jsonFileInput" accept=".json" style="display:none;">
            </label>
        </div>

        <div id="errorMessage" style="display: none; background: #ffebee; color: #c62828; padding: 10px; border-radius: 8px; margin: 10px 0; border-left: 4px solid #c62828; font-size: 13px;">
            ⚠️ ОШИБКА: Максимальное количество вершин - 20. Пожалуйста, уменьшите N.
        </div>

        <form action="/knapsack_tree/solve" method="post" id="mainForm">
            <div style="display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 20px;">
                <div style="flex:1; min-width: 150px;">
                    <div class="form-group">
                        <label>🔢 Вершин (N ≤ 20)</label>
                        <input type="number" name="n" id="inputN" class="input-field input-small"
                               value="{{n or '5'}}" min="1" max="20" required>
                    </div>
                </div>
                <div style="flex:1; min-width: 150px;">
                    <div class="form-group">
                        <label>⚖️ Макс. вес (W ≤ 100)</label>
                        <input type="number" name="w_max" id="inputW" class="input-field input-small"
                               value="{{w_max or '7'}}" min="1" max="100" required>
                    </div>
                </div>
            </div>

            <div class="table-caption">📊 Веса и ценности вершин</div>
            <table class="data-table" id="weightsValuesTable">
                <thead>
                    <tr><th>ID</th><th>⚖️ Вес</th><th>💎 Ценность</th></tr>
                </thead>
                <tbody id="weightsValuesBody"></tbody>
            </table>

            <div class="table-caption">🔗 Рёбра дерева</div>
            <table class="edges-table" id="edgesTable">
                <thead>
                    <tr><th>№</th><th>Родитель (u)</th><th>Потомок (v)</th><th></th></tr>
                </thead>
                <tbody id="edgesBody"></tbody>
            </table>

            <div class="button-row">
                <div class="btn-group">
                    <button type="submit" class="btn-solve">РЕШИТЬ</button>
                    <button type="button" class="btn-reset" id="resetBtn">Очистить</button>
                    <button type="button" class="btn-generate" id="generateExampleBtn">Загрузить пример</button>
                </div>
            </div>

            <input type="hidden" name="weights" id="hiddenWeights">
            <input type="hidden" name="values" id="hiddenValues">
            <input type="hidden" name="edges" id="hiddenEdges">
        </form>
    </div>

    <!-- РЕЗУЛЬТАТ -->
    <div class="task-section">
        <h2>📊 Результат</h2>
        <div class="result-block" id="resultBlock">
            % if result is not None and not error:
                <div class="result-content">
                    <div class="result-text">
                        <div class="result-value">{{max_value}}</div>
                        <div style="margin-bottom: 12px;">максимальная ценность</div>
                        <div><strong>✅ Выбранные вершины:</strong></div>
                        <div class="selected-list">
                            % if selected_vertices:
                                % for v in selected_vertices.split():
                                    <span class="tag">Вершина {{v}}</span>
                                % end
                            % end
                        </div>
                        <div><strong>⚖️ Общий вес:</strong> {{total_weight}} / {{w_max}}</div>
                    </div>

                    <div class="result-image-side" style="flex: 0 0 700px; text-align: center;">
                        <h3 style="font-size: 14px; margin-bottom: 10px;">🌳 Ваше дерево</h3>
                        % if tree_image:
                            <img src="{{tree_image}}" alt="Граф дерева"
                                 style="width: 100%; border-radius: 12px; border: 2px solid #cabfab; background: #faf9f6;">
                        % else:
                            <div style="width: 100%; height: 400px; background: #faf9f6; border-radius: 12px; border: 2px solid #cabfab; display: flex; align-items: center; justify-content: center; color: #888;">
                                ⚠️ Изображение не загрузилось
                            </div>
                        % end
                        <p style="font-size: 11px; color: #888; margin-top: 8px;">*Тёмные вершины — оптимальное решение</p>
                    </div>
                </div>
            % elif error:
                <div class="error-msg"><strong>⚠️ Ошибка:</strong> {{error}}</div>
            % else:
                <div class="result-placeholder">
                    <span style="font-size: 32px;">🎒</span>
                    <p>Введите данные и нажмите «Решить»</p>
                </div>
            % end
        </div>
    </div>

    <!-- НАВИГАЦИЯ -->
    <div class="nav-links">
        <a href="/" class="nav-btn">🏠 Домой</a>
        <button onclick="window.print();" class="nav-btn">🖨️ Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">⬅️ Назад</a>
    </div>
</div>

<script>
// ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
let currentN = 5;

function getVertexOptions() {
    const n = parseInt(document.getElementById('inputN').value) || 5;
    let options = '';
    for (let i = 1; i <= n; i++) {
        options += `<option value="${i}">${i}</option>`;
    }
    return options;
}

function renumberEdges() {
    const rows = document.querySelectorAll('#edgesBody tr');
    rows.forEach((row, index) => {
        const newNum = index + 1;
        row.cells[0].innerHTML = `<strong>${newNum}</strong>`;
        const selectU = row.cells[1].querySelector('select');
        const selectV = row.cells[2].querySelector('select');
        if (selectU) {
            selectU.id = `edge_u_${newNum}`;
            selectU.name = `edge_u_${newNum}`;
        }
        if (selectV) {
            selectV.id = `edge_v_${newNum}`;
            selectV.name = `edge_v_${newNum}`;
        }
    });
}

function deleteEdge(btn) {
    const row = btn.parentElement.parentElement;
    const idx = row.cells[0].innerText;
    if (confirm(`Удалить ребро №${idx}?`)) {
        row.remove();
        renumberEdges();
        updateTables();
    }
}

function addNewEdge() {
    const options = getVertexOptions();
    const edgesBody = document.getElementById('edgesBody');
    const newId = edgesBody.children.length + 1;
    const row = edgesBody.insertRow();
    row.insertCell(0).innerHTML = `<strong>${newId}</strong>`;
    row.insertCell(1).innerHTML = `<select id="edge_u_${newId}" name="edge_u_${newId}" style="width:80px">${options}</select>`;
    row.insertCell(2).innerHTML = `<select id="edge_v_${newId}" name="edge_v_${newId}" style="width:80px">${options}</select>`;
    row.insertCell(3).innerHTML = `<button type="button" class="remove-edge-btn" style="background:none;border:none;cursor:pointer;font-size:16px;">🗑️</button>`;

    const delBtn = row.cells[3].querySelector('button');
    delBtn.onclick = function() { deleteEdge(this); };
    renumberEdges();
}

function addEdgeRowWithValues(u, v) {
    const options = getVertexOptions();
    const edgesBody = document.getElementById('edgesBody');
    const newId = edgesBody.children.length + 1;
    const row = edgesBody.insertRow();
    row.insertCell(0).innerHTML = `<strong>${newId}</strong>`;
    row.insertCell(1).innerHTML = `<select id="edge_u_${newId}" name="edge_u_${newId}" style="width:80px">${options}</select>`;
    row.insertCell(2).innerHTML = `<select id="edge_v_${newId}" name="edge_v_${newId}" style="width:80px">${options}</select>`;
    row.insertCell(3).innerHTML = `<button type="button" class="remove-edge-btn" style="background:none;border:none;cursor:pointer;font-size:16px;">🗑️</button>`;

    document.getElementById(`edge_u_${newId}`).value = u;
    document.getElementById(`edge_v_${newId}`).value = v;

    const delBtn = row.cells[3].querySelector('button');
    delBtn.onclick = function() { deleteEdge(this); };
    renumberEdges();
}

function updateTables() {
    const n = parseInt(document.getElementById('inputN').value) || 5;
    if (n > 20) {
        document.getElementById('inputN').value = 20;
        document.getElementById('errorMessage').style.display = 'block';
        alert("Максимальное количество вершин - 20!");
        return;
    } else {
        document.getElementById('errorMessage').style.display = 'none';
    }
    if (n < 1) return;
    currentN = n;

    const tbody = document.getElementById('weightsValuesBody');
    tbody.innerHTML = '';
    for (let i = 1; i <= n; i++) {
        const row = tbody.insertRow();
        row.insertCell(0).innerHTML = `<strong>${i}</strong>`;
        row.insertCell(1).innerHTML = `<input type="number" id="w_${i}" value="1" min="1" max="100" style="width:80px">`;
        row.insertCell(2).innerHTML = `<input type="number" id="v_${i}" value="1" min="1" max="1000" style="width:80px">`;
    }

    const edgesBody = document.getElementById('edgesBody');
    const currentRows = edgesBody.children.length;
    const options = getVertexOptions();

    if (currentRows < n - 1) {
        for (let i = currentRows + 1; i <= n - 1; i++) {
            const newId = edgesBody.children.length + 1;
            const row = edgesBody.insertRow();
            row.insertCell(0).innerHTML = `<strong>${newId}</strong>`;
            row.insertCell(1).innerHTML = `<select id="edge_u_${newId}" name="edge_u_${newId}" style="width:80px">${options}</select>`;
            row.insertCell(2).innerHTML = `<select id="edge_v_${newId}" name="edge_v_${newId}" style="width:80px">${options}</select>`;
            row.insertCell(3).innerHTML = `<button type="button" class="remove-edge-btn" style="background:none;border:none;cursor:pointer;font-size:16px;">🗑️</button>`;
            const delBtn = row.cells[3].querySelector('button');
            delBtn.onclick = function() { deleteEdge(this); };
        }
    } else if (currentRows > n - 1) {
        while (edgesBody.children.length > n - 1) {
            edgesBody.deleteRow(-1);
        }
    } else {
        for (let i = 1; i <= edgesBody.children.length; i++) {
            const selectU = document.getElementById(`edge_u_${i}`);
            const selectV = document.getElementById(`edge_v_${i}`);
            if (selectU && selectU.innerHTML !== options) selectU.innerHTML = options;
            if (selectV && selectV.innerHTML !== options) selectV.innerHTML = options;
        }
    }
    renumberEdges();
}

function collectData() {
    const n = parseInt(document.getElementById('inputN').value) || 5;
    const weights = [];
    const values = [];
    for (let i = 1; i <= n; i++) {
        weights.push(document.getElementById(`w_${i}`)?.value || 1);
        values.push(document.getElementById(`v_${i}`)?.value || 1);
    }
    document.getElementById('hiddenWeights').value = weights.join(' ');
    document.getElementById('hiddenValues').value = values.join(' ');

    const edges = [];
    for (let i = 1; i <= n - 1; i++) {
        const u = document.getElementById(`edge_u_${i}`)?.value;
        const v = document.getElementById(`edge_v_${i}`)?.value;
        if (u && v) edges.push(`${u} ${v}`);
    }
    document.getElementById('hiddenEdges').value = edges.join('\n');
}

function resetForm() {
    document.getElementById('inputN').value = '5';
    document.getElementById('inputW').value = '7';
    document.getElementById('errorMessage').style.display = 'none';

    const n = 5;
    for (let i = 1; i <= n; i++) {
        const wInput = document.getElementById(`w_${i}`);
        const vInput = document.getElementById(`v_${i}`);
        if (wInput) wInput.value = '1';
        if (vInput) vInput.value = '1';
    }

    const edgesBody = document.getElementById('edgesBody');
    edgesBody.innerHTML = '';
    const options = getVertexOptions();
    for (let i = 1; i <= 4; i++) {
        const row = edgesBody.insertRow();
        row.insertCell(0).innerHTML = `<strong>${i}</strong>`;
        row.insertCell(1).innerHTML = `<select id="edge_u_${i}" name="edge_u_${i}" style="width:80px">${options}</select>`;
        row.insertCell(2).innerHTML = `<select id="edge_v_${i}" name="edge_v_${i}" style="width:80px">${options}</select>`;
        row.insertCell(3).innerHTML = `<button type="button" class="remove-edge-btn" style="background:none;border:none;cursor:pointer;font-size:16px;">🗑️</button>`;
        const delBtn = row.cells[3].querySelector('button');
        delBtn.onclick = function() { deleteEdge(this); };
    }
    renumberEdges();
    collectData();
}

function fillExample() {
    document.getElementById('inputN').value = '5';
    document.getElementById('inputW').value = '7';
    updateTables();

    document.getElementById('w_1').value = '2'; document.getElementById('v_1').value = '10';
    document.getElementById('w_2').value = '3'; document.getElementById('v_2').value = '20';
    document.getElementById('w_3').value = '1'; document.getElementById('v_3').value = '5';
    document.getElementById('w_4').value = '2'; document.getElementById('v_4').value = '5';
    document.getElementById('w_5').value = '1'; document.getElementById('v_5').value = '100';

    const edgesBody = document.getElementById('edgesBody');
    edgesBody.innerHTML = '';
    const exampleEdges = [[1,2],[1,3],[2,4],[3,5]];
    const options = getVertexOptions();
    exampleEdges.forEach((e, idx) => {
        const row = edgesBody.insertRow();
        row.insertCell(0).innerHTML = `<strong>${idx+1}</strong>`;
        row.insertCell(1).innerHTML = `<select id="edge_u_${idx+1}" name="edge_u_${idx+1}" style="width:80px">${options}</select>`;
        row.insertCell(2).innerHTML = `<select id="edge_v_${idx+1}" name="edge_v_${idx+1}" style="width:80px">${options}</select>`;
        row.insertCell(3).innerHTML = `<button type="button" class="remove-edge-btn" style="background:none;border:none;cursor:pointer;font-size:16px;">🗑️</button>`;
        document.getElementById(`edge_u_${idx+1}`).value = e[0];
        document.getElementById(`edge_v_${idx+1}`).value = e[1];
        const delBtn = row.cells[3].querySelector('button');
        delBtn.onclick = function() { deleteEdge(this); };
    });
    renumberEdges();
    collectData();
}

function saveToJSON() {
    collectData();
    const data = {
        n: parseInt(document.getElementById('inputN').value),
        W: parseInt(document.getElementById('inputW').value),
        weights: document.getElementById('hiddenWeights').value.split(' ').map(Number),
        values: document.getElementById('hiddenValues').value.split(' ').map(Number),
        edges: document.getElementById('hiddenEdges').value.trim().split('\n').filter(l => l).map(l => l.split(' ').map(Number))
    };
    const blob = new Blob([JSON.stringify(data, null, 2)], {type:'application/json'});
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = 'knapsack_data.json';
    a.click();
    URL.revokeObjectURL(a.href);
}

function loadFromJSON(event) {
    const file = event.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = function(e) {
        try {
            const data = JSON.parse(e.target.result);
            if (data.n > 20) {
                alert("Ошибка: в файле N > 20, что недопустимо!");
                return;
            }
            document.getElementById('inputN').value = data.n || 5;
            document.getElementById('inputW').value = data.W || 7;
            updateTables();
            for (let i = 1; i <= data.n; i++) {
                if (document.getElementById(`w_${i}`)) document.getElementById(`w_${i}`).value = data.weights[i-1];
                if (document.getElementById(`v_${i}`)) document.getElementById(`v_${i}`).value = data.values[i-1];
            }
            const edgesBody = document.getElementById('edgesBody');
            edgesBody.innerHTML = '';
            if (data.edges) {
                data.edges.forEach((e, idx) => {
                    addEdgeRowWithValues(e[0], e[1]);
                });
            }
            renumberEdges();
            collectData();
        } catch(err) { alert('Ошибка JSON: ' + err.message); }
    };
    reader.readAsText(file);
}

// ============================================================
// ЗАГРУЗКА СОХРАНЁННЫХ ДАННЫХ ИЗ PYTHON (ПОСЛЕ РАСЧЁТА)
// ============================================================
function loadSavedData() {
    const savedN = "{{n}}";
    const savedW = "{{w_max}}";
    const savedWeights = "{{weights}}";
    const savedValues = "{{values}}";
    const savedEdges = `{{edges}}`;

    if (savedN && savedN !== '' && savedN !== '5') {
        document.getElementById('inputN').value = savedN;
        document.getElementById('inputW').value = savedW;

        // Обновляем таблицы под новое N
        updateTables();

        // Заполняем веса и ценности
        if (savedWeights && savedWeights !== '') {
            const weightsArr = savedWeights.split(' ');
            const valuesArr = savedValues.split(' ');
            for (let i = 1; i <= weightsArr.length; i++) {
                if (document.getElementById(`w_${i}`)) {
                    document.getElementById(`w_${i}`).value = weightsArr[i-1];
                    document.getElementById(`v_${i}`).value = valuesArr[i-1];
                }
            }
        }

        // Заполняем рёбра
        if (savedEdges && savedEdges.trim() !== '') {
            const edgesLines = savedEdges.trim().split('\n');
            const edgesBody = document.getElementById('edgesBody');
            edgesBody.innerHTML = '';
            edgesLines.forEach((line) => {
                const parts = line.trim().split(' ');
                if (parts.length === 2) {
                    addEdgeRowWithValues(parseInt(parts[0]), parseInt(parts[1]));
                }
            });
            renumberEdges();
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('resetBtn').addEventListener('click', resetForm);
    document.getElementById('generateExampleBtn').addEventListener('click', fillExample);
    document.getElementById('saveJsonBtn').addEventListener('click', saveToJSON);
    document.getElementById('jsonFileInput').addEventListener('change', loadFromJSON);

    document.getElementById('inputN').addEventListener('change', function() {
        let val = parseInt(this.value);
        if (val > 20) {
            this.value = 20;
            document.getElementById('errorMessage').style.display = 'block';
            alert("Максимальное количество вершин - 20!");
        } else {
            document.getElementById('errorMessage').style.display = 'none';
        }
        if (val < 1) this.value = 1;
        updateTables();
    });

    document.getElementById('mainForm').addEventListener('submit', function(e) {
        collectData();
    });

    updateTables();

    // Загружаем сохранённые данные после инициализации таблиц
    setTimeout(loadSavedData, 50);
});
</script>