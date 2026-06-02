def solve_vertex_cover_algorithm(U, V, E):
    """
    Поиск минимального вершинного покрытия в двудольном графе (Теорема Кёнига, алгоритм Куна).
    """
    # 1. Построение списков смежности Adj[u] для вершин левой доли
    """ 
    для каждой вершины из левой доли создается список вершин 
    из правой доли, с которыми она соединена ребром
    """
    Adj = {u: [] for u in U}
    for u, v in E:
        if u in Adj and v in V:
            Adj[u].append(v)

    # matchR - хранит текущее соответствие для вершин правой доли V.
    """
    ключ - вершина из правой доли, значение - вершина из левой
    доли, которая сейчас с ней в паре
    """
    matchR = {v: None for v in V}
    
    # Алгоритм Куна для поиска увеличивающей цепи
    """
    used - хранит информацию о том, посещали ли мы вершину левой доли
    в текущей итерации
    """
    def dfs_kuhn(u, used):
        if used.get(u, False):
            return False
        used[u] = True
        for v in Adj[u]:
            if matchR[v] is None or dfs_kuhn(matchR[v], used):
                matchR[v] = u
                return True
        return False

    # Находим максимальное паросочетание с помощью алгоритма Куна
    matchingSize = 0
    for u in U:
        used = {}
        if dfs_kuhn(u, used):
            matchingSize += 1

    # matchL - обратное соответствие для левой доли
    matchL = {u: None for u in U}
    for v, u_partner in matchR.items():
        if u_partner is not None:
            matchL[u_partner] = v

    # Флаги разметки посещаемости для построения покрытия
    visitedLeft = {u: False for u in U}
    visitedRight = {v: False for v in V}

    # Построение покрытия
    def dfs_cover(u):
        if visitedLeft[u]:
            return
        visitedLeft[u] = True
        for v in Adj[u]:
            if matchL[u] != v:
                if not visitedRight[v]:
                    visitedRight[v] = True
                    if matchR[v] is not None:
                        dfs_cover(matchR[v])

    # Запускаем обход от всех ненасыщенных вершин левой доли графа
    for u in U:
        if matchL[u] is None:
            dfs_cover(u)

    # Согласно теореме Кёнига, собираем вершины в минимальное покрытие
    Cover = []
    for u in U:
        if not visitedLeft[u]:
            Cover.append(u)
    for v in V:
        if visitedRight[v]:
            Cover.append(v)

    Cover.sort()

    # Формирование логов работы алгоритма
    log_lines = [
        f"Найдено максимальное паросочетание размера: {matchingSize}"
    ]
    
    for v, u_partner in matchR.items():
        if u_partner is not None:
            log_lines.append(f"  Ребро паросочетания: L:{u_partner} <-> R:{v}")
            
    log_lines.append("\nРезультат разметки достижимости вершин:")
    log_lines.append(f"  visitedLeft (L): {[u for u in U if visitedLeft[u]]}")
    log_lines.append(f"  visitedRight (R): {[v for v in V if visitedRight[v]]}")
    
    matching_html = "\n".join(log_lines)

    return matchingSize, len(Cover), Cover, matching_html