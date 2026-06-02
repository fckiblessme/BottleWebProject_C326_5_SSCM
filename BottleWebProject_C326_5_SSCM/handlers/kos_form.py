from bottle import route, request, redirect, template
import json
from datetime import datetime
import os

def kosaraju(G, n):

#Построение транспонированной матрицы
    GT = [[0] * n for _ in range(n)]
    for u in range(n):
        for v in range(n):
            if G[u][v] == 1:
                GT[v][u] = 1

#Первый обход DFS1
    visited = [False] * n
    stack = []

    def dfs1(v):
        visited[v] = True 
        for u in range(n):
            if G[v][u] == 1 and not visited[u]:
                dfs1(u)
        stack.append(v)

    for v in range(n):
        if not visited[v]:
            dfs1(v)

    visited = [False] * n
    components = []
    count = 0

    def dfs2(v, current_component):
        visited[v] = True
        current_component.append(v + 1)
        for u in range(n):
            if GT[v][u] == 1 and not visited[u]:
                dfs2(u, current_component)

    while stack:
        v = stack.pop()
        if not visited[v]:
            count += 1
            current_component = []
            dfs2(v, current_component)
            components.append(current_component)

    return count, components

def safe_json(n, G, result_count, result_components, input_filename = None):
    #Задаем имя файла и время
    timestamp = datetime.now()
    filename = "kos_result.json"
    
    #Формирование данных для сохранения
    data = {
        "Время": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "Ввод": {
            "N": n,
            "G": G 
            },
        "Вывод": {
            "count": result_count,
            "components": result_components
            }
        }

    #Сохранение информации о данных, если были загружены из файла
    if input_filename:
        data["source_file"] = input_filename

    #Сохранение в файл
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    return filename
 
def g_from_form(g_text, n):
    G = [[0] * n for _ in range(n)]
    rows = g_text.strip().split('\n')
    for u in range(n):
        values = rows[u].strip().split()
        for v in range(n):
            try:
                val = int(values[v])
                if val == 1:
                    G[u][v] = 1
            except ValueError:
                        pass
    return G

def validate_G(G, n):
    if len(G) != n:
        return False, f"Размер матрицы {len(G)}x{len(G)} не соответствует n = {n}"
    for u in range(n):
        if len(G[u]) != n:
            return False, f"Строка {u+1} имеет неверную длину"
        
        for v in range(n):
            if u == v and G[u][v] != 0:
                return False, f"Элемент на диагонали [{u+1}][{u+1}] должен быть 0"
            if G[u][v] not in [0, 1]:
                return False, f"Элемент [{u+1}][{v+1}] должен быть 0 или 1"

    return True, None

def get_graph_json_data(G, n, components=None):
    # Палитра цветов для компонент
    colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7', '#DDA0DD']
    
    # Распределяем цвета по компонентам
    node_colors = {}
    if components:
        for comp_idx, component in enumerate(components):
            color = colors[comp_idx % len(colors)]
            for v in component:
                node_colors[v] = color  # v уже содержит номер вершины (1, 2...)
    else:
        for u in range(n):
            node_colors[u+1] = '#CABFAB' # Дефолтный цвет



    # Формируем вершины для Vis.js
    nodes = []
    for u in range(n):
        node_id = u + 1
        nodes.append({
            "id": node_id,
            "label": str(node_id),
            "color": node_colors.get(node_id, '#CABFAB')
        })
        
    # Формируем рёбра со стрелками
    edges = []
    for u in range(n):
        for v in range(n):
            if G[u][v] == 1 and u != v:
                edges.append({
                    "from": u + 1,
                    "to": v + 1,
                    "arrows": "to", # <-- Указываем Vis.js рисовать стрелку НАПРАВЛЕННОГО ребра
                    "color": {"color": "#52575D"}
                })
                
    return {"nodes": nodes, "edges": edges}





    


