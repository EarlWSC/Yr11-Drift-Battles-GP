extends Control

func _on_silverstone_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_interlagos_pressed():
	pass


func _on_spafrancorchamps_pressed():
	pass 


func _on_bahrain_pressed():
	pass 
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/gamemode.tscn")
	global.gamemode_select = 0
	print(global.gamemode_select)
