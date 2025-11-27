extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -400.0
const DEATH_HEIGHT = 1000
const GRAVITY = 980 

var is_dead: bool = false
var is_attacking: bool = false # ¡Recuperamos esta variable para usar 'slash_cat'!

# Nodos
@onready var sprite_animado = $AnimatedSprite2D2
@onready var muerte_sound = $MuerteSound
@onready var musica_fondo = $"../../AudioStreamPlayer2D"
@onready var pausa_menu = get_tree().current_scene.get_node_or_null("Pantalla_pausa")

func _ready() -> void:
	# Conectamos la señal para saber cuando termina el ataque
	if sprite_animado:
		sprite_animado.animation_finished.connect(_on_animation_finished)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Si está atacando, no dejamos que se mueva (opcional)
	if is_attacking:
		move_and_slide() # Mantiene la inercia pero no controlas
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

# Lógica de Ataque (ACTUALIZADA)
	# Ahora detectamos la acción "atacar" que acabas de crear
	if Input.is_action_just_pressed("atacar") and is_on_floor():
		atacar()
	
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
		sprite_animado.flip_h = false
	elif direction == -1:
		sprite_animado.flip_h = true
	
	animaciones(direction)
	move_and_slide()

func toggle_pausa():
	if get_tree().paused:
		get_tree().paused = false
		if pausa_menu: pausa_menu.hide()
	else:
		get_tree().paused = true
		if pausa_menu: pausa_menu.show()

func die() -> void:
	if is_dead: return
	is_dead = true
	velocity = Vector2.ZERO
	
	if musica_fondo: musica_fondo.stop()
	if muerte_sound: muerte_sound.play()
	
	# Animación correcta de muerte según tu imagen
	sprite_animado.play("die_cat")
	
	await get_tree().create_timer(2.5).timeout
	Global.scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Pantalla-muerte/game_over.tscn")

# Función nueva para activar el ataque
func atacar():
	is_attacking = true
	sprite_animado.play("slash_cat")

# Detecta cuando termina la animación (importante para el ataque)
func _on_animation_finished():
	if sprite_animado.animation == "slash_cat":
		is_attacking = false

func animaciones(direction) -> void:
	if is_dead or is_attacking:
		return

	if is_on_floor():
		if direction == 0:
			sprite_animado.play("idle_cat")
		else:
			sprite_animado.play("run_cat")
	else:
		# COMO NO TIENES ANIMACIÓN DE SALTO NI CAÍDA EN LA IMAGEN:
		# Usamos 'idle_cat' o 'run_cat' para que no se vea error.
		# Opcional: Si 'pull_cat' parece un salto, úsala aquí.
		if velocity.y < 0:
			sprite_animado.play("idle_cat") # Subiendo
		else:
			sprite_animado.play("idle_cat") # Cayendo

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Pantalla_pausa/pantalla_pausa.tscn")
