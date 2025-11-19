extends Control

func _on_button_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
		# Antes de cambiar de escena, quitar la pausa
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/pantalla_Menu.tscn")



func _on_restart_pressed() -> void:
		# Antes de cambiar de escena, quitar la pausa
	get_tree().paused = false
	if Global.scene != "":
		get_tree().change_scene_to_file(Global.scene)
	else:
		get_tree().change_scene_to_file("res://Menu/pantalla_Menu.tscn")
