extends Control

func _on_tsukuba_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_interlagos_pressed(): #THIS IS ACTUALLY JEREZ CIRCUIT
	get_tree().change_scene_to_file("res://Scenes/jerez.tscn")


func _on_spafrancorchamps_pressed(): #THIS IS ACTUALLY ARGENTINA CIRCUIT
	get_tree().change_scene_to_file("res://Scenes/argentina.tscn")


func _on_bahrain_pressed(): #THIS IS ACTUALLY SPLIT TRACK CIRCUIT
	if global.gamemode_select == 2:
		get_tree().change_scene_to_file("res//Scenes/")
	else:
		print("You ain't allowed here if you are trying to race or time trial buddy o pal!")
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/gamemode.tscn")
	global.gamemode_select = 0
	print(global.gamemode_select)
