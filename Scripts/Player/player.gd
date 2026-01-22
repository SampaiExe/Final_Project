extends Node2D


@export var DEBUG:bool = false

var dead := false

var elbow1:Vector2
var elbow2:Vector2

var footBottom1:Vector2
var footBottom2:Vector2

@export var SPEED = 500.0
@export var JUMP_VELOCITY = -800.0


var limb_length = 150.0
var bend_sign = 0

var TagetPosOffset:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().create_timer(3.0).timeout.connect(die)
	footBottom1 = $LegLerpPos.position
	footBottom2 = $LegLerpPos2.position
	TagetPosOffset = $LegTargetPos.position
	
	pass # Replace with function body.

func _physics_process(delta):
	
	if DEBUG: 
		print($Body.is_on_floor())
		print($Body.get_gravity())
	
	# Add the gravity.
	if not $Body.is_on_floor():
		$Body.velocity += $Body.get_gravity() * delta
		
	if !dead and Input.is_action_just_pressed("ui_accept") and $Body.is_on_floor():
		$Body.velocity.y = JUMP_VELOCITY
		
	$Body.velocity.x = SPEED
	$Body.move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if limb_length + limb_length < footBottom1.distance_to($Body.position) or $Body.position.y > $LegLerpPos.position.y:
		$LegLerpPos.position = $LegTargetPos.position
		pass
	if limb_length + limb_length < footBottom2.distance_to($Body.position) or $Body.position.y > $LegLerpPos2.position.y:
		if $LegTargetPos.position.distance_to($LegLerpPos.position) > 200.0:
			$LegLerpPos2.position = $LegTargetPos.position
		else:
			$LegLerpPos2.position.x = $LegTargetPos.position.x - 100.0
			$LegLerpPos2.position.y = $LegTargetPos.position.y
		pass
		
	#elbow calc
	elbow1 = $Body.position + magic_IK_Function(limb_length, limb_length, footBottom1-$Body.position, -1.0)
	elbow2 = $Body.position + magic_IK_Function(limb_length, limb_length, footBottom2-$Body.position, -1.0)
	
	#bottom feet position + lerp 
	$Foot1.position = elbow1
	footBottom1 = lerp(footBottom1, $LegLerpPos.position, 10*delta)
	
	$Foot2.position = elbow2
	footBottom2 = lerp(footBottom2, $LegLerpPos2.position, 10*delta)
	
	#updating target feet position location
	$LegTargetPos.position = Vector2($Body.position.x + TagetPosOffset.x, $Body.position.y + TagetPosOffset.y)
	
	
	if DEBUG: queue_redraw()
	
	
	#rotate sprites LEG2
	var lowerAngleFoot2 = (elbow2 - footBottom2).angle()
	$Foot2/Sprite2D.rotation = lerp($Foot2/Sprite2D.rotation, PI/2+lowerAngleFoot2, 10*delta) 
	
	var upperAngleFoot2 = ($Body.position - elbow2).angle()
	$FootUp2.position = elbow2
	$FootUp2/Sprite2D.rotation = PI/2+upperAngleFoot2
	
	#rotate sprites LEG1
	var lowerAngleFoot1 = (elbow1 - footBottom1).angle()
	$Foot1/Sprite2D.rotation = lerp($Foot1/Sprite2D.rotation,  PI/2+lowerAngleFoot1, 10*delta)
	
	var upperAngleFoot1 = ($Body.position - elbow1).angle()
	$FootUp1.position = elbow1
	$FootUp1/Sprite2D.rotation = PI/2+upperAngleFoot1

	pass
	
func _draw() -> void:
	if DEBUG: draw_lerp_free()

func draw_lerp_free():
	var body_pos = $Body.position
	# limb lines
	draw_line(body_pos, elbow1, Color.YELLOW, 2.0)
	draw_line(elbow1, $Foot1.position, Color.YELLOW, 2.0)
	
	draw_line(body_pos, elbow2, Color.YELLOW, 2.0)
	draw_line(elbow2, $Foot2.position, Color.YELLOW, 2.0)
	
	# feet
	draw_circle($Foot1.position, 25.0, Color.WHITE)
	draw_circle($Foot2.position, 25.0, Color.WHITE)
	# body
	draw_circle(body_pos, 50.0, Color.WHITE)

	
	draw_circle(elbow2, 20.0, Color.YELLOW)
	
	draw_circle(elbow1, 20.0, Color.YELLOW)



func magic_IK_Function(l1:float, l2:float, local_end_affector:Vector2, elbow_direction_sign:int) -> Vector2:
	
	var numerator:float = l1 * l1 + local_end_affector.x * local_end_affector.x + local_end_affector.y * local_end_affector.y - l2 * l2
	var denominator:float = 2* l1 * sqrt(local_end_affector.x * local_end_affector.x + local_end_affector.y * local_end_affector.y)
	var elbow_angle_relative = acos(numerator/denominator)
	
	# NaN check
	if elbow_angle_relative != elbow_angle_relative:
		elbow_angle_relative = 0.0
	
	if elbow_direction_sign == 0:
		elbow_direction_sign = 1
		
	var angle = elbow_direction_sign * elbow_angle_relative + local_end_affector.angle()
	return Vector2(cos(angle), sin(angle)) * l1
	

func die():
	dead = true
	SPEED = 0
	$Body/AnimationPlayer.play("DIE")
	$FootUp2/Sprite2D.visible = false
	$Foot2/Sprite2D.visible = false
	$FootUp1/Sprite2D.visible = false
	$Foot1/Sprite2D.visible = false
