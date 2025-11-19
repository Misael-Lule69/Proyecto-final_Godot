extends Node2D

func _on_resume_pressed() -> void:
		# Ocultar el menú de pausa
	hide()
	# Reanudar el juego (quitar la pausa)
	get_tree().paused = false


func _on_restart_pressed() -> void:
		# Antes de cambiar de escena, quitar la pausa
	get_tree().paused = false
	if Global.scene != "":
		get_tree().change_scene_to_file(Global.scene)
	else:
		get_tree().change_scene_to_file("res://nivel1.tscn")


func _on_quit_pressed() -> void:
		# Antes de cambiar de escena, quitar la pausa
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/pantalla_Menu.tscn")
