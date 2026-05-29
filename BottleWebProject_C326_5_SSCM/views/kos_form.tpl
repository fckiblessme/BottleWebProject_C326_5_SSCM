% rebase('layout.tpl', title='Компоненты сильной связности')

<div class="container">
    <div class="header">
        <h1>Компоненты сильной связности</h1>
        <p>Разбиение ориентированного графа на компоненты с использованием алгоритма Косарайю</p>
    </div>
    
    <div class="task-section">
        <h2>Условие задачи</h2>
        <div class="task-description">
            <p>Дан <strong>ориентированный граф</strong> с <strong>N</strong> вершинами и <strong>M</strong> рёбрами (N ≤ 50).</p>
            <p>Требуется <strong>разбить граф на компоненты сильной связности</strong> — группы вершин, в которых из любой вершины можно достичь любую другую, двигаясь по направлению рёбер.</p>
        </div>
        
        <div class="task-details">
            <div class="detail-item">
                <h4>Формат ввода</h4>
                <p>Количество вершин и список рёбер (u → v).</p>
            </div>
            <div class="detail-item">
                <h4>Алгоритм</h4>
                <p>Алгоритм Косарайю: первый обход DFS для заполнения стека, второй обход на транспонированном графе.</p>
            </div>
            <div class="detail-item">
                <h4>Формат вывода</h4>
                <p>Количество компонент и список вершин для каждой компоненты.</p>
            </div>
        </div>
    </div>

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

    <div class="task-section" id="message-section" style="display: none;">
        <div class="message-block error" id="error-message" style="display: none;">
            <span class="message-icon">❌</span>
            <span id="error-text">Ошибка</span>
            <button class="btn-close-message" onclick="closeMessage()">✕</button>
        </div>
        <div class="message-block success" id="success-message" style="display: none;">
            <span class="message-icon">✓</span>
            <span id="success-text">Успешно</span>
            <button class="btn-close-message" onclick="closeMessage()">✕</button>
        </div>
    </div>

    <div class="task-section">
        <h2>Результат</h2>
        
        <div class="result-block">
            <div id="result-content" class="result-placeholder">
                <span class="result-icon">ℹ</span>
                <p>Здесь появится результат после нажатия кнопки «Решить задачу»</p>
            </div>
            <button id="btn-save-result" class="btn-save" style="display: none;">Сохранить результат</button>
        </div>
    </div>

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

    <div class="nav-links">
        <a href="/" class="nav-btn">Домой</a>
        <button onclick="window.print();" class="nav-btn">Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">Назад</a>
    </div>
</div>

<script src="/static/js/kosaraju.js"></script>