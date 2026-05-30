% # vertex_cover.tpl - Минимальное вершинное покрытие в двудольном графе
% rebase('layout.tpl', title='Минимальное вершинное покрытие')

<div class="container">

    <div class="theory">
        <h2>📖 Теория метода и основные определения</h2>
        
        <div class="theory-block" style="margin-bottom: 20px;">
            <p><strong>Двудольный граф</strong> — это граф, множество вершин которого можно разбить на две доли L (левая) и R (правая) так, что любое ребро графа соединяет вершину из левой доли с вершиной из правой доли. Внутри одной доли рёбер нет.</p>
            
            <p><strong>Вершинное покрытие</strong> — это подмножество вершин графа, такое, что для каждого ребра графа хотя бы один из его концов входит в это подмножество. Ребро считается <em>покрытым</em>, если покрыта хотя бы одна его оконечная вершина.</p>
            
            <p><strong>Минимальное вершинное покрытие</strong> — это вершинное покрытие, содержащее <em>наименьшее возможное</em> количество вершин для данного графа.</p>
            
            <p><strong>Паросочетание</strong> — это набор попарно несмежных рёбер графа (никакие два ребра из набора не имеют общих вершин). Паросочетание называется <strong>максимальным</strong>, если оно содержит максимально возможное число рёбер.</p>
        </div>
        
        <h3>💡 Теорема Кёнига</h3>
        <p style="background: #faf9f6; padding: 15px; border-left: 4px solid var(--accent); border-radius: 8px; margin-bottom: 20px;">
            В любом конечном <strong>двудольном графе</strong> размер минимального вершинного покрытия равен размеру максимального паросочетания: 
            <br><span style="font-family: monospace; font-weight: bold; display: block; margin-top: 5px;">|Min Vertex Cover| = |Max Matching|</span>
            Благодаря этой теореме задача поиска покрытия сводится к поиску максимального паросочетания, которая эффективно решается алгоритмом Куна.
        </p>

        <h3>🎛️ Пошаговый алгоритм решения</h3>
        <ol class="theory-list" style="margin-bottom: 20px; padding-left: 20px;">
            <li><strong>Поиск максимального паросочетания (Алгоритм Куна):</strong>
                <ul style="margin: 5px 0 10px 20px; list-style-type: circle;">
                    <li>Изначально паросочетание пустое.</li>
                    <li>Перебираем вершины левой доли L. Для каждой вершины пытаемся найти <em>увеличивающую цепь</em> при помощи обхода в глубину (DFS).</li>
                    <li>Если цепь найдена, выполняем инверсию путей. Размер паросочетания увеличивается на 1.</li>
                </ul>
            </li>
            <li><strong>Запуск разметки (DFS для построения покрытия):</strong>
                <ul style="margin: 5px 0 10px 20px; list-style-type: circle;">
                    <li>Запускаем DFS из всех вершин левой доли L, которые <strong>не включены</strong> в максимальное паросочетание.</li>
                    <li>DFS перемещается из L в R только по не принадлежащим паросочетанию рёбрам, а из R в L — только по рёбрам из паросочетания.</li>
                </ul>
            </li>
            <li><strong>Выбор вершин в минимальное покрытие:</strong>
                <ul style="margin: 5px 0 10px 20px; list-style-type: square;">
                    <li>Из левой доли L берём вершины, которые <strong>НЕ были посещены</strong> в ходе DFS.</li>
                    <li>Из правой доли R берём вершины, которые <strong>БЫЛИ посещены</strong> в ходе DFS.</li>
                </ul>
            </li>
        </ol>

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
                Визуализация текущего примера. Минимальное покрытие составляют вершины <strong>3</strong> (не посещена при DFS) и <strong>6, 7, 9</strong> (посещены при обходе).
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
            <input type="hidden" name="edges" id="hiddenEdgesInput">

            <div style="display: flex; gap: 15px; flex-wrap: wrap; margin-bottom: 20px;">
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
                <label>Список рёбер графа (Таблица связей)</label>
                <div class="edges-container" style="max-height: 320px; overflow-y: auto; margin-bottom: 10px; padding: 15px; border-radius: 12px; background: #faf9f6; border: 1px solid var(--accent);">
                    <div class="edges-list" id="edgesTableBody">
                        </div>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <button type="button" class="btn-add-edge" id="btnAddEdge">➕ Добавить ребро</button>
                    <span class="small-text">Указывайте пары вершин: из левой доли (L) и соединённую с ней из правой (R).</span>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-solve">НАЙТИ МИНИМАЛЬНОЕ ПОКРЫТИЕ</button>
                <button type="button" class="btn-reset" id="btnResetTable">Очистить</button>
            </div>
        </form>
        <button class="btn-generate" id="btnLoadExample">Загрузить пример</button>
    </div>

    <div class="result-card">
        <h2>📊 Результат расчета</h2>

        % if result is not None and not error:
            <div class="result-box">
                <div class="max-value">{{cover_size}}</div>
                <div style="margin-bottom: 12px;">размер минимального вершинного покрытия (согласно теореме Кёнига равен мощности макс. паросочетания = {{matching_size}})</div>

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
                    <strong>ℹ Теорема Кёнига подтверждена:</strong> Выбранный набор из {{cover_size}} вершин является оптимальным (минимально возможным) и полностью блокирует абсолютно все рёбра.
                </div>
            </div>
        % elif error:
            <div class="error-msg">
                <strong>Ошибка обработки:</strong> {{error}}
            </div>
        % else:
            <div class="result-placeholder">
                <span class="result-icon">🕸️</span>
                <p>Введите структуру долей и рёбер графа выше, затем нажмите «НАЙТИ МИНИМАЛЬНОЕ ПОКРЫТИЕ» для запуска вычислений.</p>
            </div>
        % end
    </div>

    % if result is not None and not error and matching_html:
    <div class="result-card">
        <h2>Максимальное паросочетание (Пошаговые логи алгоритма Куна)</h2>
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

<div id="serverEdgesData" data-edges="{{edges or ''}}" style="display: none;"></div>

<script src="/static/js/vertex_cover.js"></script>