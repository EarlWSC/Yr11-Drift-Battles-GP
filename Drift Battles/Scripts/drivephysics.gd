extends VehicleBody3D
var acceleration = 0
var brakes = 0
@export var MAX_ENGINE_FORCE = 2950.00
@export var MAX_BRAKE_FORCE = 50.00

@export var gear_ratio:Array = [2.29, 1.81, 1.39, 1.12, 0.93, 0.81]
@export var reverse_ratio:float = -2.5
@export var final_drive:float = 3.38
@export var max_engine_rpm:float = 10000.00
@export var power_curve:Curve = null

var current_gear = 1
var current_speed_mps = 0.0
@onready var last_pos = position

func _process_gear_inputs():
	if Input.is_action_just_pressed("gearup") and current_gear < gear_ratio.size():
		current_gear = current_gear + 1
	elif Input.is_action_just_pressed("geardown") and current_gear > -1:
		current_gear = current_gear - 1

func _process(delta):
	
	_process_gear_inputs()
	
	var speed = get_speed_kph()
	var rpm = calculation_of_rpm()

	var info = 'RPM: %.0f 
				(gear: %d)'  % [ (rpm / 1.3) , current_gear ]
	$Info.text = info

func get_speed_kph():
	return 

func calculation_of_rpm() -> float:
	if current_gear == 0:
		return 0.0
		
	var wheel_circumference : float = 2.0 * PI * $RR_Wheel.wheel_radius
	var wheel_rotation_speed : float = 60.0 * current_speed_mps
	var drive_shaft_rotation_speed : float = wheel_rotation_speed * final_drive
	if current_gear == -1:
		return drive_shaft_rotation_speed * reverse_ratio
	elif current_gear <= gear_ratio.size():
		return drive_shaft_rotation_speed * gear_ratio[current_gear - 1]
	else:
		return 0.0

func _physics_process(delta):
	current_speed_mps = (position - last_pos).length() / delta
	
	if Input.is_action_pressed("forward"):
		acceleration = 1.0
	else:
		acceleration = 0.0
	if Input.is_action_pressed("back"):
		brakes = 1.0
	else:
		brakes = 0.0

	brake = brakes * MAX_BRAKE_FORCE

	var rpm = calculation_of_rpm()
	var rpm_factor = clamp(rpm / max_engine_rpm, 0.0 , 1.0)
	var power_factor = power_curve.sample_baked(rpm_factor)
	
	if current_gear == -1:
		$LR_Wheel.engine_force = acceleration * power_factor * reverse_ratio * final_drive * MAX_ENGINE_FORCE
		$RR_Wheel.engine_force = acceleration * power_factor * reverse_ratio * final_drive * MAX_ENGINE_FORCE
	elif current_gear > 0 and current_gear <= gear_ratio.size():
		$LR_Wheel.engine_force = acceleration * power_factor * gear_ratio[current_gear - 1] * final_drive * MAX_ENGINE_FORCE
		$RR_Wheel.engine_force = acceleration * power_factor * gear_ratio[current_gear - 1] * final_drive * MAX_ENGINE_FORCE
	else:
		$LR_Wheel.engine_force = 0.0
		$RR_Wheel.engine_force = 0.0
	
	
	### STEERING ###
	steering = lerp(steering, Input.get_axis("right","left") * 0.5, 4 * delta)
	last_pos = position
	
	###############################################################################################
	#var wheelspin = abs($LR_Wheel.get_rpm())
	#$LR_Wheel.engine_force = acceleration * torque * (1 - wheelspin / max_wheelspin) 
	#wheelspin = abs($RR_Wheel.get_rpm())
	#$RR_Wheel.engine_force = acceleration * torque * (1 - wheelspin / max_wheelspin) 
	
