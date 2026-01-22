extends Camera2D
var originalY:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	originalY = $".".global_position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$".".global_position.y = originalY
	pass
