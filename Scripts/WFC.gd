extends Node2D

const GRID_WIDTH = 18
const GRID_HEIGHT = 10

@onready var tilemap = $TileMapLayer

enum sockets { } # Socket Enum

# Socket order: [up, right, down, left]
#region rules
#ADD RULES HERE
var base_tiles = [
	{
		"name": "Name",
		"socket": [[], [], [], [], []], #Sockets
		"atlas": Vector2i(0,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 4					#Nr. of rotations tile has
	}
]
#endregion 


var all_tiles = base_tiles
var grid = []
var history = []

func _ready():
	randomize()
	all_tiles = gen_tiles(base_tiles)
	init_grid()
	propagate_edges()
	wfc()
	draw_grid()

func gen_tiles(tiles): 
	var _tiles = [] 
	for tile in tiles: 
		var sockets = tile["socket"].duplicate() 
		for i in range(tile["rotations"]): 
			all_tiles.append({ 
			"name": tile["name"] + "_" + str(i * 90), # optional, for debugging 
			"socket": sockets.duplicate(), 
			"atlas": tile["atlas"], 
			"alt": i, 
			}) 
			sockets = [sockets[3], sockets[0], sockets[1], sockets[2]] 
	return _tiles
			

func propagate_edges():
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if x == 0 or y == 0 or x == GRID_WIDTH - 1 or y == GRID_HEIGHT - 1:
				propagate(Vector2i(x, y))


func init_grid():
	grid.clear()
	for y in range(GRID_HEIGHT):
		grid.append([])
		for x in range(GRID_WIDTH):
			#if x == 0 or y == 0 or x == GRID_WIDTH - 1 or y == GRID_HEIGHT - 1:
				#grid[y].append([get_grass_tile()])
			#else:
				grid[y].append(all_tiles.duplicate(true))

func get_tile(name: String):
	for tile in all_tiles:
		if tile["name"] == name:
			return tile
	return null


func wfc():
	while not is_fully_collapsed():
		if not reduce_random_with_backtracking():
			push_error("WFC failed — no valid solution")
			return
	print("done")

func reduce_random_with_backtracking() -> bool:
	var min_entropy = INF
	var candidates = []

	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			var c = grid[y][x].size()
			if c > 1 and c < min_entropy:
				min_entropy = c
				candidates = [Vector2i(x, y)]
			elif c == min_entropy:
				candidates.append(Vector2i(x, y))

	if candidates.is_empty():
		return true

	var cell = candidates.pick_random()
	var options = grid[cell.y][cell.x].duplicate()

	while options.size() > 0:
		save_state()

		var choice = options.pick_random()
		options.erase(choice)
		grid[cell.y][cell.x] = [choice]

		if propagate(cell) and not has_contradiction():
			return true
			
		restore_state()
		
	return false

func save_state():
	history.append(grid.duplicate(true))

func restore_state():
	grid = history.pop_back()


func propagate(start: Vector2i) -> bool:
	var stack = [start]
	while stack.size() > 0:
		var c = stack.pop_back()
		var current_options = grid[c.y][c.x]

		var neighbors = [
			Vector2i(c.x, c.y - 1),
			Vector2i(c.x + 1, c.y),
			Vector2i(c.x, c.y + 1),
			Vector2i(c.x - 1, c.y)
		]

		for dir in range(4):
			var n = neighbors[dir]
			if n.x < 0 or n.x >= GRID_WIDTH or n.y < 0 or n.y >= GRID_HEIGHT:
				continue

			if grid[n.y][n.x].size() == 1:
				continue

			var allowed = []
			for n_opt in grid[n.y][n.x]:
				for c_opt in current_options:
					if n_opt["type"] in c_opt["socket"][dir]:
						allowed.append(n_opt)
						break

			if allowed.is_empty():
				return false

			if allowed.size() < grid[n.y][n.x].size():
				grid[n.y][n.x] = allowed
				stack.push_front(n)
	return true

func has_contradiction() -> bool:
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].is_empty():
				return true
	return false

func draw_grid():
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].size() == 1:
				var t = grid[y][x][0]
				tilemap.set_cell(Vector2i(x, y), 0, t["atlas"], t["alt"])

func is_fully_collapsed() -> bool:
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].size() > 1:
				return false
	return true
