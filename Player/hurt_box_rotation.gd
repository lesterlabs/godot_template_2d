extends Node2D

@onready var player: Player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.DirectionChanged.connect(UpdateRotation)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func UpdateRotation(_new_direction: Vector2) -> void:
	var adjusted_direction = Vector2(player.cardinal_direction.y, -player.cardinal_direction.x)
	rotation_degrees = rad_to_deg(adjusted_direction.angle())
