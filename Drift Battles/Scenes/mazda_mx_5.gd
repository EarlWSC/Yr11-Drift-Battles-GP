extends VehicleBody3D

var max_wheelspin = 1000
var max_torque = 800
var handbrake_force = 20
var handbrake_applied = false
var original_front_friction = 1
var original_rear_friction = 1  # Slightly lower rear friction
var drift_friction = 0.5  # Friction value during drift
var max_steering_angle = 1.0  # Maximum steering angle at low speed
var min_steering_angle = 0.3  # Minimum steering angle at high speed
var max_speed = 100.0  # Speed at which steering is least sensitive

func _physics_process(delta):
	$LF_Wheel.wheel_friction_slip = original_front_friction
	$RF_Wheel.wheel_friction_slip = original_front_friction
	$LR_Wheel.wheel_friction_slip = original_rear_friction
	$RR_Wheel.wheel_friction_slip = original_rear_friction
	
	var vehicle_speed = linear_velocity.length()  # Get vehicle velocity
	var speed_factor = clamp(1.0 - (vehicle_speed / max_speed), min_steering_angle / max_steering_angle, 1.0)
	var adjusted_steering = Input.get_axis("right", "left") * max_steering_angle * speed_factor

	# Steering adjustment with speed sensitivity
	steering = lerp(steering, adjusted_steering, 11 * delta)
	if Input.is_action_just_pressed("handbrake"):
		# Apply handbrake force and reduce friction for slidinga
		$LR_Wheel.brake = handbrake_force 
		$RR_Wheel.brake = handbrake_force 
		$LR_Wheel.wheel_friction_slip = original_rear_friction - drift_friction  # Lower friction for drifting
		$RR_Wheel.wheel_friction_slip = original_rear_friction - drift_friction
		$RF_Wheel.engine_force = 0.1
		$LF_Wheel.engine_force = 0.1
	elif Input.is_action_just_released("handbrake"):
		# Release the handbrake and restore original friction
		$LR_Wheel.brake = 0
		$RR_Wheel.brake = 0
		$LR_Wheel.wheel_friction_slip = original_rear_friction
		$RR_Wheel.wheel_friction_slip = original_rear_friction
	else:
		original_front_friction = vehicle_speed / 40 + 1.6
		original_rear_friction = vehicle_speed / 45 + 1
		

	
	# Acceleration and wheelspin management
	var acceleration = Input.get_axis("back", "forward") * 100
	var wheelspin = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	wheelspin = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	print (original_front_friction)
	print (original_rear_friction)
	print ()
	print ()
	var wheelslip = $LR_Wheel.get_skidinfo()
	if wheelslip < 0.5:
		print("Drift Mode")

	print ("Wheelslip")
	print (wheelslip)
	print ()
	print ()
	
