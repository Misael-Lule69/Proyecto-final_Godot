extends CanvasLayer

# Variable para saber a dónde ir. La puerta nos dará este dato.
var ruta_siguiente_nivel : String = ""

func _ready():
	# Nos aseguramos de pausar el juego al aparecer esta pantalla
	process_mode = Node.PROCESS_MODE_ALWAYS # Importante: Esto permite que este menú funcione aunque el juego esté en pausa
	get_tree().paused = true

func _on_button_pressed() -> void:
	# 1. Quitamos la pausa
	get_tree().paused = false
	
	# 2. Cambiamos de nivel
	if ruta_siguiente_nivel != "":
		get_tree().change_scene_to_file(ruta_siguiente_nivel)
	else:
		print("No hay siguiente nivel configurado, volviendo al menú...")
		get_tree().change_scene_to_file("res://Menu/pantalla_Menu.tscn")
	
	# 3. ¡IMPORTANTE! Borramos esta pantalla de victoria
	queue_free()
