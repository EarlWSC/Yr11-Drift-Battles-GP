extends VehicleBody3D

var max_wheelspin = 1000
var max_torque = 400

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right","left") * 0.2, 5 * delta)
	var acceleration = Input.get_axis("back","forward") * 40
	var wheelspin = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	wheelspin = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * max_torque * (1 - wheelspin / max_wheelspin)
	
