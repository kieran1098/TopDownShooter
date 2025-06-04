extends CharacterBody2D

# Movement
@export var move_speed := 300

# Shooting
@export var bullet_scene: PackedScene
@export var muzzle_flash_scene: PackedScene
@export var fire_rate := 0.2  # Seconds between shots

# Nodes
@onready var bullet_spawn := $Marker2D
@onready var muzzle_position := $Marker2D

# State
var can_shoot := true

func _physics_process(delta):
	# Movement with ARROW KEYS (original)
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	velocity = input_vector * move_speed
	move_and_slide()

	# Player rotation toward mouse
	look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		shoot()

func shoot():
	if !can_shoot or bullet_scene == null:
		return
	
	can_shoot = false
	get_tree().create_timer(fire_rate).timeout.connect(func(): can_shoot = true)
	
	# Create bullet
	var bullet = bullet_scene.instantiate()
	bullet.position = bullet_spawn.global_position
	
	if "direction" in bullet:
		bullet.direction = (get_global_mouse_position() - bullet.position).normalized()
	else:
		push_warning("Bullet scene is missing a 'direction' variable")
	
	get_tree().current_scene.add_child(bullet)
	
	# Muzzle flash
	if muzzle_flash_scene != null:
		var flash = muzzle_flash_scene.instantiate()
		flash.position = muzzle_position.global_position
		flash.rotation = global_rotation
		get_tree().current_scene.add_child(flash)
