extends Sprite2D



@export var max_tilt_deg := 12.0          # Rotation in air
@export var tilt_lerp_speed := 10.0       # snappiness in air
@export var bob_amp := 3.0                
@export var bob_speed := 10.0             # oscillation speed
@export var land_squash := 5.0            # tiny landing dip dop
@export var land_return_speed := 18.0

var base_gfx_pos: Vector2

var bob_t := 0.0
var land_offset := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_gfx_pos = $".".position
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	#in air sprite tilt
	if !$"../..".dead:
		var in_air = not $"..".is_on_floor()
		var vy = $"..".velocity.y
		var target_tilt := 0.0
		if in_air:
		# Map vy to [-1..1]-ish then to degrees
		# tweak 600.0 depending on your jump speed, if we need to change it!!!! dont forget idk how fast the lvl will be
			var normalized = clamp(vy / 600.0, -1.0, 1.0)
			target_tilt = deg_to_rad(max_tilt_deg) * normalized
		else:
			target_tilt = 0.0
	
		$".".rotation = lerp($".".rotation, target_tilt, 1.0 - exp(-tilt_lerp_speed * delta))
	
	
	
	#in air bobing
		var target_bob = 0.0
		if in_air:
			bob_t += delta * bob_speed
			target_bob = sin(bob_t) * bob_amp
		else:
			# reset timer slowly so it doesn't pop
			bob_t = lerp(bob_t, 0.0, 1.0 - exp(-8.0 * delta))
			target_bob = 0.0
		
		_apply_landing_dip(delta)
	
	# Apply offsets (bob + landing)
		$".".position = base_gfx_pos + Vector2(0, target_bob + land_offset)
	else:
		$".".rotation= 0.0
		# $".".rotation = lerp($".".rotation, 0.0, 0.1*delta)
	
var _was_on_floor := false
func _apply_landing_dip(delta: float) -> void:
	var on_floor = $"..".is_on_floor()
	if on_floor and not _was_on_floor:
		land_offset = land_squash  # quick dip down on landing
	_was_on_floor = on_floor

	# Return land_offset to 0 smoothly
	land_offset = lerp(land_offset, 0.0, 1.0 - exp(-land_return_speed * delta))
