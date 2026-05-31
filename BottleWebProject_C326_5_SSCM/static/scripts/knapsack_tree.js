// Элементы DOM формы и ввода
const mainForm = document.getElementById('mainForm');
const inputN = document.getElementById('inputN');
const inputW = document.getElementById('inputW');
const inputWeights = document.getElementById('inputWeights');
const inputValues = document.getElementById('inputValues');
const inputEdges = document.getElementById('inputEdges');

// Кнопки управления
const loadExampleBtn = document.getElementById('btn-load-example');
const saveJsonBtn = document.getElementById('btn-save-json');
const jsonFileInput = document.getElementById('jsonFileInput');
const printBtn = document.getElementById('btn-print');
const backBtn = document.getElementById('btn-back');

// Генерация примера
if (loadExampleBtn) {
    loadExampleBtn.onclick = () => {
        inputN.value = '5';
        inputW.value = '7';
        inputWeights.value = '2 3 1 2 1';
        inputValues.value = '10 20 5 5 100';
        inputEdges.value = '1 2\n1 3\n2 4\n2 5';
        mainForm.submit();
    };
}

// Сохранение в JSON
if (saveJsonBtn) {
    saveJsonBtn.onclick = () => {
        const data = {
            n: parseInt(inputN.value),
            W: parseInt(inputW.value),
            weights: inputWeights.value.split(' ').map(Number),
            values: inputValues.value.split(' ').map(Number),
            edges: inputEdges.value.trim().split('\n').map(line => {
                const parts = line.trim().split(' ');
                return [parseInt(parts[0]), parseInt(parts[1])];
            })
        };

        const jsonStr = JSON.stringify(data, null, 2);
        const blob = new Blob([jsonStr], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'knapsack_data.json';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    };
}

// Загрузка из JSON
if (jsonFileInput) {
    jsonFileInput.onchange = (event) => {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();
        reader.onload = function (e) {
            try {
                const data = JSON.parse(e.target.result);

                inputN.value = data.n || '';
                inputW.value = data.W || '';
                inputWeights.value = data.weights ? data.weights.join(' ') : '';
                inputValues.value = data.values ? data.values.join(' ') : '';

                let edgesStr = '';
                if (data.edges && Array.isArray(data.edges)) {
                    edgesStr = data.edges.map(edge => edge[0] + ' ' + edge[1]).join('\n');
                }
                inputEdges.value = edgesStr;

            } catch (error) {
                alert('Ошибка при загрузке JSON: ' + error.message);
            }
        };
        reader.readAsText(file);
    };
}

// Печать страницы
if (printBtn) {
    printBtn.onclick = () => window.print();
}

// Шаг назад в истории браузера
if (backBtn) {
    backBtn.onclick = (e) => {
        e.preventDefault();
        window.history.back();
    };
}