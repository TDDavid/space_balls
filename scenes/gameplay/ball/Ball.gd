extends CharacterBody2D
class_name Ball

@export var initial_direction: Vector2
@export var id: int
@export var direction: Vector2

@export var SPEED = 250.0

var already_collided: bool = false
signal collided_with

func _ready():
	direction = initial_direction
	$Label.text = str(id)
	$Label.visible = Globals.DEBUG_ENABLED
	Globals.connect("debug_toggled", toggle_label)

func toggle_label(enabled: bool):
	$Label.visible = enabled

func _physics_process(delta):
	if !already_collided:
		var collision = move_and_collide(velocity)
		if collision:
			already_collided = true
			var ball = collision.get_collider() as Ball
			if ball:
				collided_with.emit(self, ball.id)
	
		velocity = direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func set_color(col: Color):
	modulate = col
