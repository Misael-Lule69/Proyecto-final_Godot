extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -450.0
const DEATH_HEIGHT = 1000
const GRAVITY = 980 

var is_dead: bool = false
var is_attacking: bool = false

# Nodos Internos
@onready var sprite_animado = $AnimatedSprite2D2
@onready var muerte_sound = $MuerteSound
@onready var hitbox_ataque = $HitboxAtaque # Asegúrate que tu nodo se llame así
@onready var pausa_menu = get_tree().current_scene.get_node_or_null("Pantalla_pausa")

func _ready() -> void:
	# Conectamos la señal para saber cuando termina el ataque
	if sprite_animado:
		sprite_animado.animation_finished.connect(_on_animation_finished)
	
	# Apagamos la hitbox al iniciar
	if hitbox_ataque:
		hitbox_ataque.monitoring = false
	else:
		print("¡CUIDADO! No encuentro el nodo HitboxAtaque")

func _physics_process(delta: float) -> void:
	if is_dead: return

	if is_attacking:
		velocity.x = 0 # Frenamos al personaje para que no patine
		move_and_slide()
		return

	if global_position.y > DEATH_HEIGHT:
		die()
		return
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# ATACAR
	if Input.is_action_just_pressed("atacar") and is_on_floor():
		atacar()
	
	if Input.is_action_just_pressed("pausa"):
		toggle_pausa()

	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		
		# Volteamos la Hitbox y el Sprite
		if direction > 0:
			sprite_animado.flip_h = false
			if hitbox_ataque: hitbox_ataque.scale.x = 1 
		elif direction < 0:
			sprite_animado.flip_h = true
			if hitbox_ataque: hitbox_ataque.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
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
	
	# Ya no intentamos parar la música de fondo aquí
	if muerte_sound: muerte_sound.play()
	
	sprite_animado.play("die_cat")
	await get_tree().create_timer(2.5).timeout
	Global.scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Pantalla-muerte/game_over.tscn")

func atacar():
	is_attacking = true
	sprite_animado.play("slash_cat")
	if hitbox_ataque:
		hitbox_ataque.monitoring = true

func _on_animation_finished():
	if sprite_animado.animation == "slash_cat":
		is_attacking = false
		sprite_animado.play("idle_cat")
		if hitbox_ataque:
			hitbox_ataque.monitoring = false

func animaciones(direction) -> void:
	if is_dead or is_attacking: return

	if is_on_floor():
		if direction == 0:
			sprite_animado.play("idle_cat")
		else:
			sprite_animado.play("run_cat")
	else:
		sprite_animado.play("idle_cat")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Pantalla_pausa/pantalla_pausa.tscn")

func _on_hitbox_ataque_body_entered(body: Node2D) -> void:
	if body.has_method("recibir_dano"):
		print("¡Golpe al enemigo!")
		body.recibir_dano()
