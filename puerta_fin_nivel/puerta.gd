extends Area2D

@export var monedas_necesarias : int = 15
@export_file("*.tscn") var siguiente_nivel
@export var es_ultimo_nivel : bool = false

var escena_victoria = preload("res://pantalla_victoria/pantalla_victoria.tscn")
var escena_menu = preload("res://Menu/pantalla_Menu.tscn")

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("idle_door")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Global.monedas >= monedas_necesarias:
			call_deferred("abrir_y_finalizar")
		else:
			print("Faltan monedas.")

func abrir_y_finalizar():
	# ⚠️ SI ES EL ÚLTIMO NIVEL → IR DIRECTO AL MENÚ
	if es_ultimo_nivel:
		print("Nivel final. Enviando al menú...")
		get_tree().change_scene_to_packed(escena_menu)
		return

	# --- SOLO SI NO ES EL ÚLTIMO NIVEL ---
	var tween = create_tween()
	tween.tween_property(anim, "modulate:a", 0.0, 1.0)

	await tween.finished
	mostrar_victoria()

func mostrar_victoria():
	var victoria = escena_victoria.instantiate()

	if siguiente_nivel != null:
		victoria.ruta_siguiente_nivel = siguiente_nivel
	else:
		print("ADVERTENCIA: no hay siguiente nivel asignado.")

	get_tree().root.add_child(victoria)
