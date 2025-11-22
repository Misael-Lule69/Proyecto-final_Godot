extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const umbral = 1000

@onready var personajen3=$AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	animaciones(direction)
	move_and_slide()
	
	if velocity.y > umbral:
		
		Global.scene = get_tree().current_scene.scene_file_path
	
		print(Global.scene)
	
		terminar()
	
	if direction == 1:
		personajen3.flip_h = false
	elif direction == -1:
		personajen3.flip_h = true
		
func animaciones(direction):
	if is_on_floor():
		if direction == 0:
			personajen3.play("new_Idle")
		else:
			personajen3.play("new_Run") 
	else:
		if velocity.y > 0:
			personajen3.play("Caer")
		elif velocity.y < 0:
			personajen3.play("new_Jump")

func terminar():
	
	set_process(false)
	
	get_tree().change_scene_to_file("res://gameover.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://menu.tscn")
