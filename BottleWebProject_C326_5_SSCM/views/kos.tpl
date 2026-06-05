% rebase('layout.tpl', title='Компоненты сильной связности')
% import json
<!-- Подключение библиотеки vis-network для визуализации графов -->
<script src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>

<div class="kos-container">

    <!-- Секция с теорией -->
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

        <!-- Ссылка для перехода к форме ввода -->
        <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
    </div>

    <!-- Секция с примером -->
    <div class="example">
        <div class="example-tree">
            <div>
                <h2>Пример</h2>
                <strong>Вершины:</strong> 0, 1, 2, 3, 4<br>
                <strong>Рёбра:</strong><br>
                1 → 0<br>
                1 → 3<br>
                2 → 1<br>
                3 → 2<br>
                3 → 4<br>
                4 → 0<br>
                <strong>Результат → Компоненты сильной связности:</strong><br>
                Компонента 1: 0<br>
                Компонента 2: 4<br>
                Компонента 3: 1, 2, 3
            </div>
        </div>
        <!-- Изображение примера графа -->
        <div class="theory-image">
            <img src="/static/images/KOS.png" alt="Пример графа">
        </div>
    </div>

    <!-- Карточка с формой ввода данных -->
    <div class="form-card" id="inputForm">
        <h2>Ввод данных графа</h2>

        <!-- Кнопки для работы с JSON файлами -->
        <div class="file-buttons">
            <button class="btn-file" onclick="saveToJSON()">Сохранить в JSON</button>
            <label class="btn-file btn-file-upload">
                Загрузить из JSON
                <input type="file" id="jsonFileInput" accept=".json" class="file-input" onchange="loadFromJSON(event)">
            </label>
        </div>

        <form action="/kos/decision" method="post" id="mainForm">
            <input type="hidden" name="G" id="hiddenG">
            
            <div class="form-row-flex">
                <div class="form-group half">
                    <label>Количество вершин (N ≤ 14)</label>
                    <input type="number" name="n" id="inputN" value="{{n if n else ''}}" min="1" max="14" required>
                </div>
            </div>

            <div class="form-group">
                <label>Матрица смежности G</label>
                <div class="matrix-wrapper">
                    <div class="matrix-table" id="matrixContainer"></div>
                </div>
                <span class="small-text">Введите матрицу размера N×N. 1 — есть ребро из u в v, 0 — нет ребра.</span>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-solve">Найти компоненты</button>
                <button type="button" class="btn-reset" id="btnClear">Очистить</button>
            </div>
        </form>
        <button class="btn-generate" id="btnLoadExample">Случайные значения</button>
    </div>
    

    <!-- Карточка с результатами вычислений -->
<div class="result-card">
    <h2>Результат расчёта</h2>

    % if result:
        <!-- Блок с количеством компонент -->
        <div class="result-success">
            <p><strong>Найдено компонент сильной связности: {{count}}</strong></p>
        </div>

        <!-- Легенда с цветами -->
        % if components:
            <div class="result-success">
                % colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7', '#DDA0DD']
                % color_names = ['красный', 'бирюзовый', 'синий', 'зелёный', 'жёлтый', 'фиолетовый']

                % for idx, component in enumerate(components):
                    <div class="legend-item">
                        <span class="legend-color" style="background-color: {{colors[idx % len(colors)]}};"></span>
                        <span>
                            Компонента {{idx + 1}} ({{color_names[idx % len(color_names)]}}) — вершины: {{', '.join(map(str, component))}}
                        </span>
                    </div>
                % end
            </div>
        % end

        <!-- Визуализация графа -->
        <div class="graph-visualization">
            <h3>Интерактивная визуализация графа</h3>
            <div id="kos-graph" style="height: 500px; border: 1px solid var(--accent); background: #FAF7F0; border-radius: 12px;"></div>
        </div>

        <!-- Письменное решение -->
        <div class="result-success">
            <h3>Письменное решение</h3>
            <pre>{{solution_text}}</pre>
        </div>

    % elif error:
        <div class="error-msg">
            <strong>Ошибка:</strong> {{error}}
        </div>

    % else:
        <div class="result-placeholder">
            <p>Введите матрицу смежности выше, затем нажмите «Найти компоненты» для запуска вычислений.</p>
        </div>
    % end
