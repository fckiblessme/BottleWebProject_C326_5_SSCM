<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }} - My Bottle Application</title>
    <link rel="stylesheet" type="text/css" href="/static/content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="/static/content/style.css" />
    <script src="/static/scripts/modernizr-2.6.2.js"></script>
</head>

<body>
    <div class="container">
        <div class="header">
            <div class="header-content">
                <div class="logo">
                    <h1><a href="/">Разбор Алгоритмов</a></h1>
                </div>
                
                <nav class="nav">
                    <ul>
                        <li><a href="/home" id="nav-home">Главная</a></li>
                        <li><a href="/tsp_form" id="nav-tsp">Задача коммивояжёра</a></li>
                        <li><a href="/vertex_cover" id="nav-vc">Вершинное покрытие</a></li>
                        <li><a href="/kos" id="nav-kos">Компоненты связности</a></li>
                        <li><a href="/knapsack_tree" id="nav-ks">Рюкзак на дереве</a></li>
                        <li><a href="/about" id="nav-about">О программе</a></li>
                    </ul>
                </nav>
            </div>
        </div>

        <div class="body-content">
            {{!base}}
        </div>
        
        <footer class="footer">
            <p>&copy; {{ year }} - My Bottle Application</p>
        </footer>
    </div>

    <script src="/static/scripts/jquery-1.10.2.js"></script>
    <script src="/static/scripts/bootstrap.js"></script>
    <script src="/static/scripts/respond.js"></script>
    <script src="/static/scripts/navigation.js"></script>
</body>
</html>