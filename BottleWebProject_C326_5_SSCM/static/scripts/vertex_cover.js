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

// Функция динамического добавления одной строки ребра
function addNewEdgeRow(fromVal = '', toVal = '') {
    const container = document.getElementById('edgesTableBody');
    if (!container) return;

    const row = document.createElement('div');
    row.className = 'edge-row';
    // Инлайновые стили убираем в пользу классов из style.css, оставляя только флекс-выравнивание
    row.style.display = 'flex';
    row.style.alignItems = 'center';
    row.style.gap = '10px';

    row.innerHTML = `
        <span class="matrix-label">L:</span>
        <input type="number" class="edge-from" placeholder="Доля L" value="${fromVal}" min="1" required>
        <span class="example-arrow" style="font-size: 18px; margin: 0 5px;">→</span>
        <span class="matrix-label">R:</span>
        <input type="number" class="edge-to" placeholder="Доля R" value="${toVal}" min="1" required>
        <button type="button" class="btn-remove-edge" onclick="removeCurrentEdgeRow(this)" title="Удалить ребро">×</button>
    `;

    container.appendChild(row);

    // Валидация: если ребро стало больше одного, разблокируем кнопки удаления
    toggleRemoveButtons();

    // Автоскролл контейнера вниз, чтобы новое ребро сразу было видно
    container.parentElement.scrollTop = container.parentElement.scrollHeight;
}

// Безопасное удаление строки с проверкой на минимальное количество (1 строка)
function removeCurrentEdgeRow(button) {
    const container = document.getElementById('edgesTableBody');
    if (!container) return;

    if (container.querySelectorAll('.edge-row').length > 1) {
        button.parentElement.remove();
        toggleRemoveButtons();
    }
}

// Вспомогательная функция для блокировки/разблокировки крестиков удаления
function toggleRemoveButtons() {
    const rows = document.querySelectorAll('#edgesTableBody .edge-row');
    rows.forEach(row => {
        const btn = row.querySelector('.btn-remove-edge');
        if (btn) {
            btn.disabled = (rows.length === 1);
        }
    });
}

// Очистка таблицы
function clearEdgesTable() {
    const container = document.getElementById('edgesTableBody');
    if (container) {
        container.innerHTML = '';
        addNewEdgeRow('', ''); // Оставляем одну пустую интерактивную строку
    }
}

// Загрузка дефолтных значений примера (5 вершин слева, 4 справа)
function loadDefaultTableExample() {
    const container = document.getElementById('edgesTableBody');
    if (!container) return;

    container.innerHTML = '';
    document.getElementById('inputNLeft').value = '5';
    document.getElementById('inputNRight').value = '4';
    defaultEdges.forEach(edge => addNewEdgeRow(edge.from, edge.to));
}

// Сборка данных из таблицы в плоскую строку перед отправкой на бэкенд
function prepareEdgesForSubmit(e) {
    const rows = document.querySelectorAll('#edgesTableBody .edge-row');
    let edgesString = '';

    rows.forEach(row => {
        const from = row.querySelector('.edge-from').value.trim();
        const to = row.querySelector('.edge-to').value.trim();
        if (from && to) {
            edgesString += `${from} ${to}\n`;
        }
    });

    const hiddenInput = document.getElementById('hiddenEdgesInput');
    if (hiddenInput) {
        hiddenInput.value = edgesString.trim();
    }
}

// Инициализация обработчиков событий после загрузки DOM
document.addEventListener("DOMContentLoaded", function () {
    // Привязка кликов к кнопкам управления
    const btnAddEdge = document.getElementById('btnAddEdge');
    const btnResetTable = document.getElementById('btnResetTable');
    const btnLoadExample = document.getElementById('btnLoadExample');
    const mainForm = document.getElementById('mainForm');

    if (btnAddEdge) btnAddEdge.addEventListener('click', () => addNewEdgeRow('', ''));
    if (btnResetTable) btnResetTable.addEventListener('click', clearEdgesTable);
    if (btnLoadExample) btnLoadExample.addEventListener('click', loadDefaultTableExample);

    // Перехват отправки формы для трансформации данных таблицы
    if (mainForm) {
        mainForm.addEventListener('submit', prepareEdgesForSubmit);
    }

    // Восстановление состояния: проверяем, прислал ли бэкенд сохраненные данные обратно
    const serverEdgesData = document.getElementById('serverEdgesData');
    let initialEdges = serverEdgesData ? serverEdgesData.getAttribute('data-edges').trim() : '';

    if (initialEdges) {
        const pairs = initialEdges.split('\n');
        let addedAny = false;

        pairs.forEach(pair => {
            const parts = pair.trim().split(/\s+/);
            if (parts.length === 2) {
                addNewEdgeRow(parts[0], parts[1]);
                addedAny = true;
            }
        });

        if (!addedAny) addNewEdgeRow('', '');
    } else {
        // Если страница открыта впервые, сразу генерируем красивый готовый пример
        loadDefaultTableExample();
    }
});

// Сохранение текущего графа из интерактивной таблицы в JSON-файл
function saveToJSON() {
    const rows = document.querySelectorAll('#edgesTableBody .edge-row');
    const validEdges = [];

    rows.forEach(row => {
        const from = row.querySelector('.edge-from').value.trim();
        const to = row.querySelector('.edge-to').value.trim();
        if (from && to) {
            validEdges.push([parseInt(from), parseInt(to)]);
        }
    });

    const data = {
        n_left: parseInt(document.getElementById('inputNLeft').value) || 5,
        n_right: parseInt(document.getElementById('inputNRight').value) || 4,
        edges: validEdges
    };

    const jsonStr = JSON.stringify(data, null, 4);
    const blob = new Blob([jsonStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'vertex_cover_graph.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// Загрузка структуры графа из JSON-файла напрямую в интерактивную таблицу
function loadFromJSON(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (e) {
        try {
            const data = JSON.parse(e.target.result);

            // Заполняем размерности долей
            document.getElementById('inputNLeft').value = data.n_left || '5';
            document.getElementById('inputNRight').value = data.n_right || '4';

            // Перестраиваем контейнер рёбер
            const container = document.getElementById('edgesTableBody');
            if (!container) return;
            container.innerHTML = '';

            if (data.edges && Array.isArray(data.edges)) {
                data.edges.forEach(edge => {
                    // Обрабатываем формат массивов [1, 6] или объектов {from, to}
                    if (Array.isArray(edge) && edge.length === 2) {
                        addNewEdgeRow(edge[0], edge[1]);
                    } else if (edge && edge.from && edge.to) {
                        addNewEdgeRow(edge.from, edge.to);
                    }
                });
            }

            // Если импортированный массив оказался пуст, создаём одну чистую строку
            if (container.querySelectorAll('.edge-row').length === 0) {
                addNewEdgeRow('', '');
            }

            // Сбрасываем значение input[type=file], чтобы можно было повторно загружать тот же файл
            event.target.value = '';

        } catch (error) {
            alert('Ошибка при чтении или разборе JSON файла графа: ' + error.message);
        }
    };
    reader.readAsText(file);
}