</div>

    <div class="nav-links">
        <a href="/" class="nav-btn">Домой</a>
        <button onclick="window.print();" class="nav-btn">Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">Назад</a>
    </div>
</div>








<script>
    // Переменная для хранения текущего размера матрицы 
    let currentN = {{n if n else 'null'}};
    // Контейнер для матрицы
    const matrixContainer = document.getElementById('matrixContainer');
    // Поле ввода размера
    const inputN = document.getElementById('inputN');
    // Кнопка очистки
    const btnClear = document.getElementById('btnClear');
    // Кнопка загрузки примера
    const btnLoadExample = document.getElementById('btnLoadExample');

    function buildMatrixTable(n, matrixData = null) {
        //Создание таблицы
        let html = '<table class="matrix-table">';
        //Заоловок таблицы с номерами столбцов
        html += '<thead><tr><th></th>';
        for (let j = 1; j <= n; j++) {
            //Добавление номера столбца
            html += `<th>${j}</th>`;
        }
        html += '</thead><tbody>';
        
        //Создание строк матрицы
        for (let i = 1; i <= n; i++) {
            html += `<tr><td class="matrix-label">${i}</td>`;
            for (let j = 1; j <= n; j++) {
            //Значение по умолчанию    
            let value = 0;
                //Использование данных матрицы при их наличии
                if (matrixData && matrixData[i-1] && matrixData[i-1][j-1] !== undefined) {
                    value = matrixData[i-1][j-1];
                }
                //Проверка на диагональный элемент
                const isDiag = (i === j);
                //Создание ячейки с полем ввода (без диагонали)
                html += `<td><input type="text" class="matrix-cell" data-row="${i-1}" data-col="${j-1}" value="${value}" maxlength="1"${isDiag ? 'disabled' : ''}></td>`;
            }
            html += '</tr>';
        }
        html += '</tbody></table>';
        matrixContainer.innerHTML = html;
        
    }

    //Получение матрицы из таблицы
    function getMatrixFromTable() {
        //Получение размера матрицы
        const n = parseInt(inputN.value);
        //Создание нулевой матрицы
        const matrix = Array(n).fill().map(() => Array(n).fill(0));
        //Заполнение матрицы значениями из полей ввода
        document.querySelectorAll('.matrix-cell').forEach(cell => {
            //Пропуск диагональных ячеек
            if (!cell.disabled) {
                //Получение индекса строки
                const row = parseInt(cell.dataset.row);
                //Получчение индекса столбца
                const col = parseInt(cell.dataset.col);
                //Установка значения
                if (!matrix[row]) matrix[row] = [];
                matrix[row][col] = cell.value; 
            }
        });
        return matrix;
    }

    //Обновление матрицы при изменении количества вершин
    function updateMatrixSize() {
        const newN = parseInt(inputN.value);
        //Проверка на размер
        if (isNaN(newN) || newN < 1 || newN > 14) {
            alert('Количество вершин должно быть от 1 до 14');
            inputN.value = currentN;
            return;
        }
        //Обновление текущего размера
        currentN = newN;
        //Перестройка таблицы
        buildMatrixTable(currentN);
    }

    //Очистка матрицы
    function clearMatrix() {
        document.querySelectorAll('.matrix-cell:not([disabled])').forEach(cell => {
            //Установка 0 во все чейки
            cell.value = '0';
        });
    }
    //Загрузка случайного примера матрицы
    function loadExample() {
        //ПОлучение размера
    const n = parseInt(inputN.value);
    if (isNaN(n) || n < 1 || n > 14) {
        alert('Сначала введите корректное количество вершин (1-14)');
        return;
    }
    
    // Генерация случайной матрицы
    const randomMatrix = [];
    for (let i = 0; i < n; i++) {
        const row = [];
        for (let j = 0; j < n; j++) {
            if (i === j) {
                //Диагональные эл 0
                row.push(0);
            } else {
                // Случайное значение 10% вероятность ребра
                row.push(Math.random() < 0.15 ? 1 : 0);
            }
        }
        randomMatrix.push(row);
    }
        buildMatrixTable(n, randomMatrix);
    }

   
    //Загрузка данных из файлы
    function loadFromJSON(event) {
        //Получение выбранного файла
        const file = event.target.files[0];
        if (!file) return;
        //Создание читателя файлов
        const reader = new FileReader();
        //Обработчик загрузки файла
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

    //Обработчик отправки формы
    document.getElementById('mainForm').addEventListener('submit', function() {
        //Получение матрицы
        const matrix = getMatrixFromTable();
        //Строка для хранения матрицы в текстовом виде
        let matrixText = '';
        //Преобразование матрицы в текст
        for (let i = 0; i < matrix.length; i++) {
            matrixText += matrix[i].join(' ') + '\n';
        }
        const hiddenG = document.getElementById('hiddenG');
        if (hiddenG) {
            hiddenG.value = matrixText;
        }
    });

    //При изменении n - матрица меняется
    inputN.addEventListener('change', updateMatrixSize);
    //Кнопка очистить - заполнение нулями 
    btnClear.addEventListener('click', clearMatrix);
    //Кнопка случайные значения - заполнение случайными значениями 
    btnLoadExample.addEventListener('click', loadExample);
    //Восстановление матрицы
    // Если сервер передал матрицу G
    % if G:
    // Если G — это строка (текст)
        % if isinstance(G, str):

            // Получение текста матрицы
            const gText = {{!json.dumps(G)}};
            // Разбиваем на строки
            const rows = gText.trim().split('\n');
            // Пустой массив для матрицы
            const restoredG = [];

            // Обработка каждой строки
            for (let u = 0; u < rows.length && u < {{n}}; u++) {
                // Разбиваем строку на числа
                const values = rows[u].trim().split(/\s+/);
                const row = [];
                 // Обработка каждого числа в строке
                for (let v = 0; v < values.length && v < {{n}}; v++) {
                    //Преобразование в число
                    let val = parseInt(values[v]);
                    if (isNaN(val)) val = 0;
                    row.push(val);
                }
                while (row.length < {{n}}) row.push(0);
                restoredG.push(row);
            }
            while (restoredG.length < {{n}}) {
                restoredG.push(Array({{n}}).fill(0));
            }
            buildMatrixTable({{n}}, restoredG);
        % else:
            buildMatrixTable({{n}}, {{!json.dumps(G)}});
        % end
    % else:

    % end

    let networkInstance = null;



    //Отрисока графа
    function drawDirectedGraph(G, n, components) {
        //Получение контейнера
        const container = document.getElementById('kos-graph');
        if (!container) return;

        //Массив узлов графа(вершины)
        const nodes = [];
        for (let v = 1; v <= n; v++) {
            // Цвет по умолчанию
            let color = '#CABFAB';
            // Если есть компоненты, определяем цвет по принадлежности к компоненте
            if (components) {
                for (let idx = 0; idx < components.length; idx++) {
                    if (components[idx].includes(v)) {
                        // Палитра цветов для разных компонент
                        const colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7', '#DDA0DD'];
                        // Выбираем цвет по индексу компоненты
                        color = colors[idx % colors.length];
                        break;
                    }
                }
            }
            // Добавление узла в массив
            nodes.push({
                id: v,
                label: String(v),
                color: { background: color, border: '#41444B' },
                font: { color: '#41444B', size: 16, face: 'monospace' }
            });
        }

        // Создае массива ребер графа
        const edges = [];
        for (let u = 0; u < n; u++) {        
            for (let v = 0; v < n; v++) {   
                if (G[u][v] === 1) {
                    edges.push({
                        from: u + 1,        
                        to: v + 1,
                        arrows: 'to',
                        color: { color: '#52575D' },
                        smooth: { type: 'curvedCW', roundness: 0.2 }
                    });
                }
            }
        }

        // Формирование данных
        const data = {
            // Набор узлов
            nodes: new vis.DataSet(nodes),
            // Набор ребер
            edges: new vis.DataSet(edges)
        };

        //Настройки визуализации графа
        const options = {
            physics: { enabled: true, stabilization: true },
            edges: { arrows: { to: { enabled: true } } },
            nodes: { shape: 'circle', size: 25 },
            layout: { improvedLayout: true }
        };

        if (networkInstance) {
            networkInstance.destroy();
        }
        networkInstance = new vis.Network(container, data, options);
    }

    // Если есть результат и матрица с сервера, отрисовываем граф
    % if result and G:
        // Получение матрицы с сервера
        const G_from_server = {{!G}};
        // Получение размера
        const n = {{n}};
        // Получение компонент
        const components_from_server = {{!components}};
        //Отрисовка графа
        drawDirectedGraph(G_from_server, n, components_from_server);
    % end


</script>