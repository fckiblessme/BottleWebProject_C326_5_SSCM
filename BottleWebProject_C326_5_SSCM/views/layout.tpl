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
            <div class="header-content-custom" style="display: flex; flex-direction: column; width: 100%; padding-right: 195px !important;">
                <div style="display: flex; justify-content: space-between; align-items: center; width: 100%; flex-wrap: wrap; margin-bottom: 0px !important;">
                    <div class="logo" style="text-align: left !important; flex: 0 0 auto; margin-right: 20px;">
                        <h1 style="margin: 0 !important; padding: 0 !important; text-align: left !important; line-height: 1.2; display: block;">
                            <a href="/">Разбор Алгоритмов</a>
                        </h1>
                    </div>
                    <div style="flex-grow: 1; max-width: calc(100% - 250px); display: flex; justify-content: flex-end;">
                        <nav class="nav">
                            <ul style="display: flex; list-style: none; margin: 0 !important; padding: 0 !important; gap: 12px; justify-content: flex-end;">
                                <li style="margin-bottom: 0 !important; margin-left: 0 !important; margin-right: 0 !important;"><a href="/home" id="nav-home">Главная</a></li>
                                <li style="margin-bottom: 0 !important; margin-right: 0 !important;"><a href="/about" id="nav-about">О нас</a></li>
                            </ul>
                        </nav>
                    </div>
                    
                </div>
                
                <hr style="margin: 12px 0; border: 0; border-top: 1px solid rgba(255,255,255,0.1); opacity: 0.2;">
                <div style="display: flex; justify-content: flex-end; padding: 0; margin-top: 0; width: 100%;">
                    <nav class="nav">
                        <ul style="display: flex; list-style: none; margin: 0 !important; padding: 0 !important; gap: 10px; flex-wrap: wrap; justify-content: flex-end;">
                            <li style="margin-bottom: 0 !important; margin-right: 0 !important;"><a href="/tsp_form" id="nav-tsp">Задача коммивояжёра</a></li>
                            <li style="margin-bottom: 0 !important; margin-right: 0 !important;"><a href="/vertex_cover" id="nav-vc">Вершинное покрытие</a></li>
                            <li style="margin-bottom: 0 !important; margin-right: 0 !important;"><a href="/kos" id="nav-kos">Компоненты связности</a></li>
                            <li style="margin-bottom: 0 !important; margin-right: 0 !important;"><a href="/knapsack_tree" id="nav-ks">Рюкзак на дереве</a></li>
                        </ul>
                    </nav>
                </div>
                
            </div> 
        </div> 
        
        <div class="body-content" style="margin-top: 20px;">
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