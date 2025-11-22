extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const GRAVITY = 980.0

# CORREGIDO: Apuntar a la escena gameover.tscn, no a una imagen
@export var max_fall_distance: float = 1000
@export var game_over_scene: String = "res://gameover.tscn"

@onready var personaje = $Sprite2D
@onready var animacion = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# Verificar si cayó demasiado
	if global_position.y > max_fall_distance:
		game_over()
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	animaciones(direction)
	move_and_slide()
	
	if velocity.y > GRAVITY:
		
		Global.scene = get_tree().current_scene.scene_file_path
	
		print(Global.scene)
	
		terminar()

	if direction == 1:
		personaje.flip_h = false
	elif direction == -1:
		personaje.flip_h = true

func animaciones(direction):
	if is_on_floor():
		if direction == 0:
			animacion.play("Reposo")
		else:
			animacion.play("Correr") 
	else:
		if velocity.y > 0:
			animacion.play("Caer")
		elif velocity.y < 0:
			animacion.play("Saltar")
			

func game_over():
	print("¡Personaje cayó demasiado! Game Over")
	get_tree().change_scene_to_file(game_over_scene)

	
func terminar():
	
	set_process(false)
	
	get_tree().change_scene_to_file("res://Pantalla-muerte/game_over.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://Pantalla_pausa/pantalla_pausa.tscn")
