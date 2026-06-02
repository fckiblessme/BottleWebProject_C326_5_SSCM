function syncMatrix(i, j) {
    var source = document.getElementById('m' + i + j);
    var target = document.getElementById('m' + j + i);
    if (target && source) {
        target.value = source.value;
    }
}

function highlightPair(i, j) {
    var cell1 = document.getElementById('m' + i + j);
    var cell2 = document.getElementById('m' + j + i);
    if (cell1) {
        cell1.style.backgroundColor = '#fff3cd';
        cell1.style.borderColor = '#ffc107';
    }
    if (cell2) {
        cell2.style.backgroundColor = '#fff3cd';
        cell2.style.borderColor = '#ffc107';
    }
}

function unhighlightPair(i, j) {
    var cell1 = document.getElementById('m' + i + j);
    var cell2 = document.getElementById('m' + j + i);
    if (cell1) {
        cell1.style.backgroundColor = '';
        cell1.style.borderColor = '';
    }
    if (cell2) {
        cell2.style.backgroundColor = '';
        cell2.style.borderColor = '';
    }
}

let networkInstance = null;

function drawTSPGraph(matrix, bestRoute) {

    const graphContainer = document.getElementById('network-graph');

    if (!graphContainer) return;

    const cityCount = matrix.length;

    const nodesArray = [];
    const edgesArray = [];

    const selectedEdges = new Set();

    for (let i = 0; i < bestRoute.length - 1; i++) {
        const a = bestRoute[i];
        const b = bestRoute[i + 1];
        selectedEdges.add(a + "_" + b);
        selectedEdges.add(b + "_" + a);
    }

    for (let i = 1; i <= cityCount; i++) {
        nodesArray.push({
            id: i,
            label: String(i),
            color: {
                background: '#41444B',
                border: '#41444B',
                highlight: {
                    background: '#41444B',
                    border: '#DC3545'
                },
                hover: {
                    background: '#41444B',
                    border: '#41444B'
                }
            },
            shape: 'circle',
            font: {
                size: 14,
                color: '#DCD5C5',
                face: 'monospace',
                bold: true
            }
        });
    }

    for (let i = 0; i < cityCount; i++) {
        for (let j = i + 1; j < cityCount; j++) {
            const from = i + 1;
            const to = j + 1;
            const routeEdge = selectedEdges.has(from + "_" + to);

            edgesArray.push({
                from: from,
                to: to,
                label: String(matrix[i][j]),
                width: routeEdge ? 4 : 2,
                color: {
                    color: routeEdge ? '#dc3545' : '#848484'
                }
            });
        }
    }

    const data = {
        nodes: new vis.DataSet(nodesArray),
        edges: new vis.DataSet(edgesArray)
    };

    const options = {
        physics: {
            enabled: true,
            stabilization: true
        },
        interaction: {
            hover: true
        }
    };

    if (networkInstance) {
        networkInstance.destroy();
    }

    networkInstance = new vis.Network(graphContainer, data, options);
}

document.addEventListener("DOMContentLoaded", function () {

    var errorBlock = document.getElementById('errorBlock');
    var resultPlaceholder = document.querySelector('.result-placeholder');
    var form = document.getElementById('inputForm');


    if (errorBlock && errorBlock.style.display !== 'none' && errorBlock.innerHTML.trim() !== '') {
        setTimeout(function () {
            if (form) {
                form.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }, 100);
    }

    else if (resultPlaceholder && resultPlaceholder.innerHTML.trim() !== '') {
        var text = resultPlaceholder.innerHTML;
        var hasRealResult =
            text.indexOf('tsp-paths-list') !== -1 ||
            text.indexOf('tsp-path-row') !== -1;

        if (hasRealResult) {
            var resultCard = document.querySelector('.result-card');
            if (resultCard) {
                setTimeout(function () {
                    resultCard.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }, 300);
            }
        }
    }


    const serverData = document.getElementById("serverTspData");

    if (!serverData) {
        return;
    }

    const routeRaw = serverData.dataset.route;

    if (!routeRaw) {
        return;
    }

    const bestRoute = JSON.parse(routeRaw.replace(/'/g, '"'));

    const matrix = [];

    const rows = document.querySelectorAll(".matrix-table tbody tr");

    rows.forEach(row => {
        const currentRow = [];
        const inputs = row.querySelectorAll("input");

        inputs.forEach(input => {
            currentRow.push(parseInt(input.value) || 0);
        });

        matrix.push(currentRow);
    });

    drawTSPGraph(matrix, bestRoute);
});


function saveResultToFile() {
    var matrixData = document.querySelector('input[name="matrix_data"]');
    var routeData = document.querySelector('input[name="route_data"]');
    var bestDistanceData = document.querySelector('input[name="best_distance_data"]');

    if (!matrixData || !routeData || !bestDistanceData) {
        return;
    }

    var formData = new FormData();
    formData.append('save', '1');
    formData.append('matrix_data', matrixData.value);
    formData.append('route_data', routeData.value);
    formData.append('best_distance_data', bestDistanceData.value);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/tsp', true);

    xhr.onload = function () {
        if (xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);

            if (response.success) {
                var saveMsg = document.getElementById('saveSuccessMsg');
                if (saveMsg) {
                    saveMsg.style.display = 'block';
                    setTimeout(function () {
                        saveMsg.style.display = 'none';
                    }, 3000);
                }
            }
        }
    };

    xhr.send(formData);
}
