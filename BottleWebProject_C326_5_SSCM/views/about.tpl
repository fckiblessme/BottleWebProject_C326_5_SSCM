% rebase('layout.tpl', title='Разработчики', year=year)

<div class="container">
    <!-- Заголовок как на страницах задач -->
    <div class="header">
        <h1>Разработчики</h1>
        <p>Команда, работавшая над проектом</p>
    </div>

    <!-- Секция с командой -->
    <div class="section">
        <h2>Над сайтом работали</h2>
        
        <div class="team-grid">
            <div class="team-card">
                <div class="team-avatar avatar-1">СД</div>
                <div class="team-info">
                    <h3>Скрыпникова Дарья</h3>
                    <p class="team-role">ФСПО ГУАП</p>
                    <p class="team-text">Разработка страниц: задача коммивояжёра, страница о разработчиках</p>
                    <a href="https://vk.com/d_skry" target="_blank" class="team-link">ВКонтакте →</a>
                </div>
            </div>

            <div class="team-card">
                <div class="team-avatar avatar-2">СВ</div>
                <div class="team-info">
                    <h3>Стрельцова Виктория</h3>
                    <p class="team-role">ФСПО ГУАП</p>
                    <p class="team-text">Разработка страниц: задача на минимальное вершинное покрытие</p>
                    <a href="https://vk.com/fckiblessme" target="_blank" class="team-link">ВКонтакте →</a>
                </div>
            </div>

            <div class="team-card">
                <div class="team-avatar avatar-3">ЧП</div>
                <div class="team-info">
                    <h3>Чемякина Полина</h3>
                    <p class="team-role">ФСПО ГУАП</p>
                    <p class="team-text">Разработка страниц: задача на разбиение графа на компоненты сильной связности, главная страница</p>
                    <a href="https://vk.com/pllood" target="_blank" class="team-link">ВКонтакте →</a>
                </div>
            </div>

            <div class="team-card">
                <div class="team-avatar avatar-4">МГ</div>
                <div class="team-info">
                    <h3>Мироненко Георгий</h3>
                    <p class="team-role">ФСПО ГУАП</p>
                    <p class="team-text">Разработка страниц: задача о рюкзаке на дереве</p>
                    <a href="https://vk.com/d_skry" target="_blank" class="team-link">ВКонтакте →</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Секция с палитрой -->
    <div class="section">
        <h2>Оформление сайта</h2>
        <p class="about-intro">При разработке дизайна мы стремились к чистому и современному виду, который не отвлекает от содержания.</p>
        
        <h3>Цветовая палитра:</h3>
        
        <div class="palette-grid">
            <div class="palette-card">
                <div class="palette-swatch palette-dark"></div>
                <div class="palette-info">
                    <h4>#41444B</h4>
                    <p>Основной цвет для шапки сайта, подвала и важных акцентов</p>
                </div>
            </div>

            <div class="palette-card">
                <div class="palette-swatch palette-dark1"></div>
                <div class="palette-info">
                    <h4>#52575D</h4>
                    <p>Второстепенный цвет текста и фона кнопок</p>
                </div>
            </div>

            <div class="palette-card">
                <div class="palette-swatch palette-light"></div>
                <div class="palette-info">
                    <h4>#DFD8C8</h4>
                    <p>Основной фоновый цвет страницы</p>
                </div>
            </div>

            <div class="palette-card">
                <div class="palette-swatch palette-accent"></div>
                <div class="palette-info">
                    <h4>#CABFAB</h4>
                    <p>Акцентный цвет для рамок и выделения элементов</p>
                </div>
            </div>
        </div>
    </div>

    <div class="nav-links">
        <a href="/" class="nav-btn">Домой</a>
        <button onclick="window.print();" class="nav-btn">Печать</button>
        <a href="#" onclick="window.history.back(); return false;" class="nav-btn">Назад</a>
    </div>
</div>