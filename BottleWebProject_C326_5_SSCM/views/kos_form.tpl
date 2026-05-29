% rebase('layout.tpl', title='Компоненты сильной связности')

<div class="task-hero">
    <h1>Компоненты сильной связности</h1>
    <p class="task-subtitle">Разбиение ориентированного графа на компоненты с использованием алгоритма Косарайю</p>
</div>

<div class="task-container">
    
    <!-- Блок 1: Условие задачи -->
    <div class="task-section">
        <h2>Условие задачи</h2>
        <div class="task-description">
            <p>Дан <strong>ориентированный граф</strong> с <strong>N</strong> вершинами и <strong>M</strong> рёбрами (N ≤ 50).</p>
            <p>Требуется <strong>разбить граф на компоненты сильной связности</strong> — группы вершин, в которых из любой вершины можно достичь любую другую, двигаясь по направлению рёбер.</p>
        </div>
        
        <div class="task-details">
            <div class="detail-item">
                <div>
                    <h4>Формат ввода</h4>
                    <p>Количество вершин и список рёбер (u → v).</p>
                </div>
            </div>
            <div class="detail-item">
                <div>
                    <h4>Алгоритм</h4>
                    <p>Алгоритм Косарайю: первый обход DFS для заполнения стека, второй обход на транспонированном графе.</p>
                </div>
            </div>
            <div class="detail-item">
                <div>
                    <h4>Формат вывода</h4>
                    <p>Количество компонент и список вершин для каждой компоненты.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Блок 2: Теоретическая информация -->
    <div class="task-section">
        <h2>Теоретическая информация</h2>
        
        <div class="theory-block">
            <h3>Компонента сильной связности</h3>
            <p>Компонента сильной связности — это максимальное множество вершин, в котором для любой пары вершин u и v существуют пути из u в v и из v в u.</p>
            
            <h3>Алгоритм Косарайю</h3>
            <p>Алгоритм состоит из двух этапов:</p>
            <ul class="theory-list">
                <li><strong>Первый проход (DFS1):</strong> Обход графа в глубину. После обработки всех потомков вершина помещается в стек. Стек содержит вершины в порядке завершения их обработки.</li>
                <li><strong>Второй проход (DFS2):</strong> Обход транспонированного графа (с развёрнутыми рёбрами) в порядке извлечения вершин из стека. Каждый запуск обхода выделяет одну компоненту сильной связности.</li>
            </ul>
            
            <h3>Транспонированный граф</h3>
            <p>Граф, в котором все рёбра развёрнуты. Если в исходном графе есть ребро u→v, то в транспонированном — v→u.</p>
        </div>
    </div>

    <!-- Блок 3: Ввод данных -->
    <div class="task-section" id="inputForm">
        <h2>Ввод данных</h2>
        
        <div class="input-block">
            <div class="input-header">
                <h3>Количество вершин</h3>
                <p class="input-hint">Введите количество вершин (от 1 до 50)</p>
            </div>
            <div class="input-row">
                <label class="input-label" for="vertex-count">N =</label>
                <input type="number" id="vertex-count" class="input-field input-small" min="1" max="50" value="6">
            </div>
        </div>

        <div class="input-block">
            <div class="input-header">
                <h3>Рёбра графа</h3>
                <p class="input-hint">Формат: начальная вершина → конечная вершина</p>
            </div>
            
            <div class="edges-container">
                <div id="edges-list" class="edges-list">
                    <div class="edge-row">
                        <input type="number" class="edge-from" placeholder="От" min="1" value="1">
                        <span>→</span>
                        <input type="number" class="edge-to" placeholder="До" min="1" value="2">
                        <button class="btn-remove-edge" disabled>✕</button>
                    </div>
                </div>
                <button id="add-edge" class="btn-add-edge">+ Добавить ребро</button>
            </div>
        </div>

        <div class="file-row">
            <button type="button" id="btn-generate" class="btn-file">Случайный граф</button>
            <label class="btn-file" style="cursor: pointer;">Загрузить из JSON
                <input type="file" id="file-input" accept=".json" style="display: none;">
            </label>
        </div>

        <div class="button-block">
            <button id="btn-solve" class="btn-solve">Решить задачу</button>
            <button id="btn-clear" class="btn-clear">Очистить</button>
        </div>
    </div>

    <!-- Блок 4: Сообщение -->
    <div class="task-section" id="message-section" style="display: none;">
        <div class="message-block error" id="error-message">
            <span id="error-text">Ошибка</span>
            <button class="btn-close-message" onclick="closeMessage()">✕</button>
        </div>
        <div class="message-block success" id="success-message" style="display: none;">
            <span id="success-text">Успешно</span>
            <button class="btn-close-message" onclick="closeMessage()">✕</button>
        </div>
    </div>

    <!-- Блок 5: Результат -->
    <div class="task-section">
        <h2>Результат</h2>
        
        <div class="result-block">
            <div id="result-content" class="result-placeholder">
                <p>Здесь появится результат после нажатия кнопки «Решить задачу»</p>
            </div>
            <button id="btn-save-result" class="btn-save" style="display: none;">Сохранить результат</button>
        </div>
    </div>

    <!-- Блок 6: Пример работы -->
    <div class="task-section">
        <h2>Пример работы</h2>
        
        <div class="example-block">
            <h4>Входные данные:</h4>
            <div class="example-matrix">
                <pre>N = 6
