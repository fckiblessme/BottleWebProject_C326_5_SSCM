% rebase('layout.tpl', title='Главная', year=year)

<div class="hero">
    <h1>Исследование NP-трудных задач<sup><a href="#np-footnote" class="footnote-ref">1</a></sup> на графах</h1>
    <p class="hero-text">
        Данный программный комплекс предназначен для ознакомления, тестирования и анализа эффективных методов решения комбинаторных задач высокой сложности, возникающих при проектировании сетей, логистике и оптимизации структур данных.
    </p>
</div>

<div class="section">
    <h2>Доступные методы и алгоритмы</h2>
    
    <div class="disciplines-grid">
        <a href="/tsp_form" class="discipline-card">
            <div class="card-icon">🚗</div>
            <h3>Задача коммивояжёра</h3>
            <p>Поиск кратчайшего гамильтонова цикла в полном графе. Реализация точного решения методами перебора и оптимизации маршрутов.</p>
            <span class="card-link">Перейти к решению &rarr;</span>
        </a>

        <a href="/vertex_cover" class="discipline-cover">
            <div class="card-icon">🕸️</div>
            <h3>Вершинное покрытие</h3>
            <p>Поиск минимального множества вершин, подменяющего все ребра графа. Метод ветвей и границ для поиска точного подмножества.</p>
            <span class="card-link">Перейти к решению &rarr;</span>
        </a>

        <a href="/kos" class="discipline-card">
            <div class="card-icon">🔄</div>
            <h3>Компоненты сильной связности</h3>
            <p>Разбиение ориентированного графа на компоненты, где из любой вершины можно достичь любую другую. Алгоритм Косарайю.</p>
            <span class="card-link">Перейти к решению &rarr;</span>
        </a>

        <a href="/knapsack_tree" class="discipline-card">
            <div class="card-icon">🌳</div>
            <h3>Рюкзак на дереве</h3>
            <p>Оптимизация выбора связанных элементов с древовидной зависимостью. Динамическое программирование на иерархических структурах.</p>
            <span class="card-link">Перейти к решению &rarr;</span>
        </a>
    </div>

    <div id="np-footnote" style="margin-top: 25px; padding-top: 15px; border-top: 1px dashed var(--accent); scroll-margin-top: 20px;">
        <span class="small-text" style="font-size: 14px; line-height: 1.5; color: var(--text-dark);">
            <strong style="color: var(--text-darker);">1.</strong> <strong>Что такое NP-трудные задачи?</strong> Это класс сложнейших вычислительных задач, для которых на данный момент не существует быстрого (полиномиального) алгоритма решения. Время их точного вычисления растет катастрофически быстро (экспоненциально) с увеличением объема входных данных, из-за чего для больших графов часто приходится применять приближенные методы или эвристики.
        </span>
    </div>
</div>