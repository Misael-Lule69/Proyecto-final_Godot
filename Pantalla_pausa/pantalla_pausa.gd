extends Control  # <--- CAMBIO IMPORTANTE: De Node2D a Control

func _on_resume_pressed() -> void:
	# Ocultar el menú de pausa
	hide()
	# Reanudar el juego (quitar la pausa)
	get_tree().paused = false

func _on_restart_pressed() -> void:
	# Antes de cambiar de escena, quitar la pausa es vital
	get_tree().paused = false
	
	if Global.scene != "":
		get_tree().change_scene_to_file(Global.scene)
	else:
		# Asegúrate de que esta ruta sea correcta
		get_tree().change_scene_to_file("res://Nivel 1/nivel_1.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/pantalla_Menu.tscn")
