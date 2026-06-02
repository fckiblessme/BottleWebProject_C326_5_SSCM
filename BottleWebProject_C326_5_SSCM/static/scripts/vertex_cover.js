// Дефолтный демонстрационный пример графа (соответствует теории в шаблоне)
const defaultEdges = [
    { from: '1', to: '6' },
    { from: '2', to: '6' },
    { from: '2', to: '7' },
    { from: '3', to: '8' },
    { from: '3', to: '9' },
    { from: '4', to: '7' },
    { from: '5', to: '6' },
    { from: '5', to: '9' }
];

// Глобальная переменная для хранения экземпляра сети Vis.js, чтобы корректно её обновлять
let networkInstance = null;

// Функция динамического добавления одной строки ребра
function addNewEdgeRow(fromVal = '', toVal = '') {
    const container = document.getElementById('edgesTableBody');
    if (!container) return;

    const row = document.createElement('div');
    row.className = 'edge-row';
    row.style.display = 'flex';
    row.style.alignItems = 'center';
    row.style.gap = '10px';

    row.innerHTML = `
        <span class="matrix-label">L:</span>
        <input type="number" class="edge-from" placeholder="Доля L" value="${fromVal}" min="1" required>
        <span class="example-arrow" style="font-size: 18px; margin: 0 5px;">→</span>
        <span class="matrix-label">R:</span>
        <input type="number" class="edge-to" placeholder="Доля R" value="${toVal}" min="1" required>
        <button type="button" class="action-btn-danger" style="padding: 4px 10px;" onclick="this.parentElement.remove();">❌</button>
    `;
    container.appendChild(row);
}

// Загрузка дефолтного демонстрационного примера
function loadDemoGraph() {
    document.getElementById('inputNLeft').value = '5';
    document.getElementById('inputNRight').value = '4';

    const container = document.getElementById('edgesTableBody');
    if (!container) return;
    container.innerHTML = '';

    defaultEdges.forEach(edge => {
        addNewEdgeRow(edge.from, edge.to);
    });
    
    // Автоматически визуализируем дефолтный граф при его загрузке
    drawGraph(5, '1 6\n2 6\n2 7\n3 8\n3 9\n4 7\n5 6\n5 9', '');
}

// Очистить всю таблицу рёбер
function clearAllEdges() {
    const container = document.getElementById('edgesTableBody');
    if (container) container.innerHTML = '';
    addNewEdgeRow('', '');
}

// Экспорт графа в JSON-файл
function exportGraphToJSON() {
    const nLeft = parseInt(document.getElementById('inputNLeft').value) || 5;
    const nRight = parseInt(document.getElementById('inputNRight').value) || 4;

    const fromInputs = document.querySelectorAll('.edge-from');
    const toInputs = document.querySelectorAll('.edge-to');
    const edges = [];

    for (let i = 0; i < fromInputs.length; i++) {
        const fromVal = parseInt(fromInputs[i].value);
        const toVal = parseInt(toInputs[i].value);
        if (!isNaN(fromVal) && !isNaN(toVal)) {
            edges.push([fromVal, toVal]);
        }
    }

    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify({
        n_left: nLeft,
        n_right: nRight,
        edges: edges
    }, null, 4));

    const downloadAnchor = document.createElement('a');
    downloadAnchor.setAttribute("href", dataStr);
    downloadAnchor.setAttribute("download", "bipartite_graph.json");
    document.body.appendChild(downloadAnchor);
    downloadAnchor.click();
    downloadAnchor.remove();
}

// Импорт структуры из JSON-файла с валидацией формата данных
function importGraphFromJSON(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (e) {
        try {
            const data = JSON.parse(e.target.result);

            // --- Валидация структуры пришедшего JSON ---
            if (!data || typeof data !== 'object') {
                throw new Error('Файл должен содержать валидный JSON-объект.');
            }
            if (data.n_left === undefined || data.n_right === undefined) {
                throw new Error('Отсутствуют обязательные параметры n_left или n_right.');
            }
            if (!data.edges || !Array.isArray(data.edges)) {
                throw new Error('Поле "edges" отсутствует или не является массивом.');
            }
            // -------------------------------------------

            document.getElementById('inputNLeft').value = data.n_left || '5';
            document.getElementById('inputNRight').value = data.n_right || '4';

            const container = document.getElementById('edgesTableBody');
            if (!container) return;
            container.innerHTML = '';

            let rawEdgesText = '';
            data.edges.forEach(edge => {
                if (Array.isArray(edge) && edge.length === 2) {
                    addNewEdgeRow(edge[0], edge[1]);
                    rawEdgesText += `${edge[0]} ${edge[1]}\n`;
                } else if (edge && edge.from !== undefined && edge.to !== undefined) {
                    addNewEdgeRow(edge.from, edge.to);
                    rawEdgesText += `${edge.from} ${edge.to}\n`;
                } else {
                    throw new Error('Неверный формат ребра в массиве "edges". Ожидается [from, to] или {from, to}.');
                }
            });

            if (container.querySelectorAll('.edge-row').length === 0) {
                addNewEdgeRow('', '');
            }
            
            // Сразу отображаем импортированный граф
            drawGraph(parseInt(data.n_left) || 5, rawEdgesText, '');

        } catch (error) {
            alert('Ошибка при чтении или разборе JSON файла графа: ' + error.message);
        } finally {
            // Гарантированно сбрасываем инпут в конце, чтобы change срабатывал всегда
            event.target.value = '';
        }
    };
    reader.readAsText(file);
}

