extends CharacterBody2D

const SPEED = 60.0
const GRAVITY = 980.0

# 1 = Derecha, -1 = Izquierda
var direction = 1 
var esta_muerto = false # Nueva variable para controlar el estado

@onready var ray_suelo = $RayCast2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	# Iniciamos con la animación de moverse por defecto
	sprite.play("slime_move")

func _physics_process(delta: float) -> void:
	# Si está muerto, detenemos toda la lógica de movimiento y gravedad
	if esta_muerto:
		return

	# 1. Aplicar Gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# 2. Detectar si hay que darse la vuelta
	if is_on_wall() or not ray_suelo.is_colliding():
		voltear()
	
	# 3. Moverse
	velocity.x = direction * SPEED
	
	# Nos aseguramos de que reproduzca la animación de caminar si se está moviendo
	if abs(velocity.x) > 0:
		sprite.play("slime_move")
	else:
		sprite.play("slime_idle")
		
	move_and_slide()

func voltear():
	direction *= -1 
	sprite.flip_h = !sprite.flip_h
	ray_suelo.position.x *= -1

# Esta función se llama cuando TU ATACAS al slime
func recibir_dano():
	if esta_muerto: return # Evita que muera dos veces
	
	esta_muerto = true
	
	# Detenemos al enemigo en seco
	velocity = Vector2.ZERO
	
	# Desactivamos su colisión y hitbox para que no te haga daño mientras muere
	$CollisionShape2D.set_deferred("disabled", true)
	if has_node("Area2D"): # Asumiendo que tu hitbox se llama Area2D
		$Area2D.set_deferred("monitoring", false)
	
	# Reproducimos animación de muerte
	print("El slime ha muerto")
	sprite.play("slime_die")
	
	# Esperamos a que termine la animación antes de borrarlo
	await sprite.animation_finished
	queue_free()

# Esta función se llama cuando EL SLIME TE TOCA A TI
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Si el slime ya está muerto, no debería hacer daño
	if esta_muerto: return

	if body.is_in_group("player"):
		print("¡El slime ataca al jugador!")
		
		# Opcional: Reproducir animación de ataque antes de matar al jugador
		sprite.play("slime_attack")
		
		if body.has_method("die"):
			body.die()
