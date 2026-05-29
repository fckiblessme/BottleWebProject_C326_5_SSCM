% rebase('layout.tpl', title='Главная', year=year)

<!-- ШАПКА САЙТА -->
<div class="hero">
    <h1>Математическое моделирование</h1>
    <p class="hero-text">
        Решение классических задач дискретной математики и теории графов.
        Задача коммивояжёра, минимальное вершинное покрытие, компоненты сильной связности,
        задача о рюкзаке на дереве.
    </p>
    <div class="hero-buttons">
        <a href="/tasks" class="btn">
            Все задачи
        </a>
        <a href="/about" class="btn btn-secondary">
            Об авторах
        </a>
    </div>
</div>

<!-- ВСЕ ЗАДАЧИ -->
<h2 class="section-title">Решаемые задачи</h2>
<div class="disciplines-grid">
    
    <a href="/tsp" class="discipline-card">
        <img src="/static/images/graph.jpg" alt="Задача коммивояжёра" class="discipline-image">
        <h3>Задача коммивояжёра (TSP)</h3>
        <p>Поиск гамильтонова цикла минимального веса. Количество вершин ≤ 12</p>
        <span class="card-link">Решить →</span>
    </a>
    
    <a href="/vertex-cover" class="discipline-card">
        <img src="/static/images/bipartite.jpg" alt="Минимальное вершинное покрытие" class="discipline-image">
        <h3>Минимальное вершинное покрытие</h3>
        <p>Для двудольного графа. Теорема Кёнига, максимальное паросочетание</p>
        <span class="card-link">Решить →</span>
    </a>
    
    <a href="/strong-components" class="discipline-card">
        <img src="/static/images/digraph.jpg" alt="Компоненты сильной связности" class="discipline-image">
        <h3>Компоненты сильной связности</h3>
        <p>Разбиение ориентированного графа на компоненты. Алгоритм Косарайю</p>
        <span class="card-link">Решить →</span>
    </a>
    
    <a href="/knapsack-tree" class="discipline-card">
        <img src="/static/images/tree.jpg" alt="Рюкзак на дереве" class="discipline-image">
        <h3>Задача о рюкзаке на дереве</h3>
        <p>Выбор поддерева с суммарным весом не более W. N≤50, M≤100</p>
        <span class="card-link">Решить →</span>
    </a>
    
</div>

<!-- О ПРОЕКТЕ -->
<div class="facts-section">
    <h2 class="section-title">О проекте</h2>
    <div class="facts-grid">
        <div class="fact-card">
            <div class="fact-number">Bottle</div>
            <h3>Веб-фреймворк</h3>
            <p>Лёгкий и быстрый фреймворк для создания веб-приложений на Python</p>
        </div>
        
        <div class="fact-card">
            <div class="fact-number">Python 3.7+</div>
            <h3>Язык реализации</h3>
            <p>Современный Python с использованием стандартных алгоритмов</p>
        </div>
        
        <div class="fact-card">
            <div class="fact-number">JSON</div>
            <h3>Сохранение истории</h3>
            <p>Все вычисления сохраняются с датой и временем выполнения</p>
        </div>
        
        <div class="fact-card">
            <div class="fact-number">Валидация</div>
            <h3>Проверка данных</h3>
            <p>Автоматическая проверка типов, диапазонов и пустых полей</p>
        </div>
    </div>
</div>

<!-- ТЕОРЕТИЧЕСКАЯ ИНФОРМАЦИЯ -->
<div class="news-section">
    <h2 class="section-title">Теоретическая информация</h2>
    <div class="news-grid">
        <div class="news-card">
            <span class="news-date">Задача коммивояжёра</span>
            <h3>Гамильтонов цикл минимального веса</h3>
            <p>Классическая NP-трудная задача. Решается методом полного перебора с отсечениями для графов до 12 вершин.</p>
            <a href="/tsp#theory">Подробнее →</a>
        </div>
        
        <div class="news-card">
            <span class="news-date">Теорема Кёнига</span>
            <h3>Минимальное вершинное покрытие</h3>
            <p>В двудольном графе размер минимального вершинного покрытия равен размеру максимального паросочетания.</p>
            <a href="/vertex-cover#theory">Подробнее →</a>
        </div>
        
        <div class="news-card">
            <span class="news-date">Алгоритм Косарайю</span>
            <h3>Компоненты сильной связности</h3>
            <p>Двупроходный алгоритм на основе поиска в глубину для ориентированных графов.</p>
            <a href="/strong-components#theory">Подробнее →</a>
        </div>
        
        <div class="news-card">
            <span class="news-date">Динамическое программирование</span>
            <h3>Рюкзак на дереве</h3>
            <p>Решение методом ДП на дереве. Максимизация ценности при ограничении на суммарный вес.</p>
            <a href="/knapsack-tree#theory">Подробнее →</a>
        </div>
    </div>
</div>

<!-- ПОЛЕЗНЫЕ ССЫЛКИ -->
<div class="links-section">
    <h2 class="section-title">Полезные ресурсы</h2>
    <div class="links-grid">
        <a href="https://bottlepy.org" target="_blank" class="link-card">
            <span class="link-text">Bottle Framework</span>
            <span class="link-desc">Официальная документация веб-фреймворка</span>
        </a>
        
        <a href="https://docs.python.org/3/" target="_blank" class="link-card">
            <span class="link-text">Python Docs</span>
            <span class="link-desc">Документация по языку Python</span>
        </a>
        
        <a href="https://github.com" target="_blank" class="link-card">
            <span class="link-text">GitHub</span>
            <span class="link-desc">Репозиторий проекта и система контроля версий</span>
        </a>
    </div>
</div>