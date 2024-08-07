extends TileMap

var astar: AStarGrid2D = AStarGrid2D.new()

func _ready() -> void:
	var tile_map_size := get_used_rect().size
	var map_rect: Rect2i = Rect2i(Vector2i.ZERO,tile_map_size)
	
	astar.region = map_rect
	astar.cell_size = get_tileset().tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in tile_map_size.x:
		for j in tile_map_size.y:
			var coords := Vector2i(i,j)
			var tile_data := get_cell_tile_data(0,coords)
			
			if tile_data and tile_data.get_custom_data("Collidable") == true:
				astar.set_point_solid(coords)

func remove_barrier(pos: Vector2) -> void:
	var tile_data := get_cell_tile_data(0,local_to_map(pos))
	tile_data.set_custom_data("Collidable",false)
	
func set_barrier(pos: Vector2) -> void:
	var tile_data := get_cell_tile_data(0,local_to_map(pos))
	tile_data.set_custom_data("Collidable",true)
