extends Control
@export var gamemode_select = 0

func _on_race_day_pressed():
	get_tree().change_scene_to_file("res://Scenes/Circuit_Select.tscn")
	gamemode_select = 1
	print(gamemode_select)

func _on_practice_session_pressed():
	get_tree().change_scene_to_file("res://Scenes/circuit_select.tscn")
	gamemode_select = 2
	print(gamemode_select)

func _on_time_trials_pressed():
	get_tree().change_scene_to_file("res://Scenes/Circuit_Select.tscn")
	gamemode_select = 3
	print(gamemode_select)
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