// Вынесенная функция отрисовки интерактива через Vis.js
function drawGraph(nLeftMax, edgesRaw, coverRaw) {
    const graphContainer = document.getElementById('network-graph');
    if (!graphContainer) return;

    // Превращаем вершины покрытия в сет для быстрой проверки
    const coverSet = new Set(String(coverRaw).split(/\s+/).filter(x => x).map(Number));

    if (!edgesRaw || !edgesRaw.trim()) {
        if (networkInstance) {
            networkInstance.destroy();
            networkInstance = null;
        }
        return;
    }

    const lines = edgesRaw.trim().split('\n');
    const nodesSet = new Set();
    const edgesArray = [];

    lines.forEach((line, idx) => {
        const parts = line.trim().split(/\s+/);
        if (parts.length === 2) {
            const u = parseInt(parts[0]);
            const v = parseInt(parts[1]);
            if (!isNaN(u) && !isNaN(v)) {
                nodesSet.add(u);
                nodesSet.add(v);
                edgesArray.push({ id: idx, from: u, to: v });
            }
        }
    });

    // Преобразуем уникальные вершины в объекты Vis.js
    const nodesArray = Array.from(nodesSet).map(nodeId => {
        const isLeft = nodeId <= nLeftMax;
        const inCover = coverSet.has(nodeId);
        
        return {
            id: nodeId,
            label: String(nodeId),
            color: {
                background: isLeft ? '#97C2FC' : '#FFD54F',
                border: inCover ? '#dc3545' : '#2B7CE9',
                highlight: {
                    background: isLeft ? '#a3cbff' : '#ffe082',
                    border: '#dc3545'
                }
            },
            borderWidth: inCover ? 4 : 1, // Выделяем обводку вершин покрытия жирным красным
            shape: 'circle',
            font: { size: 14, color: '#000', face: 'monospace', bold: true }
        };
    });

    const data = {
        nodes: new vis.DataSet(nodesArray),
        edges: new vis.DataSet(edgesArray)
    };

    const options = {
        physics: { enabled: true, stabilization: true },
        edges: {
            width: 2,
            color: { color: '#848484', highlight: '#dc3545' }
        },
        interaction: { hover: true }
    };

    if (networkInstance) {
        networkInstance.destroy();
    }
    networkInstance = new vis.Network(graphContainer, data, options);
}

