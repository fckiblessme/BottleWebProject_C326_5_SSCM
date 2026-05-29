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