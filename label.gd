extends Label

# Referencia al nodo de la animación (asegurate que sea hijo del Label)
@onready var animacion_moneda = $AnimatedSprite2D

func _ready() -> void:
	# Iniciamos la animación UNA sola vez al principio
	animacion_moneda.play("gold")

func _process(_delta: float) -> void:
	# Actualiza el texto en cada frame con el valor global
	text = "x " + str(Global.monedas)
