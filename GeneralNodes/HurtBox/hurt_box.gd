class_name HurtBox extends Area2D

@export var damage: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	pass # Replace with function body.

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		area.TakeDamage(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
