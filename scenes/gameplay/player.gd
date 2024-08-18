extends Node2D

signal add_ball
signal add_ball_auto

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("spawn_ball"):
		add_ball.emit()
	if Input.is_action_just_pressed("auto_spawn_ball"):
		add_ball_auto.emit()
	
