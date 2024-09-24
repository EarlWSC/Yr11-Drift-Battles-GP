extends VehicleBody3D

var max_wheelspin = 1000
var torque = 400
var gear = 0
var acceleration = 0

func _physics_process(delta):
	print($LR_Wheel.wheel_friction_slip)
	steering = lerp(steering, Input.get_axis("right","left") * 0.2, 5 * delta)
	if Input.is_action_just_pressed("gearup"):
		gear = gear + 1
		if gear > 5:
			gear = gear - 1
		print(gear)
	if Input.is_action_just_pressed("geardown"):
		gear = gear - 1
		if gear < -1:
			gear = gear + 1
		print(gear)
	if Input.is_action_pressed("forward"):
		acceleration = (20 * gear)
		
		
	else:
		acceleration = 0
	if Input.is_action_pressed("back"):
		$LF_Wheel.brake = 20
		$RF_Wheel.brake = 20
		$LR_Wheel.brake = 40
		$RR_Wheel.brake = 40
	else:
		$LF_Wheel.brake = 0
		$RF_Wheel.brake = 0
		$LR_Wheel.brake = 0
		$RR_Wheel.brake = 0
	var wheelspin = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * torque * (1 - wheelspin / max_wheelspin)
	wheelspin = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * torque * (1 - wheelspin / max_wheelspin)
	
