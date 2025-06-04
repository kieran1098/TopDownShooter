extends Area2D

@export var speed := 800
var direction := Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func _on_visibility_notifier_2d_screen_exited():
	queue_free()
