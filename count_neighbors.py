def count_neighbors(grid, row, col, include_diagonals=True):
    """
    Counts the number of non-zero neighbors for a given cell in a grid.
    
    Args:
        grid (list of list of int): The 2D grid.
        row (int): The row index of the target cell.
        col (int): The column index of the target cell.
        include_diagonals (bool): Whether to include diagonal neighbors.
        
    Returns:
        int: The count of non-zero neighbors.
    """
    rows = len(grid)
    cols = len(grid[0])
    count = 0
    
    # Define directions: (row_offset, col_offset)
    directions = [
        (-1, 0), (1, 0), (0, -1), (0, 1)  # Up, Down, Left, Right
    ]
    
    if include_diagonals:
        directions.extend([
            (-1, -1), (-1, 1), (1, -1), (1, 1) # Diagonals
        ])
        
    for dr, dc in directions:
        r, c = row + dr, col + dc
        
        # Check boundaries
        if 0 <= r < rows and 0 <= c < cols:
            # Check if neighbor is non-zero (assuming 1 is the target, or any non-zero)
            if grid[r][c] != 0:
                count += 1
                
    return count

if __name__ == "__main__":
    # Test cases
    test_grid = [
        [1, 0, 1],
        [0, 1, 0],
        [1, 0, 1]
    ]
    
    print("Grid:")
    for row in test_grid:
        print(row)
    print("-" * 20)

    # Center cell (1, 1) - should have 4 diagonal neighbors if include_diagonals=True
    # Neighbors are (0,0)=1, (0,1)=0, (0,2)=1, (1,0)=0, (1,2)=0, (2,0)=1, (2,1)=0, (2,2)=1
    # Non-zero neighbors: (0,0), (0,2), (2,0), (2,2) -> Total 4
    
    r, c = 1, 1
    print(f"Cell ({r}, {c})")
    print(f"Neighbors (with diagonals): {count_neighbors(test_grid, r, c, True)}")
    print(f"Neighbors (no diagonals):   {count_neighbors(test_grid, r, c, False)}")
    
    # Corner cell (0, 0)
    # Neighbors: (0,1)=0, (1,0)=0, (1,1)=1
    # Non-zero: (1,1) -> Total 1
    r, c = 0, 0
    print(f"\nCell ({r}, {c})")
    print(f"Neighbors (with diagonals): {count_neighbors(test_grid, r, c, True)}")
    
    # Edge cell (0, 1)
    # Neighbors: (0,0)=1, (0,2)=1, (1,0)=0, (1,1)=1, (1,2)=0
    # Non-zero: (0,0), (0,2), (1,1) -> Total 3
    r, c = 0, 1
    print(f"\nCell ({r}, {c})")
    print(f"Neighbors (with diagonals): {count_neighbors(test_grid, r, c, True)}")
