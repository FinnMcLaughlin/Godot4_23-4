extends TileMapLayer
class_name Maze

@export var Generate : bool
@export var ROWS : int
@export var COLS : int

@export var offset : int

var all_tiles : Array = []
var unvisited : Array = []
var visited : Array = []

func _ready() -> void:
	if Generate:
		clear()
		_maze_array_init()
		_maze_gen()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("gen_maze"):
		clear()
		_maze_array_init()
		_maze_gen()
	pass

func _maze_array_init():
	all_tiles = []
	unvisited = []
	visited = []

	for row in (ROWS * offset ):
		all_tiles.append([])
		for col in (COLS * offset ):
			all_tiles[row].append(0)
			
			if row % offset == 0 and col % offset == 0:
				unvisited.append(Vector2(row, col))
			
			set_cell(Vector2(row, col), 0, Vector2(all_tiles[row][col], 0))

func _maze_gen():
	var starting_pos = _get_random_coord()
	
	print("Start..." + str(starting_pos))
	
	_carve_path(starting_pos)
	unvisited.erase(starting_pos)
	
	visited.append(starting_pos)
	
	var current = starting_pos
	
	print("Size: " + str(unvisited.size()) )
	print(unvisited)
	
	while(unvisited.size() > 0):
		var neighbour = await _choose_direction(current)
		
		#print(neighbour)
		#print(unvisited)
		#
		#print(
			#"Remaining: " + str(unvisited.size()) +
			#" Current: " + str(current) +
			#" Visited: " + str(visited)
		#)
		
		if neighbour != Vector2(-1, -1) and neighbour not in visited:
			all_tiles[neighbour.x][neighbour.y] = 1
			
			_carve_path(neighbour)
			_connect_path(current, neighbour)
			
			visited.append(neighbour)
			unvisited.erase(neighbour)

			current = neighbour
			
			# await get_tree().create_timer(0.05).timeout
		else:
			_random_connect(current)
			
			current = unvisited.pick_random()
			
			while current.x as int % 2 != 0 and current.y as int % 2 != 0:
				current = unvisited.pick_random()
			
			_carve_path(current)
			_connect_path(current, _get_neighbours(current).pick_random())
			unvisited.erase(current)
			visited.append(current)
		
		pass
	
	_random_connect(current)
	_add_border()
	
	print("Done!")
	pass

func _choose_direction(coord : Vector2):
	var neighbours = _get_neighbours(coord)
	
	print("Choosing Direction -----------------------------")
	
	print(neighbours)
	
	for n in neighbours:
		if n in visited:
			neighbours[neighbours.find(n)] = -1
			
	
	for x in neighbours.count(-1):
		neighbours.erase(-1)
	
	var next_neighbour = neighbours.pick_random()
	
	if neighbours.size() < 1:
		return Vector2(-1, -1)
	
	while next_neighbour.x >= ROWS * 2 or next_neighbour.y >= COLS * 2:
		next_neighbour = neighbours.pick_random()
		
	
	return next_neighbour

func _get_neighbours(coord : Vector2):
	var n_array = []
	
	if coord.y - offset >= 0:
		n_array.append(coord + Vector2(0, -offset))
	if coord.x + offset < ROWS:
		n_array.append(coord + Vector2(offset, 0))
	if coord.y + offset < COLS:
		n_array.append(coord + Vector2(0, offset))
	if coord.x - offset >= 0:
		n_array.append(coord + Vector2(-offset, 0))
	
	return n_array

func _carve_path(coord : Vector2):
	all_tiles[coord.x][coord.y] = 1
	set_cell(coord, 0, Vector2(1, 0))
	print("Carving: " + str(coord))

func _get_random_coord():
	var rand_coord = unvisited.pick_random()
	
	if int(rand_coord.x) % 2 == 0 and int(rand_coord.y) % 2 == 0:
		return rand_coord
	else:
		return _get_random_coord()

func _connect_path(curr : Vector2, next : Vector2):
	_carve_path(Vector2((curr.x + next.x) / 2, (curr.y + next.y) / 2))

func _random_connect(curr : Vector2):
	_connect_path(curr, _get_neighbours(curr).pick_random())
	pass

func _add_border():
	for x in range(0, ROWS * 2):
		all_tiles[x][COLS*2-1] = 1
		_carve_path(Vector2(x, COLS*2-1))
	
	for y in range(0, COLS * 2):
		all_tiles[ROWS*2-1][y] = 1
		_carve_path(Vector2(ROWS*2-1, y))
	
	for x in range(-1, ROWS * 2):
		_carve_path(Vector2(x, -1))
		_carve_path(Vector2(-1, x))
	pass
