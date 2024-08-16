extends VehicleBody3D

var max_rpm = 600
var max_torque = 200

func _physics_process(delta):
	steering = lerp(steering, Input.get_axis("right","left") * 0.4, 5 * delta)
	var acceleration = Input.get_axis("back","forward") * 100
	var rpm = abs($LR_Wheel.get_rpm())
	$LR_Wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
	rpm = abs($RR_Wheel.get_rpm())
	$RR_Wheel.engine_force = acceleration * max_torque * (1 - rpm / max_rpm)
