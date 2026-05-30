// Дефолтный демонстрационный пример графа
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
    row.style.display = 'flex';
    row.style.gap = '10px';
    row.style.alignItems = 'center';
    row.style.marginBottom = '8px';

    row.innerHTML = `
        <span style="font-size: 14px; color: var(--text-dark); width: 60px; font-weight: 600;">Ребро:</span>
        <input type="number" class="edge-from" placeholder="Доля L" value="${fromVal}" min="1" required style="flex: 1;">
        <span style="color: var(--text-dark);">⇄</span>
        <input type="number" class="edge-to" placeholder="Доля R" value="${toVal}" min="1" required style="flex: 1;">
        <button type="button" class="btn-remove-edge" onclick="this.parentElement.remove()" title="Удалить ребро">×</button>
    `;

    container.appendChild(row);
    // Автоскролл контейнера вниз, чтобы новое ребро сразу было видно
    container.parentElement.scrollTop = container.parentElement.scrollHeight;
}

// Очистка таблицы
function clearEdgesTable() {
    const container = document.getElementById('edgesTableBody');
    if (container) {
        container.innerHTML = '';
        addNewEdgeRow('', ''); // Оставляем одну пустую строку
    }
}

// Загрузка дефолтных значений примера
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

    document.getElementById('hiddenEdgesInput').value = edgesString.trim();
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

    // Восстановление состояния: проверяем, прислал ли сервер данные назад
    const serverEdgesData = document.getElementById('serverEdgesData');
    let initialEdges = serverEdgesData ? serverEdgesData.getAttribute('data-edges').trim() : '';

    if (initialEdges) {
        const pairs = initialEdges.split('\n');
        pairs.forEach(pair => {
            const parts = pair.trim().split(/\s+/);
            if (parts.length === 2) {
                addNewEdgeRow(parts[0], parts[1]);
            }
        });
    } else {
        // Если страница открыта впервые, сразу генерируем красивый готовый пример
        loadDefaultTableExample();
    }
});
// Генерация примера двудольного графа
function generateExample() {
    document.getElementById('inputNLeft').value = '3';
    document.getElementById('inputNRight').value = '2';
    document.getElementById('inputEdges').value = '1 4\n1 5\n2 4\n3 5';
    document.getElementById('mainForm').submit();
}

// Сохранение графа в JSON
function saveToJSON() {
    const data = {
        n_left: parseInt(document.getElementById('inputNLeft').value),
        n_right: parseInt(document.getElementById('inputNRight').value),
        edges: document.getElementById('inputEdges').value.trim().split('\n').map(line => {
            const parts = line.trim().split(/\s+/);
            return [parseInt(parts[0]), parseInt(parts[1])];
        })
    };

    const jsonStr = JSON.stringify(data, null, 2);
    const blob = new Blob([jsonStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'vertex_cover_data.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

// Загрузка графа из JSON
function loadFromJSON(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function (e) {
        try {
            const data = JSON.parse(e.target.result);

            document.getElementById('inputNLeft').value = data.n_left || '';
            document.getElementById('inputNRight').value = data.n_right || '';

            let edgesStr = '';
            if (data.edges && Array.isArray(data.edges)) {
                edgesStr = data.edges.map(edge => edge[0] + ' ' + edge[1]).join('\n');
            }
            document.getElementById('inputEdges').value = edgesStr;

        } catch (error) {
            alert('Ошибка при загрузке JSON графа: ' + error.message);
        }
    };
    reader.readAsText(file);
}