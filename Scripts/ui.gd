extends Control
signal StartButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score.visible = false
	if Globals.score != 0:
		$Score.visible = true
		$ColorRect.visible = false
		$TextureButton.visible = false
		$Score.text = ""
		$Highscore.text = ""
		$TextureButton.modulate = Color(0.56863,0.56863,0.56863,1)
		emit_signal("StartButtonPressed")
	else:
		$Score.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_button_down() -> void:
	$TextureButton.modulate = Color(0.2,0.2,0.2,1)
	
	pass # Replace with function body.


func _on_texture_button_button_up() -> void:
	
	if Globals.score == 0:
		$Score.visible = true
		$ColorRect.visible = false
		$TextureButton.visible = false
		$Score.text = ""
		$Highscore.text = ""
		$TextureButton.modulate = Color(0.56863,0.56863,0.56863,1)
		emit_signal("StartButtonPressed")
	else:
		get_tree().reload_current_scene()
		
	pass # Replace with function body.



func setScore(score:int) -> void:
	$Score.text = "SCORE: "+str(score)
	pass

func setHighScore(score:int) -> void:
	$Score.visible = false
	$ColorRect.visible = true
	$TextureButton.visible = true
	$Highscore.text = "[center][wave amp=18 freq=3]HIGHSCORE: "+str(score)+"   [/wave][/center]"
	pass
