% rebase('layout.tpl', title='Задача коммивояжёра')
<script src="https://unpkg.com/vis-network/standalone/umd/vis-network.min.js"></script>
<script src="/static/scripts/tsp.js"></script>

<div class="theory">
    <h2>📖 Теория метода и основные определения</h2>
    
    <div class="theory-block" style="margin-bottom: 20px;">
        <p><strong>Гамильтонов цикл</strong> — это замкнутый маршрут, проходящий через каждую вершину графа ровно один раз и возвращающийся в исходную вершину.</p>
        
        <p><strong>Задача коммивояжёра (TSP)</strong> — задача поиска гамильтонова цикла минимального веса в полном взвешенном графе. Коммивояжёр должен посетить все города по одному разу и вернуться в исходный, затратив минимальное расстояние.</p>
        
        <p><strong>Вес цикла</strong> — сумма весов всех рёбер, входящих в гамильтонов цикл.</p>
        
        <p><strong>Полный перебор</strong> — метод решения, при котором перебираются все возможные перестановки вершин (с фиксацией первой вершины для уменьшения количества вариантов) и выбирается перестановка с минимальным суммарным весом.</p>
    </div>
    
    <h3>💡 Метод решения</h3>
    <p style="background: #faf9f6; padding: 15px; border-left: 4px solid var(--accent); border-radius: 8px; margin-bottom: 20px;">
        Для графа из <strong>N</strong> вершин количество возможных гамильтоновых циклов равно <strong>(N-1)! / 2</strong> (с учётом симметрии и фиксации начальной вершины). 
        <br>Алгоритм перебирает все перестановки вершин (кроме первой), вычисляет вес каждого цикла и запоминает минимальный.
    </p>

    <h3>🎛️ Пошаговый алгоритм решения</h3>
    <ol class="theory-list" style="margin-bottom: 20px; padding-left: 20px;">
        <li><strong>Фиксация начальной вершины:</strong>
            <ul style="margin: 5px 0 10px 20px; list-style-type: circle;">
                <li>Фиксируем первую вершину (обычно вершину 1), чтобы избежать дублирования циклов, отличающихся только точкой отсчёта.</li>
            </ul>
        </li>
        <li><strong>Генерация всех перестановок:</strong>
            <ul style="margin: 5px 0 10px 20px; list-style-type: circle;">
                <li>Для оставшихся N-1 вершин генерируем все возможные перестановки.</li>
                <li>Для N=4 это 3! = 6 перестановок.</li>
            </ul>
        </li>
        <li><strong>Вычисление веса цикла:</strong>
            <ul style="margin: 5px 0 10px 20px; list-style-type: circle;">
                <li>Для каждой перестановки вычисляем сумму весов рёбер: от первой вершины ко второй, от второй к третьей, ... и от последней обратно к первой.</li>
                <li>Вес берётся из матрицы расстояний.</li>
            </ul>
        </li>
        <li><strong>Выбор оптимального маршрута:</strong>
            <ul style="margin: 5px 0 10px 20px; list-style-type: circle;">
                <li>Сравниваем вес текущего цикла с лучшим найденным.</li>
                <li>Если вес меньше — запоминаем новый маршрут и его вес.</li>
            </ul>
        </li>
    </ol>

    <h3>📐 Сложность алгоритма</h3>
    <p style="background: #faf9f6; padding: 15px; border-left: 4px solid var(--accent); border-radius: 8px; margin-bottom: 20px;">
        <strong>O(N!)</strong> — факториальная сложность. При N=12 количество перестановок составляет около 39 916 800, что является пределом для полного перебора.
    </p>

    <a href="#inputForm" class="anchor-link">Перейти к форме ввода →</a>
</div>

