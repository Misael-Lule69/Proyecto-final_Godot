extends Area2D

@onready var anim_player = $AnimationPlayer
@onready var sonido = $AudioStreamPlayer2D

func _ready():
	anim_player.play("coins") # La animación en loop

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Moneda recogida!")

		Global.contador_monedas += 1


		# Reproduce sonido
		sonido.play()

		# Desactiva colisión para que no cuente dos veces
		$CollisionShape2D.disabled = true

		# Espera a que termine el sonido
		await sonido.finished

		# Elimina la moneda
		queue_free()
