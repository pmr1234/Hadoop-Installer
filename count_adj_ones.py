def count_adjecent_ones(arr,r,c):
    rows,cols = len(arr), len(arr[0])
    count = 0
    direction = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    
    for dr, dc in direction:
        nr, nc = r + dr, c + dc
        if 0 <= nr < rows and 0 <= nc < cols and arr[nr][nc] == 1:
            count += 1
    return count
arr=[
    [1,0,1],
    [1,1,0],
    [0,1,1]]
print(count_adjecent_ones(arr,1,1))
print(count_adjecent_ones(arr,0,0))
print(count_adjecent_ones(arr,2,2))
print(count_adjecent_ones(arr,0,2))
print(count_adjecent_ones(arr,2,0))
print(count_adjecent_ones(arr,1,0))
