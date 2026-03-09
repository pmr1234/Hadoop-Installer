g={'1':['2','3'] ,
   '2':['4','5'],   
    '3':['6','7'],
}
def dfs(graph, node, visited):
    if node not in visited:
        print(node,end=' ')
        visited.add(node)
        for neighbor in graph.get(node, []):
            dfs(graph, neighbor, visited)
visited = set()
dfs(g, '1', visited)
