extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ran_sprite = randi_range(0, 3)
	
	match ran_sprite:
		0: $StaticBody2D/AnimatedSprite2D.visible = true
		1: $StaticBody2D/Sprite2D.visible = true
		2: $StaticBody2D/Sprite2D2.visible = true
		3: $StaticBody2D/Sprite2D3.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
