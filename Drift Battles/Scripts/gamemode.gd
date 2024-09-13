extends Control

func _on_race_day_pressed():
	pass

func _on_practice_session_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_time_trials_pressed():
	pass 
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
