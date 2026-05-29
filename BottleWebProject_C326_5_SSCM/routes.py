from bottle import route, template

@route('/')
def index():
    return template('index.tpl', title='Главная', year=2026)

@route('/about')
def about():
    return template('about.tpl', title='О нас', year=2026)

@route('/tsp')
def tsp():
    return template('tsp_form.tpl', title='Задача коммивояжёра', year=2026)

@route('/vertex_cover')
def vertex_cover():
    return template('vertex_cover.tpl', title='Вершинное покрытие', year=2026)

@route('/kos')
def kos():
    return template('kos_form.tpl', title='Компоненты сильной связности', year=2026)

@route('/tree_knapsack')
def tree_knapsack():
    return template('tree_knapsack.tpl', title='Рюкзак на дереве', year=2026)