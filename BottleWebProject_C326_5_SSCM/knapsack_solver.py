"""
Решатель задачи о рюкзаке на дереве.
"""

def build_graph(edges, n):
    """Построение графа из списка рёбер."""
    g = {i: [] for i in range(1, n + 1)}
    for u, v in edges:
        g[u].append(v)
        g[v].append(u)
    return g


def dfs(u, parent, g, weights, values, W):
    """DFS с вычислением DP для вершины u."""
    INF = -10**9
    dp = [INF] * (W + 1)
    if weights[u] <= W:
        dp[weights[u]] = values[u]

    for child in g[u]:
        if child == parent:
            continue
        dp_c = dfs(child, u, g, weights, values, W)
        new_dp = [INF] * (W + 1)

        for w1 in range(W + 1):
            if dp[w1] == INF:
                continue
            if dp[w1] > new_dp[w1]:
                new_dp[w1] = dp[w1]
            for w2 in range(W + 1):
                if dp_c[w2] == INF:
                    continue
                if w1 + w2 <= W:
                    val = dp[w1] + dp_c[w2]
                    if val > new_dp[w1 + w2]:
                        new_dp[w1 + w2] = val
        dp = new_dp
    return dp


def restore_answer(best_root, best_w, g, weights, values, W):
    """Восстанавливает список выбранных вершин."""
    selected = set()
    stack = [(best_root, -1, best_w)]

    while stack:
        u, parent, target_w = stack.pop()
        selected.add(u)

        remaining = target_w - weights[u]
        children = [c for c in g[u] if c != parent]

        if not children or remaining <= 0:
            continue

        for child in children:
            dp_child = dfs(child, u, g, weights, values, W)
            for w2 in range(1, remaining + 1):
                if dp_child[w2] != -10**9:
                    stack.append((child, u, w2))
                    remaining -= w2
                    break
    return selected


def solve_knapsack_tree(edges, weights, values, n, W):
    """
    Решает задачу о рюкзаке на дереве.

    Параметры:
        edges: list of tuples - рёбра дерева
        weights: list - веса вершин (индексация с 1)
        values: list - ценности вершин (индексация с 1)
        n: int - количество вершин
        W: int - максимальный вес

    Возвращает:
        tuple: (max_value, selected_vertices_set)
    """
    g = build_graph(edges, n)
    best_val = 0
    best_root = 1
    best_w = 0

    for root in range(1, n + 1):
        dp = dfs(root, -1, g, weights, values, W)
        for w in range(W + 1):
            if dp[w] > best_val:
                best_val = dp[w]
                best_root = root
                best_w = w

    if best_val == 0:
        return 0, set()

    selected = restore_answer(best_root, best_w, g, weights, values, W)
    return best_val, selected