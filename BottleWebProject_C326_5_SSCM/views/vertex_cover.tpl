% # vertex_cover.tpl - Минимальное вершинное покрытие в двудольном графе
% rebase('layout.tpl', title='Минимальное вершинное покрытие')

<div class="container">
    <div class="header">
        <h1>Минимальное вершинное покрытие в двудольном графе</h1>
        <p>Теорема Кёнига | Алгоритм Куна для поиска паросочетаний</p>
    </div>

    <div class="theory">
        <h2>Теория метода</h2>
        <p><strong>Суть задачи:</strong> Найти минимальное множество вершин графа такое, чтобы каждое ребро имело хотя бы один конец (было инцидентно) в этом множестве.</p>
        
        <h3>Важные факты и алгоритм</h3>
        <ul>
            <li><strong>Теорема Кёнига:</strong> В любом двудольном графе размер минимального вершинного покрытия равен размеру максимального паросочетания.</li>
            <li><strong>Алгоритм Куна:</strong> Используется для поиска максимального паросочетания путем нахождения увеличивающих цепей в двудольном графе.</li>
            <li><strong>Построение покрытия:</strong> После поиска паросочетания запускается специальный обход в глубину (DFS) из не покрытых паросочетанием вершин левой доли для чередования путей. Вершины покрытия выбираются как <em>не посещенные</em> в левой доле и <em>посещенные</em> в правой доле.</li>
        </ul>
 
        <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
    </div>

    <div class="example">
        <h2>Пример двудольного графа</h2>
        <div class="example-tree">
            <strong>Доли графа:</strong> Левая (L: 1, 2, 3) → Правая (R: 4, 5)<br>
            <strong>Рёбра:</strong><br>
            1 — 4<br>
            1 — 5<br>
            2 — 4<br>
            3 — 5<br>
            <strong>Результат → Минимальное покрытие:</strong> Вершины [4, 5] (Размер: 2, покрывают все рёбра).
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

        <form action="/vertex_cover/solve" method="post" id="mainForm">
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <div style="flex: 1;">
                    <div class="form-group">
                        <label>Вершин в левой доле (L)</label>
                        <input type="number" name="n_left" id="inputNLeft" value="{{n_left or '3'}}" min="1" max="100" required>
                    </div>
                </div>
                <div style="flex: 1;">
                    <div class="form-group">
                        <label>Вершин в правой доле (R)</label>
                        <input type="number" name="n_right" id="inputNRight" value="{{n_right or '2'}}" min="1" max="100" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Список рёбер графа</label>
                <textarea name="edges" id="inputEdges" rows="5" placeholder="1 4&#10;1 5&#10;2 4&#10;3 5" required>{{edges or '1 4\n1 5\n2 4\n3 5'}}</textarea>
                <span class="small-text">Формат: "вершина_L вершина_R" (по одной паре на строку).</span>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-solve">НАЙТИ МИНИМАЛЬНОЕ ПОКРЫТИЕ</button>
                <button type="reset" class="btn-reset">Очистить</button>
            </div>
        </form>
        <button class="btn-generate" onclick="generateExample()">Загрузить пример</button>
    </div>

    <div class="result-card">
        <h2>Результат</h2>

        % if result is not None and not error:
            <div class="result-box">
                <div class="max-value">{{cover_size}}</div>
                <div style="margin-bottom: 12px;">размер минимального вершинного покрытия (макс. паросочетание = {{matching_size}})</div>

                <div><strong>Вершины, входящие в покрытие:</strong></div>
                <div class="selected-list">
                    % if cover_vertices:
                        % for v in cover_vertices.split():
                            <span class="tag">Вершина {{v}}</span>
                        % end
                    % else:
                        <span class="tag">Граф без рёбер (пустое покрытие)</span>
                    % end
                </div>

                <div style="margin-top: 15px; font-size: 13px; color: var(--text-dark);">
                    <strong>ℹТеорема Кёнига подтверждена:</strong> Покрытие из {{cover_size}} вершин полностью блокирует все рёбра графа.
                </div>
            </div>
        % elif error:
            <div class="error-msg">
                <strong>Ошибка:</strong> {{error}}
            </div>
        % else:
            <div style="text-align:center; padding: 30px; color: #888;">
                <div style="font-size: 40px;"></div>
                <p>Введите структуру графа и нажмите «НАЙТИ МИНИМАЛЬНОЕ ПОКРЫТИЕ»</p>
            </div>
        % end
    </div>

    % if result is not None and not error and matching_html:
    <div class="result-card">
        <h2>Максимальное паросочетание (Алгоритм Куна)</h2>
        <div class="tree-container">
            <pre>{{!matching_html}}</pre>
        </div>
    </div>
    % end

    <div class="nav-links">
        <a href="/" class="nav-btn">Домой</a>
        <button onclick="window.print();" class="nav-btn">Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">Назад</a>
    </div>
</div>

<script src="vertex_cover.js"></script>
