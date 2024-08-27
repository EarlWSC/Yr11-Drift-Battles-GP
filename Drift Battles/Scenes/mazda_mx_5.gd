extends VehicleBody3D

var max_wheelspin = 1000
var max_torque = 500
var handbrake_force = 8000
var handbrake_applied = false
var original_rear_friction = 0.95

func _ready():
	# Store the original friction slip of the rear tires
	original_rear_friction = $LR_Wheel.wheel_friction_slip
	original_rear_friction = $RR_Wheel.wheel_friction_slip

func _physics_process(delta):
# First # Value is Steering Range and Second # Value is Speed of steering from left to right/ vice versa
	steering = lerp(steering, Input.get_axis("right", "left") * 1 , 11 * delta)
	var acceleration = Input.get_axis("back", "forward") * 300
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
		# Apply handbrake force to the rear wheels and reduce friction for sliding
		$LR_Wheel.brake = handbrake_force
		$RR_Wheel.brake = handbrake_force
		$LR_Wheel.wheel_friction_slip = 0.0 # Lower friction slip to allow drifting
		$RR_Wheel.wheel_friction_slip = 0.0
	else:
		# Release the handbrake force and restore original friction
		$LR_Wheel.brake = 0
		$RR_Wheel.brake = 0
		$LR_Wheel.wheel_friction_slip = original_rear_friction
		$RR_Wheel.wheel_friction_slip = original_rear_friction
