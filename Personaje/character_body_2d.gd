extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -400.0
const DEATH_HEIGHT = 1000
const GRAVITY = 980 

# La variable 'is_attacking' ha sido eliminada.
var is_dead: bool = false

# Nodos
@onready var sprite_animado = $AnimatedSprite2D 
@onready var muerte_sound = $MuerteSound
@onready var musica_fondo = $"../../AudioStreamPlayer2D"
@onready var pausa_menu = get_tree().current_scene.get_node_or_null("Pantalla_pausa")

func _ready() -> void:
	# La conexión a 'animation_finished' ha sido eliminada ya que no se necesita para el ataque.
	pass 

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if global_position.y > DEATH_HEIGHT:
		die()
		return
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Lógica de pausa
	if Input.is_action_just_pressed("pausa"):
		toggle_pausa()
	# Lógica de movimiento
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Control de volteo (flip_h)
	if direction == 1:
		if sprite_animado:
			sprite_animado.flip_h = false
	elif direction == -1:
		if sprite_animado:
			sprite_animado.flip_h = true
	
	animaciones(direction)
	move_and_slide()

func toggle_pausa():
	if get_tree().paused:
		get_tree().paused = false
		if pausa_menu:
			pausa_menu.hide()
	else:
		get_tree().paused = true
		if pausa_menu:
			pausa_menu.show()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	
	# Protección de nulos
	if musica_fondo:
		musica_fondo.stop()
		
	if muerte_sound:
		muerte_sound.play()
	
	if sprite_animado:
		sprite_animado.play("Dead")
	
	await get_tree().create_timer(2.5).timeout
	
	Global.scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Pantalla-muerte/game_over.tscn")

# La función '_on_animation_finished' (lógica de ataque) ha sido eliminada.

func animaciones(direction) -> void:
	# La verificación 'is_attacking' ha sido eliminada.
	if is_dead:
		return

	if sprite_animado: 
		if is_on_floor():
			if direction == 0:
				sprite_animado.play("idle")
			else:
				sprite_animado.play("run")
		else:
			if velocity.y < 0:
				sprite_animado.play("jump")
			else:
				sprite_animado.play("slide")


func _on_button_pressed() -> void:
	pass # Replace with function body.