<div class="example">
    <h2>Подробный пример (N=4)</h2>
    <div class="example-layout">
        <div class="example-matrix-col">
            <strong>Матрица расстояний:</strong>
            <div class="example-matrix-wrapper">
                <table class="example-matrix">
                    <thead>
                        <tr>
                            <th></th>
                            <th>1</th>
                            <th>2</th>
                            <th>3</th>
                            <th>4</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="example-matrix-label">1</td>
                            <td>0</td>
                            <td>10</td>
                            <td>15</td>
                            <td>20</td>
                        </tr>
                        <tr>
                            <td class="example-matrix-label">2</td>
                            <td>10</td>
                            <td>0</td>
                            <td>35</td>
                            <td>25</td>
                        </tr>
                        <tr>
                            <td class="example-matrix-label">3</td>
                            <td>15</td>
                            <td>35</td>
                            <td>0</td>
                            <td>30</td>
                        </tr>
                        <tr>
                            <td class="example-matrix-label">4</td>
                            <td>20</td>
                            <td>25</td>
                            <td>30</td>
                            <td>0</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="example-image">
                <img src="/static/images/tsp_graph.png" alt="Граф для задачи коммивояжёра" class="example-graph-img">
            </div>
        </div>


        <div class="example-paths-col">
            <strong>Все возможные маршруты:</strong>
            <div class="example-paths">
                <div class="path-item">
                    <span class="path-route">1 → 2 → 3 → 4 → 1</span>
                    <span class="path-weight">10 + 35 + 30 + 20 = <strong>95</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 2 → 4 → 3 → 1</span>
                    <span class="path-weight">10 + 25 + 30 + 15 = <strong>80</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 3 → 2 → 4 → 1</span>
                    <span class="path-weight">15 + 35 + 25 + 20 = <strong>95</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 3 → 4 → 2 → 1</span>
                    <span class="path-weight">15 + 30 + 25 + 10 = <strong>80</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 4 → 2 → 3 → 1</span>
                    <span class="path-weight">20 + 25 + 35 + 15 = <strong>95</strong></span>
                </div>
                <div class="path-item">
                    <span class="path-route">1 → 4 → 3 → 2 → 1</span>
                    <span class="path-weight">20 + 30 + 35 + 10 = <strong>95</strong></span>
                </div>
            </div>
            
            <div style="margin-top: 15px; padding-top: 12px; border-top: 2px dashed var(--accent);">
                <div style="padding: 3px 0; font-size: 18px; color: var(--text-darker);">Минимальный вес: <strong>80</strong></div>
                <div style="padding: 3px 0; font-size: 18px; color: var(--text-darker);">Оптимальные маршруты: 1 → 2 → 4 → 3 → 1  и  1 → 3 → 4 → 2 → 1</div>
            </div>
        </div>
    </div>
</div>

<div class="form-card" id="inputForm">
    <h2>Ввод данных графа</h2>
    % if error:
    <div class="error-msg" id="errorBlock">
        <strong>⚠️ Ошибка:</strong> {{error}}
    </div>
    % else:
    <div class="error-msg" id="errorBlock" style="display: none;">
        <strong>⚠️ Ошибка:</strong> <span id="errorText"></span>
    </div>
    % end

    <form action="/tsp" method="post" accept-charset="UTF-8">
        <div class="form-group">
            <label>Количество вершин (N ≤ 12)</label>
            <div class="input-row-flex">
                <input type="text" name="n" value="{{n if n else '4'}}" required>
                <button type="submit" name="create" value="1" class="btn-generate">Создать</button>
            </div>
        </div>
    </form>

    % if n:
 
    <form action="/tsp" method="post" accept-charset="UTF-8">
        <input type="hidden" name="n" value="{{n}}">
        <div class="form-group">
            <label>Матрица расстояний</label>
            <div class="matrix-wrapper">
                <table class="matrix-table">
                    <thead>
                        <tr>
                            <th></th>
                            % for i in range(1, n+1):
                            <th>{{i}}</th>
                            % end
                        </tr>
                    </thead>
                    <tbody>
                        % for i in range(1, n+1):
                        <tr>
                            <td class="matrix-label">{{i}}</td>
                            % for j in range(1, n+1):
                                % if i == j:
                                <td><input type="text" name="m{{i}}{{j}}" value="0" disabled class="matrix-cell"></td>
                                % elif i < j:
                                <td><input type="text" name="m{{i}}{{j}}" id="m{{i}}{{j}}" value="{{matrix[i-1][j-1] if matrix else 0}}" step="1" min="1" class="matrix-cell" oninput="syncMatrix({{i}}, {{j}})" onfocus="highlightPair({{i}}, {{j}})" onblur="unhighlightPair({{i}}, {{j}})"></td>
                                % else:
