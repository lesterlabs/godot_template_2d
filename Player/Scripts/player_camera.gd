extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Keep the camera's initial position and settings
	GlobalLevelManager.TileMapBoundsChanged.connect(UpdateLimits)
	UpdateLimits(GlobalLevelManager.current_tilemap_bounds)
	pass # Replace with function body.

func UpdateLimits(bounds: Array[Vector2]) -> void:
	if bounds.size() == 0:
		return

	# Only update the camera limits
	limit_left = int(bounds[0].x)
	limit_right = int(bounds[1].x)
	limit_top = int(bounds[0].y)
	limit_bottom = int(bounds[1].y)