Рёбра:
1 → 2
2 → 3
3 → 1
2 → 4
4 → 5
5 → 4
3 → 6</pre>
            </div>
            
            <div class="example-arrow">↓</div>
            
            <h4>Результат:</h4>
            <div class="example-result">
                <p><strong>Найдено компонент:</strong> 3</p>
                <p><strong>Компонента 1 (3 вершины):</strong> 1, 2, 3</p>
                <p><strong>Компонента 2 (2 вершины):</strong> 4, 5</p>
                <p><strong>Компонента 3 (1 вершина):</strong> 6</p>
            </div>
        </div>
    </div>
</div>

<script>
    // Элементы DOM
    const edgesContainer = document.getElementById('edges-list');
    const addEdgeBtn = document.getElementById('add-edge');
    const vertexCountInput = document.getElementById('vertex-count');
    const solveBtn = document.getElementById('btn-solve');
    const clearBtn = document.getElementById('btn-clear');
    const generateBtn = document.getElementById('btn-generate');
    const fileInput = document.getElementById('file-input');
    const saveResultBtn = document.getElementById('btn-save-result');
    const resultContent = document.getElementById('result-content');
    const messageSection = document.getElementById('message-section');
    const errorMessage = document.getElementById('error-message');
    const successMessage = document.getElementById('success-message');
    const errorText = document.getElementById('error-text');
    const successText = document.getElementById('success-text');

    let currentResult = null;

    // Добавление строки ребра
    function addEdgeRow(from = '', to = '') {
        const row = document.createElement('div');
        row.className = 'edge-row';
        row.innerHTML = `
            <input type="number" class="edge-from" placeholder="От" min="1" value="${from}">
            <span>→</span>
            <input type="number" class="edge-to" placeholder="До" min="1" value="${to}">
            <button class="btn-remove-edge">✕</button>
        `;
        edgesContainer.appendChild(row);
        updateRemoveButtons();
    }

    // Обновление кнопок удаления
    function updateRemoveButtons() {
        const rows = document.querySelectorAll('.edge-row');
        rows.forEach((row, index) => {
            const btn = row.querySelector('.btn-remove-edge');
            if (index === 0) {
                btn.disabled = true;
            } else {
                btn.disabled = false;
                btn.onclick = () => row.remove();
            }
        });
    }

    // Получение всех рёбер
    function getEdges() {
        const edges = [];
        const rows = document.querySelectorAll('.edge-row');
        for (const row of rows) {
            const from = parseInt(row.querySelector('.edge-from').value);
            const to = parseInt(row.querySelector('.edge-to').value);
            if (from && to && !isNaN(from) && !isNaN(to) && from !== to) {
                edges.push([from, to]);
            }
        }
        return edges;
    }

    // Установка рёбер
    function setEdges(edges) {
        while (edgesContainer.children.length > 1) {
            edgesContainer.removeChild(edgesContainer.lastChild);
        }
        if (edges.length > 0) {
            const firstRow = edgesContainer.children[0];
            firstRow.querySelector('.edge-from').value = edges[0][0];
            firstRow.querySelector('.edge-to').value = edges[0][1];
        }
        for (let i = 1; i < edges.length; i++) {
            addEdgeRow(edges[i][0], edges[i][1]);
        }
    }

    // Показать сообщение
    function showMessage(type, text) {
        messageSection.style.display = 'block';
        if (type === 'error') {
            errorMessage.style.display = 'flex';
            successMessage.style.display = 'none';
            errorText.textContent = text;
        } else {
            errorMessage.style.display = 'none';
            successMessage.style.display = 'flex';
            successText.textContent = text;
        }
        setTimeout(() => {
            messageSection.style.display = 'none';
        }, 4000);
    }

    function closeMessage() {
        messageSection.style.display = 'none';
    }

    // Генерация случайного графа
    generateBtn.onclick = async () => {
        const n = parseInt(vertexCountInput.value);
        if (isNaN(n) || n < 1 || n > 50) {
            showMessage('error', 'Введите корректное количество вершин (1-50)');
            return;
        }
        
        try {
            const response = await fetch('/api/kos/generate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ n: n })
            });
            const data = await response.json();
            if (data.error) {
                showMessage('error', data.error);
            } else {
                setEdges(data.edges);
                showMessage('success', 'Сгенерирован случайный граф');
            }
        } catch(e) {
            showMessage('error', 'Ошибка генерации');
        }
    };

    // Загрузка из файла
    fileInput.onchange = async (e) => {
        const file = e.target.files[0];
        if (!file) return;
        
        const formData = new FormData();
        formData.append('file', file);
        
        try {
            const response = await fetch('/api/kos/upload', {
                method: 'POST',
                body: formData
            });
            const data = await response.json();
            if (data.error) {
                showMessage('error', data.error);
            } else {
                vertexCountInput.value = data.n;
                setEdges(data.edges);
                showMessage('success', 'Данные загружены');
            }
        } catch(e) {
            showMessage('error', 'Ошибка загрузки файла');
        }
        fileInput.value = '';
    };

    // Очистка формы
    clearBtn.onclick = () => {
        vertexCountInput.value = '6';
        while (edgesContainer.children.length > 1) {
            edgesContainer.removeChild(edgesContainer.lastChild);
        }
        const firstRow = edgesContainer.children[0];
        firstRow.querySelector('.edge-from').value = '1';
        firstRow.querySelector('.edge-to').value = '2';
        resultContent.innerHTML = `
            <p>Здесь появится результат»</p>
        `;
        saveResultBtn.style.display = 'none';
        currentResult = null;
        showMessage('success', 'Форма очищена');
    };

    // Решение задачи (алгоритм Косарайю)
    solveBtn.onclick = async () => {
        const n = parseInt(vertexCountInput.value);
        const edges = getEdges();
        
        if (isNaN(n) || n < 1 || n > 50) {
            showMessage('error', 'Введите корректное количество вершин (1-50)');
            return;
        }
        
        if (edges.length === 0) {
            showMessage('error', 'Добавьте хотя бы одно ребро');
            return;
        }
        
        
        try {
            const response = await fetch('/api/kos/solve', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ n: n, edges: edges })
            });
            const data = await response.json();
            
            if (data.error) {
                resultContent.innerHTML = `
                    <span class="result-icon">❌</span>
                    <p>Ошибка: ${data.error}</p>
                `;
                showMessage('error', data.error);
            } else {
                let componentsHtml = '';
                data.components.forEach((comp, idx) => {
                    const size = comp.length;
                    const vertexList = comp.sort((a,b) => a-b).join(', ');
                    componentsHtml += `<p><strong>Компонента ${idx + 1} (${size} вершины):</strong> ${vertexList}</p>`;
                });
                
                resultContent.innerHTML = `
                    <div class="result-success">
                        <p><strong>Найдено компонент сильной связности: ${data.count}</strong></p>
                        ${componentsHtml}
                    </div>
                `;
                currentResult = data;
                saveResultBtn.style.display = 'inline-block';
                showMessage('success', 'Задача решена');
            }
        } catch(e) {
            resultContent.innerHTML = `
                <span class="result-icon">❌</span>
                <p>Ошибка сервера</p>
            `;
            showMessage('error', 'Ошибка сервера');
        }
    };

    // Сохранение результата
    saveResultBtn.onclick = async () => {
        if (!currentResult) return;
        
        try {
            const response = await fetch('/api/kos/save', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(currentResult)
            });
            const data = await response.json();
            if (data.error) {
                showMessage('error', data.error);
            } else {
                showMessage('success', 'Результат сохранён');
            }
        } catch(e) {
            showMessage('error', 'Ошибка сохранения');
        }
    };

    // Добавление ребра
    addEdgeBtn.onclick = () => addEdgeRow();
    
    // Инициализация
    updateRemoveButtons();
</script>