<td><input type="text" name="m{{i}}{{j}}" id="m{{i}}{{j}}" value="{{matrix[i-1][j-1] if matrix else 0}}" step="1" min="1" class="matrix-cell" oninput="syncMatrix({{i}}, {{j}})" onfocus="highlightPair({{i}}, {{j}})" onblur="unhighlightPair({{i}}, {{j}})"></td>
                                % end
                            % end
                        </tr>
                        % end
                    </tbody>
                </table>
            </div>
            <div class="button-row">
                <button type="submit" name="random" value="1" class="btn-random" formnovalidate>Случайные значения</button>
                <button type="submit" name="submit" value="1" class="btn-confirm">Подтвердить ввод</button>
            </div>
        </div>
    </form>
    % end
</div>
<div class="result-card">
    <h2>Результат</h2>
    % if result:
    <div class="result-placeholder">
        % if result == 'created':
        <div style="font-size: 40px;">✅</div>
        <p>Матрица создана</p>
        % else:
        

        <div style="background: #faf9f6; padding: 15px; border-left: 4px solid var(--accent); border-radius: 8px; margin-bottom: 20px;">
            <div style="font-size: 18px; color: var(--text-darker); margin-bottom: 8px;">
                Минимальный вес: <strong>{{best_distance}}</strong>
            </div>
            <div style="font-size: 18px; color: var(--text-darker); margin-bottom: 8px;">
                Оптимальный маршрут: <strong>{{best_route_str}}</strong>
            </div>
            <div style="font-size: 18px; color: var(--text-darker);">
                Вычисление: {{!best_calc}}
            </div>
        </div>
        
 
        <div id="network-graph" style="width:100%; height:600px; border:1px solid #ddd; margin-bottom:20px;"></div>
        

        <details style="margin-bottom: 15px;">
            <summary style="cursor: pointer; font-weight: bold; font-size: 16px; padding: 8px 0; user-select: none;">
                Все возможные маршруты
            </summary>
            <div style="padding-top: 10px;">
                {{!result}}
            </div>
        </details>
        
        % end
        <div id="serverTspData" data-route="{{route if route else ''}}" style="display:none;"></div>
    </div>
    

% if result and result != 'created':
<div style="display: flex; justify-content: flex-end; margin-top: 20px; align-items: center; gap: 15px;">
    <div id="saveSuccessMsg" style="display: none; background: #d4edda; color: #155724; padding: 8px 15px; border-radius: 5px; font-size: 14px;">
        Результат успешно сохранён
    </div>
    <form onsubmit="event.preventDefault(); saveResultToFile();" style="margin: 0;" accept-charset="UTF-8">
    <input type="hidden" name="matrix_data" value="{{matrix_data}}">
    <input type="hidden" name="route_data" value="{{route}}">
    <input type="hidden" name="best_distance_data" value="{{best_distance}}">
    <button type="submit" class="btn-confirm">Сохранить в файл</button>
</form>
</div>
% else:
<div style="display: flex; justify-content: flex-end; margin-top: 20px;">
    <button type="button" class="btn-confirm" disabled>Сохранить в файл</button>
</div>
% end
    
    % else:
    <div class="result-placeholder">
        <div style="font-size: 40px;">🗺️</div>
        <p>Результат появится после решения задачи</p>
    </div>
    % end
</div>