extends Area2D

# --- ESTAS SON LAS LÍNEAS QUE TE FALTABAN ---
@export var monedas_necesarias : int = 3
@export_file("*.tscn") var siguiente_nivel 
# ---------------------------------------------

var escena_victoria = preload("res://pantalla_victoria/pantalla_victoria.tscn")
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	# Reproduce tu animación de puerta cerrada
	anim.play("idle_door")

func _on_body_entered(body: Node2D) -> void:
	# CHIVATO 1: Confirmamos si el juego detecta el choque
	print("¡ALGO tocó la puerta! Es: ", body.name)

	if body.is_in_group("player"):
		print("Es el jugador. Monedas actuales: ", Global.monedas)
		
		if Global.monedas >= monedas_necesarias:
			print("¡Abriendo puerta!")
			call_deferred("abrir_y_finalizar")
		else:
			print("Faltan monedas. Necesitas: ", monedas_necesarias)

func abrir_y_finalizar():
	# Animación por código (Tween) porque solo tienes una imagen
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 0.0, 1.0) # Desaparece en 1 seg
	
	await tween.finished
	mostrar_victoria()

func mostrar_victoria():
	var victoria = escena_victoria.instantiate()
	victoria.ruta_siguiente_nivel = siguiente_nivel
	get_tree().root.add_child(victoria)