// ИНИЦИАЛИЗАЦИЯ И СБОР ДАННЫХ ПРИ ОТПРАВКЕ ФОРМЫ
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById('graphForm');
    
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault(); 

            // Считываем текущую конфигурацию мощностей долей
            const nLeft = parseInt(document.getElementById('inputNLeft').value) || 0;
            const nRight = parseInt(document.getElementById('inputNRight').value) || 0;
            const maxVertexIdx = nLeft + nRight;

            const fromInputs = document.querySelectorAll('.edge-from');
            const toInputs = document.querySelectorAll('.edge-to');
            
            let edgesText = '';
            let validEdgesCount = 0;
            const uniqueEdgesCheck = new Set();

            // Интегрированная валидация структуры двудольного графа
            for (let i = 0; i < fromInputs.length; i++) {
                const fromValRaw = fromInputs[i].value.trim();
                const toValRaw = toInputs[i].value.trim();

                if (fromValRaw && toValRaw) {
                    const fromVal = parseInt(fromValRaw);
                    const toVal = parseInt(toValRaw);

                    // 1. Проверка на выход левой вершины за границы L-доли
                    if (fromVal < 1 || fromVal > nLeft) {
                        alert(`Ошибка в строке ${i + 1}: Вершина левой доли L (${fromVal}) должна быть в диапазоне от 1 до ${nLeft}.`);
                        return;
                    }

                    // 2. Проверка на выход правой вершины за границы R-доли
                    if (toVal <= nLeft || toVal > maxVertexIdx) {
                        alert(`Ошибка в строке ${i + 1}: Вершина правой доли R (${toVal}) должна быть в диапазоне от ${nLeft + 1} до ${maxVertexIdx}.`);
                        return;
                    }

                    // 3. Проверка на петли (на всякий случай, если диапазоны пересеклись)
                    if (fromVal === toVal) {
                        alert(`Ошибка в строке ${i + 1}: Обнаружена петля (${fromVal} → ${toVal}). В двудольном графе петли невозможны.`);
                        return;
                    }

                    // Формируем ключ для фильтрации дубликатов рёбер
                    const edgeKey = `${fromVal}-${toVal}`;
                    if (uniqueEdgesCheck.has(edgeKey)) {
                        alert(`Ошибка в строке ${i + 1}: Ребро ${fromVal} → ${toVal} продублировано. Пожалуйста, удалите лишние строки.`);
                        return;
                    }
                    uniqueEdgesCheck.add(edgeKey);

                    edgesText += `${fromVal} ${toVal}\n`;
                    validEdgesCount++;
                }
            }
            
            // 4. Защита от пустого списка рёбер
            if (validEdgesCount === 0) {
                alert("Ошибка расчета: Список рёбер графа пуст! Пожалуйста, добавьте хотя бы одно корректное связь-ребро.");
                return;
            }

            // Перенос очищенной и проверенной строки в скрытое поле формы
            const edgesInput = document.getElementById('edgesInput');
            if (edgesInput) edgesInput.value = edgesText;

            // Отправка AJAX-запроса на бэкенд
            const formData = new FormData(form);
            
            fetch('/vertex_cover/solve', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success || data.cover_size !== undefined) {
                    const placeholder = document.getElementById('result-placeholder');
                    if (placeholder) placeholder.style.display = 'none';

                    const resBlock = document.getElementById('results-block');
                    if (resBlock) resBlock.style.display = 'block';

                    const coverSizeEl = document.getElementById('cover-size-output');
                    const matchingSizeEl = document.getElementById('matching-size-output');
                    const coverVerticesEl = document.getElementById('cover-vertices-output');
                    const logsEl = document.getElementById('logs-output');

                    if (coverSizeEl) coverSizeEl.innerText = data.cover_size;
                    if (matchingSizeEl) matchingSizeEl.innerText = data.matching_size;
                    if (logsEl) logsEl.innerHTML = data.matching_html;

                    if (coverVerticesEl) {
                        coverVerticesEl.innerHTML = ''; 
                        if (data.cover_vertices && data.cover_vertices.trim() && data.cover_vertices !== "Покрытие пустое") {
                            data.cover_vertices.split(/\s+/).forEach(v => {
                                if (v) {
                                    coverVerticesEl.innerHTML += `<span class="tag" style="display: inline-block; margin-right: 5px;">Вершина ${v}</span>`;
                                }
                            });
                        } else {
                            coverVerticesEl.innerHTML = '<span class="tag">Граф без рёбер (пустое покрытие)</span>';
                        }
                    }

                    const nLeftMax = parseInt(document.getElementById('inputNLeft').value) || 5;
                    drawGraph(nLeftMax, edgesText, data.cover_vertices);

                } else if (data.error) {
                    alert("Ошибка при расчёте: " + data.error);
                }
            })
            .catch(err => {
                console.error("Ошибка AJAX запроса:", err);
                alert("Не удалось получить ответ от сервера. Проверьте консоль браузера.");
            });
        });
    }

    // Первоначальное восстановление данных (при первой загрузке страницы с сервера)
    const serverDataEl = document.getElementById('serverEdgesData');
    if (serverDataEl) {
        const initialEdgesRaw = serverDataEl.getAttribute('data-edges') || '';
        const initialCoverRaw = serverDataEl.getAttribute('data-cover') || '';
        const nLeftMax = parseInt(document.getElementById('inputNLeft').value) || 5;

        if (initialEdgesRaw.trim()) {
            const container = document.getElementById('edgesTableBody');
            if (container) container.innerHTML = '';
            
            initialEdgesRaw.trim().split('\n').forEach(line => {
                const parts = line.trim().split(/\s+/);
                if (parts.length === 2) {
                    addNewEdgeRow(parts[0], parts[1]);
                }
            });
            drawGraph(nLeftMax, initialEdgesRaw, initialCoverRaw);
        } else {
            loadDemoGraph();
        }
    }
});