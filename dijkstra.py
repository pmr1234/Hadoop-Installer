from collections import deque
def minsteps(grid):
    rows, cols = len(grid), len(grid[0])
    if grid[0][0] == 1 or grid[rows-1][cols-1] == 1:
        return -1  # Start or end is blocked
    q=deque()
    q.append((0,0))  # (row, col)
    visited=[[False]*cols for _ in range(rows)]
    visited[0][0]=True
    steps=0
    direction = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    while q:
        for _ in range(len(q)):
            r,c=q.popleft()
            if r==rows-1 and c==cols-1:
                return steps
            for dr,dc in direction:
                nr,nc=r+dr,c+dc
                if 0<=nr<rows and 0<=nc<cols and not visited[nr][nc] and grid[nr][nc]==0:
                    visited[nr][nc]=True
                    q.append((nr,nc))
        steps+=1
    return -1  # No path found
grid=[
    [0,0,0],
    [1,0,1],
    [0,0,0]]
print(minsteps(grid))  # Output: 4
grid2=[
    [0,1,0],
    [1,0,1],
    [0,0,0]]    
print(minsteps(grid2))  # Output: -1
g=[
    [0,0,0,0,0],
    [1,1,0,1,0],
    [0,0,0,1,0],
    [0,1,1,0,0],
    [0,0,0,0,0]]  # Output: 8 
print(minsteps(g))