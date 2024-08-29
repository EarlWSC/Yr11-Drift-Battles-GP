extends VehicleBody3D

var max_wheelspin = 1000
var max_torque = 800
var handbrake_force = 9999
var handbrake_applied = false
var original_front_friction = 1.2
var original_rear_friction = 0.6  # Slightly lower rear friction
var drift_friction = 0.2  # Friction value during drift
var max_steering_angle = 1.0  # Maximum steering angle at low speed
var min_steering_angle = 0.3  # Minimum steering angle at high speed
var max_speed = 100.0  # Speed at which steering is least sensitive

func _physics_process(delta):
	var vehicle_speed = linear_velocity.length()  # Get vehicle speed
	var speed_factor = clamp(1.0 - (vehicle_speed / max_speed), min_steering_angle / max_steering_angle, 1.0)
	var adjusted_steering = Input.get_axis("right", "left") * max_steering_angle * speed_factor
	
	# Steering adjustment with speed sensitivity
	steering = lerp(steering, adjusted_steering, 11 * delta)
	
	# Acceleration and wheelspin management
	var acceleration = Input.get_axis("back", "forward") * 100
	var wheelspin = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	wheelspin = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	print (vehicle_speed)
	
	# Handbrake application
	if Input.is_action_just_pressed("handbrake"):
		apply_handbrake(true)
	elif Input.is_action_just_released("handbrake"):
		apply_handbrake(false)

func apply_handbrake(apply: bool):
	handbrake_applied = apply
	if handbrake_applied:
		# Apply handbrake force and reduce friction for sliding
		$LR_Wheel.brake = handbrake_force
		$RR_Wheel.brake = handbrake_force
		$LR_Wheel.wheel_friction_slip = drift_friction  # Lower friction for drifting
		$RR_Wheel.wheel_friction_slip = drift_friction
	else:
		# Release the handbrake and restore original friction
		$LR_Wheel.brake = 0
		$RR_Wheel.brake = 0
		$LF_Wheel.brake = 0
		$RF_Wheel.brake = 0
		$LR_Wheel.wheel_friction_slip = original_rear_friction
		$RR_Wheel.wheel_friction_slip = original_rear_friction
