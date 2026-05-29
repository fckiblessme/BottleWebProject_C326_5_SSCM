document.addEventListener("DOMContentLoaded", function () {
    const currentPath = window.location.pathname;
    document.querySelectorAll('.nav a').forEach(el => el.classList.remove('active'));

    // Логика автоматической подсветки активной вкладки
    if (currentPath.includes('tsp_form')) {
        document.getElementById('nav-tsp')?.classList.add('active');
    } else if (currentPath.includes('vertex_cover')) {
        document.getElementById('nav-vc')?.classList.add('active');
    } else if (currentPath.includes('knapsack_tree')) {
        document.getElementById('nav-ks')?.classList.add('active');
    } else if (currentPath.includes('about')) {
        document.getElementById('nav-about')?.classList.add('active');
    } else if (currentPath === '/' || currentPath.includes('home')) {
        document.getElementById('nav-home')?.classList.add('active');
    }
});