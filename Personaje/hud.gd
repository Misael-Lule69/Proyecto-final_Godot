extends CanvasLayer

@onready var label_contador = $contador_monedas

func _process(_delta):
	$contador_monedas.text = str(Global.contador_monedas)
