extends VehicleBody3D

var max_wheelspin = 1000
var torque = 100
var gear_ratio = [0.1, 3.5, 2.1, 1.4, 1.0, 0.8]
var current_gear = 0
var acceleration = 0
var speed = 0
func _process(delta):
	#MANUAL GEAR SWITCH CODE
	if Input.is_action_just_pressed("gearup"):
		current_gear = current_gear + 1
		if current_gear > 5:
			current_gear = current_gear - 1
		print(current_gear)
	if Input.is_action_just_pressed("geardown"):
		current_gear = current_gear - 1
		if current_gear < -1:
			current_gear = current_gear + 1
		print(current_gear)
	
	var velocity = linear_velocity  # Get the velocity vector (Vector3)
	speed = velocity.length()  # Calculate the magnitude of the velocity vector (speed)
	
func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right","left") * 0.2, 5 * delta)
	#THROTTLE AND BRAKE CODE
	if Input.is_action_pressed("forward"):
		acceleration = (20 * current_gear)
	else:
		acceleration = 0.1
	if Input.is_action_pressed("back"):
		$LF_Wheel.brake = 40
		$RF_Wheel.brake = 40
		$LR_Wheel.brake = 80
		$RR_Wheel.brake = 80
	else:
		$LF_Wheel.brake = 0
		$RF_Wheel.brake = 0
		$LR_Wheel.brake = 0
		$RR_Wheel.brake = 0
	var wheelspin = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * (torque * gear_ratio[current_gear] - (speed - current_gear)) * (1 - wheelspin / max_wheelspin) 
	wheelspin = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * (torque * gear_ratio[current_gear] - (speed- current_gear)) * (1 - wheelspin / max_wheelspin) 
	
