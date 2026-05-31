// Элементы DOM
const edgesContainer = document.getElementById('edges-list');
const addEdgeBtn = document.getElementById('add-edge');
const vertexCountInput = document.getElementById('vertex-count');
const solveBtn = document.getElementById('btn-solve');
const clearBtn = document.getElementById('btn-clear');
const generateBtn = document.getElementById('btn-generate');
const fileInput = document.getElementById('file-input');
const saveResultBtn = document.getElementById('btn-save-result');
const resultContent = document.getElementById('result-content');
const messageSection = document.getElementById('message-section');
const errorMessage = document.getElementById('error-message');
const successMessage = document.getElementById('success-message');
const errorText = document.getElementById('error-text');
const successText = document.getElementById('success-text');
const closeErrorBtn = document.getElementById('btn-close-error');
const closeSuccessBtn = document.getElementById('btn-close-success');
const printBtn = document.getElementById('btn-print');
const backBtn = document.getElementById('btn-back');

let currentResult = null;

// Добавление строки ребра
function addEdgeRow(from = '', to = '') {
    const row = document.createElement('div');
    row.className = 'edge-row';
    row.innerHTML = `
        <input type="number" class="edge-from" placeholder="От" min="1" value="${from}">
        <span>→</span>
        <input type="number" class="edge-to" placeholder="До" min="1" value="${to}">
        <button class="btn-remove-edge">✕</button>
    `;
    edgesContainer.appendChild(row);
    updateRemoveButtons();
}

// Обновление кнопок удаления
function updateRemoveButtons() {
    const rows = document.querySelectorAll('.edge-row');
    rows.forEach((row, index) => {
        const btn = row.querySelector('.btn-remove-edge');
        if (index === 0) {
            btn.disabled = true;
        } else {
            btn.disabled = false;
            btn.onclick = () => row.remove();
        }
    });
}

// Получение всех рёбер
function getEdges() {
    const edges = [];
    const rows = document.querySelectorAll('.edge-row');
    for (const row of rows) {
        const from = parseInt(row.querySelector('.edge-from').value);
        const to = parseInt(row.querySelector('.edge-to').value);
        if (from && to && !isNaN(from) && !isNaN(to) && from !== to) {
            edges.push([from, to]);
        }
    }
    return edges;
}

// Установка рёбер
function setEdges(edges) {
    while (edgesContainer.children.length > 1) {
        edgesContainer.removeChild(edgesContainer.lastChild);
    }
    if (edges.length > 0) {
        const firstRow = edgesContainer.children[0];
        firstRow.querySelector('.edge-from').value = edges[0][0];
        firstRow.querySelector('.edge-to').value = edges[0][1];
    }
    for (let i = 1; i < edges.length; i++) {
        addEdgeRow(edges[i][0], edges[i][1]);
    }
}

// Показать сообщение
function showMessage(type, text) {
    messageSection.style.display = 'block';
    if (type === 'error') {
        errorMessage.style.display = 'flex';
        successMessage.style.display = 'none';
        errorText.textContent = text;
    } else {
        errorMessage.style.display = 'none';
        successMessage.style.display = 'flex';
        successText.textContent = text;
    }
    setTimeout(() => {
        messageSection.style.display = 'none';
    }, 4000);
}

function closeMessage() {
    messageSection.style.display = 'none';
}

// Назначение обработчиков событий закрытия уведомлений
if (closeErrorBtn) closeErrorBtn.onclick = closeMessage;
if (closeSuccessBtn) closeSuccessBtn.onclick = closeMessage;

// Генерация случайного графа
generateBtn.onclick = async () => {
    const n = parseInt(vertexCountInput.value);
    if (isNaN(n) || n < 1 || n > 50) {
        showMessage('error', 'Введите корректное количество вершин (1-50)');
        return;
    }

    try {
        const response = await fetch('/api/kos/generate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ n: n })
        });
        const data = await response.json();
        if (data.error) {
            showMessage('error', data.error);
        } else {
            setEdges(data.edges);
            showMessage('success', 'Сгенерирован случайный граф');
        }
    } catch (e) {
        showMessage('error', 'Ошибка генерации');
    }
};

// Загрузка из файла
fileInput.onchange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append('file', file);

    try {
        const response = await fetch('/api/kos/upload', {
            method: 'POST',
            body: formData
        });
        const data = await response.json();
        if (data.error) {
            showMessage('error', data.error);
        } else {
            vertexCountInput.value = data.n;
            setEdges(data.edges);
            showMessage('success', 'Данные загружены');
        }
    } catch (e) {
        showMessage('error', 'Ошибка загрузки файла');
    }
    fileInput.value = '';
};

// Очистка формы
clearBtn.onclick = () => {
    vertexCountInput.value = '6';
    while (edgesContainer.children.length > 1) {
        edgesContainer.removeChild(edgesContainer.lastChild);
    }
    const firstRow = edgesContainer.children[0];
    firstRow.querySelector('.edge-from').value = '1';
    firstRow.querySelector('.edge-to').value = '2';
    resultContent.innerHTML = `
        <span class="result-icon">ℹ</span>
        <p>Здесь появится результат после нажатия кнопки «Решить задачу»</p>
    `;
    saveResultBtn.style.display = 'none';
    currentResult = null;
    showMessage('success', 'Форма очищена');
};

// Решение задачи (алгоритм Косарайю)
solveBtn.onclick = async () => {
    const n = parseInt(vertexCountInput.value);
    const edges = getEdges();

    if (isNaN(n) || n < 1 || n > 50) {
        showMessage('error', 'Введите корректное количество вершин (1-50)');
        return;
    }

    if (edges.length === 0) {
        showMessage('error', 'Добавьте хотя бы одно ребро');
        return;
    }

    try {
        const response = await fetch('/api/kos/solve', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ n: n, edges: edges })
        });
        const data = await response.json();

        if (data.error) {
            resultContent.innerHTML = `
                <span class="result-icon">❌</span>
                <p>Ошибка: ${data.error}</p>
            `;
            showMessage('error', data.error);
        } else {
            let componentsHtml = '';
            data.components.forEach((comp, idx) => {
                const size = comp.length;
                const vertexList = comp.sort((a, b) => a - b).join(', ');
                componentsHtml += `<p><strong>Компонента ${idx + 1} (${size} вершины):</strong> ${vertexList}</p>`;
            });

            resultContent.innerHTML = `
                <div class="result-success">
                    <p><strong>Найдено компонент сильной связности: ${data.count}</strong></p>
                    ${componentsHtml}
                </div>
            `;
            currentResult = data;
            saveResultBtn.style.display = 'inline-block';
            showMessage('success', 'Задача решена');
        }
    } catch (e) {
        resultContent.innerHTML = `
            <span class="result-icon">❌</span>
            <p>Ошибка сервера</p>
        `;
        showMessage('error', 'Ошибка сервера');
    }
};

// Сохранение результата
saveResultBtn.onclick = async () => {
    if (!currentResult) return;

    try {
        const response = await fetch('/api/kos/save', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(currentResult)
        });
        const data = await response.json();
        if (data.error) {
            showMessage('error', data.error);
        } else {
            showMessage('success', 'Результат сохранён');
        }
    } catch (e) {
        showMessage('error', 'Ошибка сохранения');
    }
};

// Кнопки навигации и печати
if (printBtn) {
    printBtn.onclick = () => window.print();
}

if (backBtn) {
    backBtn.onclick = (e) => {
        e.preventDefault();
        window.history.back();
    };
}

// Добавление ребра
addEdgeBtn.onclick = () => addEdgeRow();

// Инициализация при загрузке
updateRemoveButtons();