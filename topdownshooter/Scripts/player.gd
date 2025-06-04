extends CharacterBody2D

@export var move_speed := 300
@export var bullet_scene: PackedScene  # Drag your bullet scene into this in the Inspector

@onready var bullet_spawn := $Marker2D  # Optional spawn point (add a Marker2D as a child of the player)

func _physics_process(delta):
	# Movement
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * move_speed
	move_and_slide()

	# Face the mouse
	look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func shoot():
	if bullet_scene == null:
		return

	var bullet = bullet_scene.instantiate()
	bullet.position = bullet_spawn.global_position  # Where the bullet starts
	bullet.direction = (get_global_mouse_position() - bullet.position).normalized()  # Requires the bullet to have a `direction` variable
	get_tree().current_scene.add_child(bullet)
