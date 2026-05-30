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
            <p>Дан <strong>ориентированный граф</strong> с <strong>N</strong> вершинами (N ≤ 50).</p>
            <p>Требуется <strong>разбить граф на компоненты сильной связности</strong> — группы вершин, в которых из любой вершины можно достичь любую другую, двигаясь по направлению рёбер.</p>
        </div>
        
        <div class="task-details">
            <div class="detail-item">
                <div>
                    <h4>Формат ввода</h4>
                    <p>Количество вершин N и матрица смежности G размера N×N (1 — есть ребро, 0 — нет ребра).</p>
                </div>
            </div>
            <div class="detail-item">
                <div>
                    <h4>Алгоритм</h4>
                    <p>Алгоритм Косарайю на матрице смежности.</p>
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
                <li><strong>Первый проход (DFS1):</strong> Для каждой вершины v (от 1 до n), если она не посещена, запускается обход. Для всех u от 1 до n проверяется G[v][u] = 1. Если ребро есть и u не посещён, рекурсивный вызов. После цикла v помещается в стек.</li>
                <li><strong>Второй проход (DFS2):</strong> Из стека извлекаются вершины. Для каждой непосещённой v запускается обход на транспонированной матрице GT (проверка GT[v][u] = 1). Найденные вершины образуют компоненту.</li>
            </ul>
            
            <h3>Транспонированная матрица</h3>
            <p>GT[v][u] = G[u][v] (матрица, транспонированная относительно главной диагонали).</p>
        </div>
    </div>

    <!-- Блок 3: Ввод данных -->
    <div class="task-section" id="inputForm">
        <h2>Ввод данных</h2>
        
        <form action="/kos/solve" method="post">
            <div class="input-block">
                <div class="input-header">
                    <h3>Количество вершин</h3>
                    <p class="input-hint">Введите количество вершин (от 1 до 50)</p>
                </div>
                <div class="input-row">
                    <label class="input-label" for="vertex-count">N =</label>
                    <input type="number" name="n" id="vertex-count" class="input-field input-small" min="1" max="50" value="6" required>
                </div>
            </div>

            <div class="input-block">
                <div class="input-header">
                    <h3>Матрица смежности G</h3>
                    <p class="input-hint">Введите матрицу N×N: 1 — есть ребро из i в j, 0 — нет ребра (числа через пробел, строки с новой строки)</p>
                </div>
                
                <div class="matrix-container">
                    <textarea name="matrix" class="matrix-textarea" rows="8" style="width:100%; padding:10px; font-family:monospace; border:2px solid #DFD8C8; border-radius:10px;">0 1 0 0 0 0
0 0 1 1 0 0
1 0 0 0 0 1
0 0 0 0 1 0
0 0 0 1 0 0
0 0 0 0 0 0</textarea>
                </div>
            </div>

            <div class="button-block">
                <button type="submit" class="btn-solve">Решить задачу</button>
                <button type="reset" class="btn-clear">Очистить</button>
            </div>
        </form>
    </div>

    <!-- Блок 4: Результат -->
    <div class="task-section">
        <h2>Результат</h2>
        
        <div class="result-block">
            <div class="result-placeholder" style="text-align:center; padding:40px; background:#FAF7F0; border-radius:12px; color:#888;">
                <p>Введите матрицу смежности и нажмите «Решить задачу»</p>
            </div>
        </div>
    </div>

    <!-- Блок 5: Пример работы -->
    <div class="task-section">
        <h2>Пример работы</h2>
        
        <div class="example-block">
            <h4>Входные данные (N = 6):</h4>
            <div class="example-matrix" style="background:#faf9f6; padding:15px; border-radius:12px;">
                <pre style="margin:0; font-family:monospace;">Матрица смежности G:
0 1 0 0 0 0
0 0 1 1 0 0
1 0 0 0 0 1
0 0 0 0 1 0
0 0 0 1 0 0
0 0 0 0 0 0</pre>
            </div>
            
            <div class="example-arrow" style="text-align:center; font-size:24px; margin:15px 0;">↓</div>
            
            <h4>Результат:</h4>
            <div class="example-result" style="background:#FFFFFF; padding:15px 20px; border-radius:8px; border-left:4px solid #8B7B60;">
                <p><strong>Найдено компонент:</strong> 3</p>
                <p><strong>Компонента 1 (3 вершины):</strong> 1, 2, 3</p>
                <p><strong>Компонента 2 (2 вершины):</strong> 4, 5</p>
                <p><strong>Компонента 3 (1 вершина):</strong> 6</p>
            </div>
        </div>
    </div>
</div>