% rebase('layout.tpl', title='Компоненты сильной связности')

<div class="kos-container">

    <div class="theory">
        <h2>Теория</h2>
        
        <div class="theory-block">
            <p><strong>Ориентированный граф</strong> — это граф, в котором каждое ребро имеет направление. Ребро из вершины u в вершину v обозначается как u → v.</p>
            
            <p><strong>Компонента сильной связности</strong> — это максимальное множество вершин, в котором для любой пары вершин u и v существуют пути из u в v и из v в u.</p>
            
            <p><strong>Транспонированный граф</strong> — это граф, полученный из исходного разворотом всех рёбер. Если в исходном графе есть ребро u → v, то в транспонированном появляется ребро v → u.</p>
        </div>
        
        <h3>Алгоритм Косарайю</h3>
        <p>
            Алгоритм находит компоненты сильной связности за два обхода в глубину (DFS):
            <br><br>
            <strong>Первый проход (DFS1):</strong> Выполняется обход исходного графа. После обработки всех потомков вершина помещается в стек.
            <br><br>
            <strong>Второй проход (DFS2):</strong> Строится транспонированный граф. Вершины извлекаются из стека. Для каждой непосещённой вершины запускается обход на транспонированном графе. Все вершины, достижимые в этом обходе, образуют одну компоненту.
        </p>

        <h3>Пошаговый алгоритм решения</h3>
        <ul class="theory-list">
            <li><strong>Построение матрицы смежности G:</strong> Создаётся матрица G размера N×N, где G[u][v] = 1, если есть ребро из u в v, и 0 — в противном случае.</li>
            <li><strong>Построение транспонированной матрицы GT:</strong> Для всех i, j от 1 до n выполняется GT[j][i] = G[i][j].</li>
            <li><strong>Первый обход DFS1:</strong> Для каждой вершины v, если она не посещена, запускается DFS1(v). После обработки всех u вершина v помещается в стек.</li>
            <li><strong>Второй обход DFS2:</strong> Пока стек не пуст, из него извлекается вершина v. Для каждой непосещённой v запускается DFS2(v) на транспонированном графе. Найденные вершины образуют компоненту.</li>
            <li><strong>Вывод результата:</strong> Выводится количество компонент и список вершин для каждой компоненты.</li>
        </ul>

        <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
    </div>

    <div class="example">
    <h2>Пример</h2>
    <div class="example-flex">
        <div class="example-text">
            <div class="example-tree">
                <strong>Вершины:</strong> 0, 1, 2, 3, 4<br>
                <strong>Рёбра:</strong><br>
                0 → 4<br>
                4 → 0<br>
                1 → 3<br>
                3 → 2<br>
                2 → 1<br>
                <strong>Результат → Компоненты сильной связности:</strong><br>
                Компонента 1: 0, 4<br>
                Компонента 2: 1, 2, 3
            </div>
        </div>
        <div class="example-image">
            <img src="/static/images/KOS.png" alt="Пример графа">
        </div>
    </div>
</div>

    <div class="form-card" id="inputForm">
        <h2>Ввод данных графа</h2>

        <div class="file-buttons">
            <button class="btn-file" onclick="saveToJSON()">Сохранить в JSON</button>
            <label class="btn-file" style="cursor: pointer;">Загрузить из JSON
                <input type="file" id="jsonFileInput" accept=".json" style="display: none;" onchange="loadFromJSON(event)">
            </label>
        </div>

        <form action="/kos/solve" method="post" id="mainForm">
            <div class="form-row-flex">
                <div class="form-group half">
                    <label>Количество вершин (N ≤ 50)</label>
                    <input type="number" name="n" id="inputN" value="6" min="1" max="50" required>
                </div>
            </div>

            <div class="form-group">
                <label>Матрица смежности G</label>
                <div class="edges-container">
                    <div class="matrix-wrapper" id="matrixContainer"></div>
                </div>
                <span class="small-text">Введите матрицу размера N×N. 1 — есть ребро из i в j, 0 — нет ребра.</span>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-solve">НАЙТИ КОМПОНЕНТЫ</button>
                <button type="button" class="btn-reset" id="btnClear">Очистить</button>
            </div>
        </form>
        <button class="btn-generate" id="btnLoadExample">Загрузить пример</button>
    </div>

    <div class="result-card">
        <h2>Результат расчёта</h2>

        <div class="result-placeholder">
            <p>Введите матрицу смежности выше, затем нажмите «НАЙТИ КОМПОНЕНТЫ» для запуска вычислений.</p>
        </div>
    </div>

    <div class="nav-links">
        <a href="/" class="nav-btn">Домой</a>
        <button onclick="window.print();" class="nav-btn">Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">Назад</a>
    </div>
