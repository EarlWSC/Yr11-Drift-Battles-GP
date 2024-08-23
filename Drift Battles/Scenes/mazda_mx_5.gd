extends VehicleBody3D

var max_wheelspin = 600
var max_torque = 151
var handbrake_force = 2000
var handbrake_applied = false

func _physics_process(delta):
	
	steering = lerp(steering, Input.get_axis("right", "left") * 0.6, 11 * delta)
	var acceleration = Input.get_axis("back", "forward") * 500
	var wheelspin = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	wheelspin = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	
	# Check if handbrake is pressed
	if Input.is_action_just_pressed("handbrake"):
		apply_handbrake(true)
	elif Input.is_action_just_released("handbrake"):
		apply_handbrake(false)

func apply_handbrake(apply: bool):
	handbrake_applied = apply
	if handbrake_applied:
		# Apply handbrake force to the rear wheels
		$LR_Wheel.brake = handbrake_force
		$RR_Wheel.brake = handbrake_force
	else:
		# Release the handbrake force
		$LR_Wheel.brake = 0
		$RR_Wheel.brake = 0
