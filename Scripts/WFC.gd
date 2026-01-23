extends Node2D

const GRID_WIDTH = 25   
const GRID_HEIGHT = 2

@onready var tilemap = $TileMapLayer
# Socket order: [up, right, down, left]
#region rules
#ADD BASE TILE RULES HERE
enum sockets { 
	FLOOR_LOW, GRASS_LOW_LEFT_START, GRASS_LOW_LEFT_START_SMALL, GRASS_LOW_RIGHT_START, FLOOR_LOW_DIRT, GRASS_LOW_MIDDLE, EMPTY,
	TOP_GRASS, TOP_EMPTY, TOP_PEBBLE, 
	TOP_DECOR_ROCK_LEFT_1, TOP_DECOR_ROCK_LEFT_2, TOP_DECOR_ROCK_LEFT_3, TOP_DECOR_ROCK_RIGHT_1, TOP_DECOR_ROCK_RIGHT_2, TOP_DECOR_ROCK_RIGHT_3
} # Socket Enum

var base_tiles = [
	{
		"name": "Floor_Low_Plane",
		"socket": [
			[sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_1, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#UP
			[sockets.FLOOR_LOW, sockets.EMPTY, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW_DIRT],	#RIGHT
			[],																																#DOWN
			[sockets.FLOOR_LOW, sockets.EMPTY, sockets.GRASS_LOW_RIGHT_START, sockets.FLOOR_LOW_DIRT],										#LEFT
		],
		"type": sockets.FLOOR_LOW,
		"atlas": Vector2i(2,1), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Floor_Low_Dirt",
		"socket": [
			[sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_1, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#UP
			[sockets.FLOOR_LOW, sockets.EMPTY, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW_DIRT],	#RIGHT
			[],																																#DOWN
			[sockets.FLOOR_LOW, sockets.EMPTY, sockets.GRASS_LOW_RIGHT_START, sockets.FLOOR_LOW_DIRT],										#LEFT
		],
		"type": sockets.FLOOR_LOW_DIRT,
		"atlas": Vector2i(4,1), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Floor_Low_Empty",
		"socket": [
			[sockets.TOP_EMPTY],																																#UP
			[sockets.FLOOR_LOW, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW_DIRT],					#RIGHT
			[],																																#DOWN
			[sockets.FLOOR_LOW, sockets.GRASS_LOW_RIGHT_START, sockets.FLOOR_LOW_DIRT],														#LEFT
		],
		"type": sockets.EMPTY,
		"atlas": Vector2i(14,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Floor_Low_Grass_Start_Left",
		"socket": [
			[sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_1, sockets.TOP_DECOR_ROCK_LEFT_2, sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_1, sockets.TOP_DECOR_ROCK_RIGHT_2, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#UP
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE],																		#RIGHT
			[],																																#DOWN
			[sockets.FLOOR_LOW, sockets.EMPTY, sockets.FLOOR_LOW_DIRT],																		#LEFT
		],
		"type": sockets.GRASS_LOW_LEFT_START,
		"atlas": Vector2i(5,1), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Floor_Low_Grass_Start_Left_Small",
		"socket": [
			[sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_1, sockets.TOP_DECOR_ROCK_LEFT_2, sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_1, sockets.TOP_DECOR_ROCK_RIGHT_2, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#UP
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE],																		#RIGHT
			[],																																#DOWN
			[sockets.FLOOR_LOW, sockets.EMPTY, sockets.FLOOR_LOW_DIRT],																		#LEFT
		],
		"type": sockets.GRASS_LOW_LEFT_START_SMALL,
		"atlas": Vector2i(12,1), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Floor_Low_Grass_Start_Right",
		"socket": [
			[sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_1, sockets.TOP_DECOR_ROCK_LEFT_2, sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_1, sockets.TOP_DECOR_ROCK_RIGHT_2, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#UP
			[sockets.FLOOR_LOW, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW_DIRT, sockets.EMPTY],	#RIGHT
			[],																																#DOWN
			[sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.GRASS_LOW_MIDDLE],																																#LEFT
		],
		"type": sockets.GRASS_LOW_RIGHT_START,
		"atlas": Vector2i(11,1), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Floor_Low_Grass_Middle",
		"socket": [
			[sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_1, sockets.TOP_DECOR_ROCK_LEFT_2, sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_1, sockets.TOP_DECOR_ROCK_RIGHT_2, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#UP
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE],	#RIGHT
			[],																																#DOWN
			[sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.GRASS_LOW_MIDDLE],																																#LEFT
		],
		"type": sockets.GRASS_LOW_MIDDLE,
		"atlas": Vector2i(7,1), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Pebble_1",
		"socket": [
			[],																																#UP
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],	#RIGHT
			[sockets.FLOOR_LOW, sockets.FLOOR_LOW_DIRT],																																#DOWN
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],																																#LEFT
		],
		"type": sockets.TOP_PEBBLE,
		"atlas": Vector2i(2,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Pebble_2",
		"socket": [
			[],																																#UP
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],	#RIGHT
			[sockets.FLOOR_LOW, sockets.FLOOR_LOW_DIRT],																																#DOWN
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],																																#LEFT
		],
		"type": sockets.TOP_PEBBLE,
		"atlas": Vector2i(3,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Pebble_3",
		"socket": [
			[],																																#UP
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],	#RIGHT
			[sockets.FLOOR_LOW, sockets.FLOOR_LOW_DIRT],																																#DOWN
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],																																#LEFT
		],
		"type": sockets.TOP_PEBBLE,
		"atlas": Vector2i(12,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Pebble_4",
		"socket": [
			[],																																#UP
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],	#RIGHT
			[sockets.FLOOR_LOW, sockets.FLOOR_LOW_DIRT],																																#DOWN
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],																																#LEFT
		],
		"type": sockets.TOP_PEBBLE,
		"atlas": Vector2i(4,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Grass_1",
		"socket": [
			[],																																#UP
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW_DIRT],																																#DOWN
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#LEFT
		],
		"type": sockets.TOP_GRASS,
		"atlas": Vector2i(11,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Grass_2",
		"socket": [
			[],																																#UP
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW_DIRT],																																#DOWN
			[sockets.TOP_EMPTY, sockets.TOP_PEBBLE, sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#LEFT
		],
		"type": sockets.TOP_GRASS,
		"atlas": Vector2i(13,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Rock_Right_3",
		"socket": [
			[],																																#UP
			[sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_RIGHT_3],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW, sockets.FLOOR_LOW_DIRT],										#DOWN
			[sockets.TOP_DECOR_ROCK_RIGHT_2, sockets.TOP_DECOR_ROCK_LEFT_1],																																#LEFT
		],
		"type": sockets.TOP_DECOR_ROCK_RIGHT_3,
		"atlas": Vector2i(10,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Rock_Right_2",
		"socket": [
			[],																																#UP
			[sockets.TOP_DECOR_ROCK_RIGHT_3],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL],										#DOWN
			[sockets.TOP_DECOR_ROCK_RIGHT_1],																																#LEFT
		],
		"type": sockets.TOP_DECOR_ROCK_RIGHT_2,
		"atlas": Vector2i(9,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Rock_Right_1",
		"socket": [
			[],																																#UP
			[sockets.TOP_DECOR_ROCK_RIGHT_2],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL],										#DOWN
			[sockets.TOP_DECOR_ROCK_LEFT_3, sockets.TOP_DECOR_ROCK_RIGHT_3, sockets.TOP_GRASS],																																#LEFT
		],
		"type": sockets.TOP_DECOR_ROCK_RIGHT_1,
		"atlas": Vector2i(8,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Rock_Left_3",
		"socket": [
			[],																																#UP
			[sockets.TOP_GRASS, sockets.TOP_DECOR_ROCK_RIGHT_1, sockets.TOP_PEBBLE],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL],										#DOWN
			[sockets.TOP_DECOR_ROCK_LEFT_2],																																#LEFT
		],
		"type": sockets.TOP_DECOR_ROCK_LEFT_1,
		"atlas": Vector2i(7,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Rock_Left_2",
		"socket": [
			[],																																#UP
			[sockets.TOP_DECOR_ROCK_LEFT_3],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL],										#DOWN
			[sockets.TOP_DECOR_ROCK_LEFT_1],																																#LEFT
		],
		"type": sockets.TOP_DECOR_ROCK_LEFT_2,
		"atlas": Vector2i(6,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Rock_Left_1",
		"socket": [
			[],																																#UP
			[sockets.TOP_DECOR_ROCK_RIGHT_3, sockets.TOP_DECOR_ROCK_LEFT_2],	#RIGHT
			[sockets.GRASS_LOW_RIGHT_START, sockets.GRASS_LOW_MIDDLE, sockets.GRASS_LOW_LEFT_START, sockets.GRASS_LOW_LEFT_START_SMALL, sockets.FLOOR_LOW, sockets.FLOOR_LOW_DIRT],										#DOWN
			[sockets.TOP_DECOR_ROCK_RIGHT_1, sockets.TOP_PEBBLE],																																#LEFT
		],
		"type": sockets.TOP_DECOR_ROCK_LEFT_1,
		"atlas": Vector2i(5,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	},
	{
		"name": "Top_Empty",
		"socket": [
			[],																																#UP
			[sockets.TOP_GRASS, sockets.TOP_PEBBLE, sockets.TOP_DECOR_ROCK_LEFT_1],	#RIGHT
			[sockets.EMPTY],										#DOWN
			[sockets.TOP_GRASS, sockets.TOP_PEBBLE, sockets.TOP_DECOR_ROCK_RIGHT_3],																																#LEFT
		],
		"type": sockets.TOP_EMPTY,
		"atlas": Vector2i(14,0), 		#Atlas Coords
		"alt": 0,						#Tile Map alt image (0, 1, 2, 3) for rotations
		"rotations": 1					#Nr. of rotations tile has
	}
]
#endregion 
#region INIT
var all_tiles = base_tiles
var grid = []
var history = []
var last_cells := []

var current_chunk = 0
var chunk_width = 96 * GRID_WIDTH
#endregion

func _ready():
	randomize()
	#all_tiles = gen_tiles(base_tiles)
	init_grid()
	#propagate_edges()
	wfc()
	draw_grid()
	last_cells = get_right_edge()

func _process(delta: float) -> void:
	if int($"Player/Body".global_position.x / chunk_width) >= current_chunk - 1:
		spawn_chunk()
	pass
	
#region Chunk Logic
func spawn_chunk():
	var edge = get_right_edge()
	if not generate_chunk(edge):
		push_error("Chunk generation failed")
		return

	draw_grid_at_offset(current_chunk + 1)
	current_chunk += 1

func draw_grid_at_offset(chunk_index: int):
	var x_offset = chunk_index * GRID_WIDTH

	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].size() == 1:
				var t = grid[y][x][0]
				tilemap.set_cell(Vector2i((x + x_offset), y), 0, t["atlas"], t["alt"])


func init_chunk_from_edge(left_edge: Array):
	grid.clear()

	for y in range(GRID_HEIGHT):
		grid.append([])
		for x in range(GRID_WIDTH):
			if x == 0:
				grid[y].append([left_edge[y]])
			else:
				grid[y].append(all_tiles.duplicate(true))

func generate_chunk(left_edge: Array) -> bool:
	init_chunk_from_edge(left_edge)

	for y in range(GRID_HEIGHT):
		if not propagate(Vector2i(0, y)):
			return false

	wfc()
	return true

func cleanup_chunk(chunk_index):
	for child in $Obstacles.get_children():
		if child.global_position.x < (chunk_index - 2) * chunk_width:
			child.queue_free()
#endregion
#region WFC
func wfc():
	while not is_fully_collapsed():
		if not reduce_random_with_backtracking():
			push_error("WFC failed — no valid solution")
			return

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

func sockets_compatible(a: Array, b: Array) -> bool:
	for s in a:
		if s in b:
			return true
	return false

func propagate(start: Vector2i) -> bool:
	var stack = [start]
	while stack.size() > 0:
		var c = stack.pop_back()
		var current_options = grid[c.y][c.x]

		var neighbors = [
			Vector2i(c.x, c.y - 1), #up
			Vector2i(c.x + 1, c.y), #right
			Vector2i(c.x, c.y + 1), #down
			Vector2i(c.x - 1, c.y)  #left
		]

		for dir in range(4):
			var n = neighbors[dir]
			if n.x < 0 or n.x >= GRID_WIDTH or n.y < 0 or n.y >= GRID_HEIGHT:
				continue
			
			var neighbour_options = grid[n.y][n.x]
			#if neighbour_options.size() == 1:
				#continue

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

func draw_grid():
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].size() == 1:
				var t = grid[y][x][0]
				tilemap.set_cell(Vector2i(x, y), 0, t["atlas"], t["alt"])
#endregion
#region Helper Functions
func has_contradiction() -> bool:
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].is_empty():
				return true
	return false

func get_right_edge() -> Array:
	var edge := []
	for y in range(GRID_HEIGHT):
		edge.append(grid[y][GRID_WIDTH - 1][0])
	return edge


func save_state():
	history.append(grid.duplicate(true))

func restore_state():
	grid = history.pop_back()


func is_fully_collapsed() -> bool:
	for y in range(GRID_HEIGHT):
		for x in range(GRID_WIDTH):
			if grid[y][x].size() > 1:
				return false
	return true
	
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
#endregion
