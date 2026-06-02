% # vertex_cover.tpl - Минимальное вершинное покрытие в двудольном графе
% rebase('layout.tpl', title='Минимальное вершинное покрытие')

<script src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>

<div class="container">

    <div class="theory">
        <div class="theory-header">
            <h2>📖 Теория метода и основные определения</h2>
            <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
        </div>

        <div class="theory-block">
            <p><strong>Двудольный граф</strong> — это граф, множество вершин которого можно разбить на две доли L (левая) и R (правая) так, что любое ребро графа соединяет вершину из левой доли с вершиной из правой доли. Внутри одной доли рёбер нет.</p>
            <p><strong>Вершинное покрытие</strong> — это подмножество вершин графа, такое, что для каждого ребра графа хотя бы один из его концов входит в это подмножество. Ребро считается <em>покрытым</em>, если покрыта хотя бы одна его оконечная вершина.</p>
            <p><strong>Минимальное вершинное покрытие</strong> — это вершинное покрытие, содержащее <em>наименьшее возможное</em> количество вершин для данного графа.</p>
            <p><strong>Паросочетание</strong> — это набор попарно несмежных рёбер графа (никакие два ребра из набора не имеют общих вершин). Паросочетание называется <strong>максимальным</strong>, если оно содержит максимально возможное число рёбер.</p>
        </div>

        <h3>💡 Теорема Кёнига</h3>
        <div class="theory-block konig-theorem">
            <p>В любом конечном <strong>двудольном графе</strong> размер минимального вершинного покрытия равен размеру максимального паросочетания:</p>
            <span class="konig-formula">|Min Vertex Cover| = |Max Matching|</span>
            <p>Благодаря этой теореме задача поиска покрытия сводится к поиску максимального паросочетания, которая эффективно решается алгоритмом Куна.</p>
        </div>

        <h3>🎛️ Пошаговый алгоритм решения</h3>
        <ol class="theory-list">
            <li><strong>Поиск максимального паросочетания (Алгоритм Куна):</strong>
                <ul>
                    <li>Изначально паросочетание пустое.</li>
                    <li>Перебираем вершины левой доли L. Для каждой вершины пытаемся найти <em>увеличивающую цепь</em> при помощи обхода в глубину (DFS).</li>
                    <li>Если цепь найдена, выполняем инверсию путей. Размер паросочетания увеличивается на 1.</li>
                </ul>
            </li>
            <li><strong>Запуск разметки (DFS для построения покрытия):</strong>
                <ul>
                    <li>Запускаем DFS из всех вершин левой доли L, которые <strong>не включены</strong> в максимальное паросочетание.</li>
                    <li>DFS перемещается из L в R только по не принадлежащим паросочетанию рёбрам, а из R в L — только по рёбрам из паросочетания.</li>
                </ul>
            </li>
            <li><strong>Выбор вершин в минимальное покрытие:</strong>
                <ul>
                    <li>Из левой доли L берём вершины, которые <strong>НЕ были посещены</strong> в ходе DFS.</li>
                    <li>Из правой доли R берём вершины, которые <strong>БЫЛИ посещены</strong> в ходе DFS.</li>
                </ul>
            </li>
        </ol>

        <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
    </div>

    <div class="example">
        <div class="example-tree">
            <div>
                <h2>Пример двудольного графа</h2>
                <p class="example-info"><strong>Доли графа:</strong> Левая (L: 1, 2, 3, 4, 5) → Правая (R: 6, 7, 8, 9)</p>
                <p class="example-label"><strong>Список связей (Рёбра):</strong></p>
                <div class="edges-grid">
                    <div>• 1 — 6</div> <div>• 5 — 6</div>
                    <div>• 2 — 6</div> <div>• 3 — 9</div>
                    <div>• 2 — 7</div> <div>• 5 — 9</div>
                    <div>• 4 — 7</div> <div>• 3 — 8</div>
                </div>
            </div>
            <div class="example-result">
                <p><strong>Результат поиска покрытия:</strong></p>
                <p>Вершины <span class="highlight">[3, 6, 7, 9]</span> (Размер: 4, полностью изолируют все рёбра).</p>
            </div>
        </div>

        <div class="theory-image">
            <img src="/static/images/dvydoli.png" alt="Пример вершинного покрытия">
            <p class="image-caption">
                Минимальное покрытие составляют вершины <strong>3</strong> (осталась не посещена при DFS разметке) и <strong>6, 7, 9</strong> (посещены алгоритмом при обходе).
            </p>
        </div>
    </div>

    <div class="form-card" id="inputForm">
        <h2>Ввод данных графа</h2>

        <div class="file-buttons">
            <button type="button" class="btn-file" onclick="exportGraphToJSON()">💾 Сохранить в JSON</button>
            <label class="btn-file btn-file-upload">
                📂 Загрузить из JSON
                <input type="file" id="jsonFileInput" accept=".json" class="file-input" onchange="importGraphFromJSON(event)">
            </label>
        </div>

        <form action="/vertex_cover/solve" method="post" id="graphForm">
            <input type="hidden" name="edges" id="edgesInput" value="{{edges or ''}}">

            <div class="form-row">
                <div class="form-group half">
                    <label for="inputNLeft">Вершин в левой доле (L)</label>
                    <input type="number" name="n_left" id="inputNLeft" value="{{n_left or '5'}}" min="1" max="100" required>
                    <div id="errorNLeft" class="error-msg-inline" style="display:none;"></div>
                </div>
                <div class="form-group half">
                    <label for="inputNRight">Вершин в правой доле (R)</label>
                    <input type="number" name="n_right" id="inputNRight" value="{{n_right or '4'}}" min="1" max="100" required>
                    <div id="errorNRight" class="error-msg-inline" style="display:none;"></div>
                </div>
            </div>

            <div class="form-group">
                <label>Список рёбер графа (Таблица связей)</label>
                <div class="edges-container">
                    <div class="edges-list" id="edgesTableBody">
                        <div class="edge-row">
                            <span class="matrix-label">L:</span>
                            <input type="number" class="edge-from" placeholder="Доля L" value="1" min="1" required>
                            <span class="example-arrow">→</span>
                            <span class="matrix-label">R:</span>
                            <input type="number" class="edge-to" placeholder="Доля R" value="6" min="1" required>
                            <button type="button" class="action-btn-danger" onclick="this.parentElement.remove();">❌</button>
                        </div>
                    </div>
                </div>
                <div class="edges-footer">
                    <button type="button" class="btn-add-edge" onclick="addNewEdgeRow('', '')">➕ Добавить ребро</button>
                    <span class="small-text">Указывайте пары вершин: из левой доли (L) и соединённую с ней из правой (R).</span>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-solve">Найти минимальное покрытие</button>
                <button type="button" class="btn-reset" onclick="clearAllEdges()">Очистить</button>
            </div>
        </form>

        <div class="form-footer">
            <button type="button" class="btn-generate" onclick="loadDemoGraph()">Загрузить пример</button>
        </div>
    </div>

    <div class="result-card">
        <h2>📊 Результат расчета</h2>

        <div id="results-block" class="results-section" style="display: none;">
            <div class="result-box">
                <div class="max-value" id="cover-size-output">0</div>
                <div class="result-description">
                    размер минимального вершинного покрытия (согласно теореме Кёнига равен мощности макс. паросочетания = <span id="matching-size-output">0</span>)
                </div>

                <div><strong>Вершины, входящие в покрытие:</strong></div>
                <div class="selected-list" id="cover-vertices-output"></div>

                <div class="result-info">
                    <strong>ℹ Теорема Кёнига подтверждена:</strong> Выбранный набор вершин является оптимальным (минимально возможным) и полностью блокирует абсолютно все рёбра.
                </div>
            </div>

            <div class="results-section">
                <h3>🔮 Интерактивная визуализация итогового графа</h3>
                <p class="graph-hint">
                    Вершины можно перемещать мышкой. <span class="legend-left">Синие</span> — левая доля L, <span class="legend-right">Жёлтые</span> — правая доля R.
                    Вершины минимального покрытия выделены жирной <span class="legend-cover">красной обводкой</span>.
                </p>
                <div id="network-graph" class="network-graph-box"></div>
            </div>

            <div class="results-section">
                <h3>📜 Максимальное паросочетание (Пошаговый протокол)</h3>
                <div class="tree-container">
                    <pre id="logs-output"></pre>
                </div>
            </div>
        </div>

        <div class="result-placeholder" id="result-placeholder">
            <span class="result-icon">🕸️</span>
            <p>Введите структуру долей и рёбер графа выше, затем нажмите «Найти минимальное покрытие» для запуска вычислений.</p>
        </div>
    </div>

    <div class="nav-links">
        <a href="/" class="nav-btn">🏠 Домой</a>
        <button type="button" onclick="window.print();" class="nav-btn">🖨️ Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">⬅️ Назад</a>
    </div>
</div>

<div id="serverEdgesData" data-edges="{{edges or ''}}" data-cover="{{cover_vertices or ''}}" class="server-data"></div>

<script src="/static/scripts/vertex_cover.js"></script>