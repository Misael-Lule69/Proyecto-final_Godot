extends Area2D

@onready var mg = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D
# 1. NUEVA REFERENCIA a las partículas
@onready var particulas =$CPUParticles2D

var recogida = false 

func _ready() -> void:
	mg.play("gold_coin")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not recogida:
		recogida = true 
		Global.monedas += 1
		
		# 2. Escondemos la moneda
		mg.visible = false 
		
		# 3. ¡ACTIVAMOS LA EXPLOSIÓN!
		particulas.emitting = true
		
		# 4. Reproducimos sonido
		audio.play()
		
		# 5. Esperamos (el tiempo que tarda el audio suele ser
		# suficiente para que las partículas terminen su animación)
		await audio.finished
		
		queue_free()
