extends Area2D

@onready var mg = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D # Referencia al nodo de audio

# Variable para evitar que la moneda se recoja dos veces mientras suena
var recogida = false 

func _ready() -> void:
	mg.play("gold_coin")

func _on_body_entered(body: Node2D) -> void:
	# Verificamos si es el jugador Y si la moneda no ha sido recogida aún
	if body.is_in_group("player") and not recogida:
		recogida = true # Marcamos como recogida inmediatamente
		
		# 1. Sumar puntos
		Global.monedas += 1
		print("Total monedas: ", Global.monedas)
		
		# 2. Hacer la moneda invisible (parece que desapareció)
		mg.visible = false 
		
		# 3. Reproducir el sonido
		audio.play()
		
		# 4. Esperar a que el sonido termine
		await audio.finished
		
		# 5. AHORA SÍ, borramos el objeto
		queue_free()
