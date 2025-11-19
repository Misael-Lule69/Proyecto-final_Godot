extends Control

# --- VARIABLES ---
@onready var click_sound = $ClickSound
# 1. Añade la referencia a tu música de fondo
@onready var background_music = $audio_fondo_menu

var is_changing_scene: bool = false
# 2. Define cuánto quieres que baje el volumen (en decibelios)
var volume_reduction_db: float = -12.0


# --- FUNCIONES ---

# 3. Inicia la música de fondo cuando el menú aparece
func _ready() -> void:
	background_music.play()


# 4. (OPTIMIZACIÓN) Tu lógica repetida en esta función
func _handle_transition(target_scene_path: String) -> void:
	# Revisa si ya estamos cambiando de escena
	if is_changing_scene:
		return # Si ya estamos en ello, no hagas nada
	
	# Activa el seguro
	is_changing_scene = true
	
	# 5. ¡AQUÍ ESTÁ LA MAGIA!
	# Baja el volumen de la música de fondo
	background_music.volume_db = volume_reduction_db
	
	# Reproduce el click y espera a que termine
	click_sound.play()
	await click_sound.finished
	
	# Realiza la acción final
	if target_scene_path == "quit":
		get_tree().quit()
	else:
		# --- ¡ESTA ES LA LÍNEA CORREGIDA! ---
		# Ahora usa la variable para cargar la escena correcta.
		get_tree().change_scene_to_file(target_scene_path)


# --- SEÑALES DE LOS BOTONES (Ahora todos completos) ---

func _on_nivel_1_pressed() -> void:
	_handle_transition("res://Nivel 1/nivel_1.tscn")

func _on_nivel_2_pressed() -> void:
	_handle_transition("res://Nivel2/nivel_2.tscn")


func _on_nivel_3_pressed() -> void:
	_handle_transition("res://Nivel3/nivel_3.tscn")


func _on_nivel_4_pressed() -> void:
	# CORRECCIÓN: Llamar a la transición para el nivel 4
	_handle_transition("res://Nivel4/nivel_4.tscn")


func _on_button_salir_pressed() -> void:
	# CORRECCIÓN: Llamar a la transición con "quit"
	_handle_transition("quit")
