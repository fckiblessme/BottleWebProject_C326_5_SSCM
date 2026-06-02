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

