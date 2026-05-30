% # vertex_cover.tpl - Минимальное вершинное покрытие в двудольном графе
% rebase('layout.tpl', title='Минимальное вершинное покрытие')

<div class="container">
    <div class="header">
        <h1>Минимальное вершинное покрытие в двудольном графе</h1>
        <p>Теорема Кёнига | Алгоритм Куна для поиска паросочетаний</p>
    </div>

    <div class="theory">
        <h2>📖 Теория метода</h2>
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
            <strong>Доли графа:</strong> Левая (L: 1, 2, 3, 4, 5) → Правая (R: 6, 7, 8, 9)<br>
            <strong>Рёбра:</strong><br>
            1 — 6<br>
            2 — 6, 2 — 7<br>
            3 — 8, 3 — 9<br>
            4 — 7<br>
            5 — 6, 5 — 9<br>
            <strong>Результат → Минимальное покрытие:</strong> Вершины [3, 6, 7, 9] (Размер: 4, покрывают все рёбра).
        </div>

        <div class="theory-image" style="text-align: center; margin: 20px 0 10px;">
            <img src="/static/images/dvydoli.png" alt="Пример вершинного покрытия" style="max-width: 100%; max-height: 250px; object-fit: contain; border-radius: 12px; box-shadow: 0 4px 10px var(--shadow); border: 1px solid var(--accent); background-color: #fff;">
            <div style="font-size: 13px; color: var(--text-dark); margin-top: 8px;">
                Визуализация текущего примера. Минимальное покрытие составляют вершины <strong>3</strong> (из левой доли) и <strong>6, 7, 9</strong> (из правой доли).
            </div>
        </div>
    </div>

    <div class="form-card" id="inputForm">
        <h2>Ввод данных графа</h2>

        <div class="file-buttons">
            <button class="btn-file" onclick="saveToJSON()">💾 Сохранить в JSON</button>
            <label class="btn-file" style="cursor: pointer;">📂 Загрузить из JSON
                <input type="file" id="jsonFileInput" accept=".json" style="display: none;" onchange="loadFromJSON(event)">
            </label>
        </div>

        <form action="/vertex_cover/solve" method="post" id="mainForm">
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <div style="flex: 1;">
                    <div class="form-group">
                        <label>Вершин в левой доле (L)</label>
                        <input type="number" name="n_left" id="inputNLeft" value="{{n_left or '5'}}" min="1" max="100" required>
                    </div>
                </div>
                <div style="flex: 1;">
                    <div class="form-group">
                        <label>Вершин в правой доле (R)</label>
                        <input type="number" name="n_right" id="inputNRight" value="{{n_right or '4'}}" min="1" max="100" required>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <label>Список рёбер графа</label>
                <textarea name="edges" id="inputEdges" rows="7" style="resize:none" placeholder="1 6&#10;2 6&#10;2 7&#10;3 8&#10;3 9&#10;4 7&#10;5 6&#10;5 9" required>{{edges or '1 6\n2 6\n2 7\n3 8\n3 9\n4 7\n5 6\n5 9'}}</textarea>
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
        <h2>📊 Результат</h2>

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
                    <strong>ℹ Теорема Кёнига подтверждена:</strong> Покрытие из {{cover_size}} вершин полностью блокирует все рёбра графа.
                </div>
            </div>
        % elif error:
            <div class="error-msg">
                <strong>Ошибка:</strong> {{error}}
            </div>
        % else:
            <div class="result-placeholder">
                <span class="result-icon">🕸️</span>
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
        <a href="/" class="nav-btn">🏠 Домой</a>
        <button onclick="window.print();" class="nav-btn">🖨️ Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">⬅️ Назад</a>
    </div>
</div>

<script src="vertex_cover.js"></script>