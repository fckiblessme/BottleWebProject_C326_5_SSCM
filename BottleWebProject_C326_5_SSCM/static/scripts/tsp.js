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