</div>

<script>
    let currentN = 6;
    const matrixContainer = document.getElementById('matrixContainer');
    const inputN = document.getElementById('inputN');
    const btnClear = document.getElementById('btnClear');
    const btnLoadExample = document.getElementById('btnLoadExample');

    function buildMatrixTable(n, matrixData = null) {
        let html = '<table class="matrix-table">';
        html += '<thead><tr><th>→</th>';
        for (let j = 1; j <= n; j++) {
            html += `<th>${j}</th>`;
        }
        html += '</thead><tbody>';
        
        for (let i = 1; i <= n; i++) {
            html += `<tr><td class="matrix-label">${i}</td>`;
            for (let j = 1; j <= n; j++) {
                let value = 0;
                if (matrixData && matrixData[i-1] && matrixData[i-1][j-1] !== undefined) {
                    value = matrixData[i-1][j-1];
                }
                const isDiag = (i === j);
                html += `<td><input type="text" class="matrix-cell" data-row="${i-1}" data-col="${j-1}" value="${value}" ${isDiag ? 'disabled' : ''}></td>`;
            }
            html += '</tr>';
        }
        html += '</tbody></table>';
        matrixContainer.innerHTML = html;
        
        document.querySelectorAll('.matrix-cell:not([disabled])').forEach(cell => {
            cell.addEventListener('change', function() {
                let val = this.value.trim();
                this.value = (val === '1') ? '1' : '0';
            });
        });
    }

    function getMatrixFromTable() {
        const n = parseInt(inputN.value);
        const matrix = Array(n).fill().map(() => Array(n).fill(0));
        document.querySelectorAll('.matrix-cell').forEach(cell => {
            if (!cell.disabled) {
                const row = parseInt(cell.dataset.row);
                const col = parseInt(cell.dataset.col);
                matrix[row][col] = parseInt(cell.value) || 0;
            }
        });
        return matrix;
    }

    function updateMatrixSize() {
        const newN = parseInt(inputN.value);
        if (isNaN(newN) || newN < 1 || newN > 50) {
            alert('Количество вершин должно быть от 1 до 50');
            inputN.value = currentN;
            return;
        }
        currentN = newN;
        buildMatrixTable(currentN);
    }

    function clearMatrix() {
        document.querySelectorAll('.matrix-cell:not([disabled])').forEach(cell => {
            cell.value = '0';
        });
    }

    function loadExample() {
        inputN.value = '6';
        currentN = 6;
        const exampleMatrix = [
            [0, 1, 0, 0, 0, 0],
            [0, 0, 1, 1, 0, 0],
            [1, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0, 0]
        ];
        buildMatrixTable(6, exampleMatrix);
    }

    function saveToJSON() {
        const n = parseInt(inputN.value);
        const matrix = getMatrixFromTable();
        const data = { n: n, matrix: matrix };
        const jsonStr = JSON.stringify(data, null, 2);
        const blob = new Blob([jsonStr], {type: 'application/json'});
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'kosaraju_graph.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        alert('Данные сохранены в JSON');
    }

    function loadFromJSON(event) {
        const file = event.target.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = function(e) {
            try {
                const data = JSON.parse(e.target.result);
                if (data.n) {
                    inputN.value = data.n;
                    currentN = data.n;
                }
                if (data.matrix && Array.isArray(data.matrix)) {
                    buildMatrixTable(data.n || data.matrix.length, data.matrix);
                }
                alert('Данные загружены из JSON');
            } catch (error) {
                alert('Ошибка при загрузке JSON: ' + error.message);
            }
        };
        reader.readAsText(file);
        event.target.value = '';
    }

    inputN.addEventListener('change', updateMatrixSize);
    btnClear.addEventListener('click', clearMatrix);
    btnLoadExample.addEventListener('click', loadExample);
    
    buildMatrixTable(6);
</script>