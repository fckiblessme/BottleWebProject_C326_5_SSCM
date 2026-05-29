<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }} - Математическое моделирование</title>
    <!-- Подключаем только свой style.css -->
    <link rel="stylesheet" type="text/css" href="/static/content/style.css" />
</head>

<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <a href="/"><h1>Математическое моделирование</h1></a>
                </div>
                <nav class="nav">
                    <ul>
                        <li><a href="/" class="{{'active' if title == 'Главная' else ''}}">Главная</a></li>
                        <li><a href="/tsp">Задача коммивояжёра</a></li>
                        <li><a href="/vertex_cover">Вершинное покрытие</a></li>
                        <li><a href="/kos">Компоненты связности</a></li>
                        <li><a href="/tree_knapsack">Рюкзак на дереве</a></li>
                        <li><a href="/about" {{'class=active' if title=='О нас' else ''}}>О нас</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </header>

    <main class="container body-content">
        {{!base}}
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; {{ year or 2026 }} - Математическое моделирование</p>
            <div class="footer-links">
                <a href="https://bottlepy.org" target="_blank">Bottle</a> |
                <a href="https://docs.python.org/3/" target="_blank">Python Docs</a> |
                <a href="https://github.com" target="_blank">GitHub</a>
            </div>
        </div>
    </footer>
</body>
</html>