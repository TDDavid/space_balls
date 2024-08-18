extends Node2D

var ball = preload("res://scenes/gameplay/ball/Ball.tscn")
var list = BallList.new()
var colors = [Color.RED, Color.ORANGE, Color.GREEN]

var ball_id: int = 0

var curr_ball: Ball
var ball_being_added: bool = false

var time_start = 0
var time_now = 0

var score_counter = 0

func add_first_ball():
	var first_ball = ball.instantiate() as Ball
	first_ball.set_color(colors.pick_random())
	ball_id += 1
	first_ball.id = ball_id
	first_ball.collided_with.connect(_on_ball_collided_with)
	var path_to_follow = PathFollow2D.new()
	$Path2D.add_child(path_to_follow)
	first_ball.position = Vector2(0,0)
	path_to_follow.add_child(first_ball)
	
	list.add_ball(first_ball)

func toggle_vel_vector(enabled: bool):
	$Line2D.visible = enabled

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("debug_toggled", toggle_vel_vector)
	$Line2D.visible = Globals.DEBUG_ENABLED
	
	var path_length = $Path2D.curve.get_baked_length()
	var possible_ball_count = path_length / 30
	list.max_size = possible_ball_count
	time_start = Time.get_unix_time_from_system()
	
	add_first_ball()
	
	list.connect("matched_count", on_matched_count)
	AudioSubsystem.get_node("Music_Gameplay").play()
	prepare_ball()

func on_matched_count(count: int):
	score_counter += count
	$VBoxContainer/HBoxContainer2/valueScore.set_text(str(score_counter))
	
func prepare_ball():
	curr_ball = ball.instantiate() as Ball
	curr_ball.position = $Player.position
	curr_ball.set_color(colors.pick_random())
	ball_id += 1
	curr_ball.id = ball_id
	curr_ball.collided_with.connect(_on_ball_collided_with)
	add_child(curr_ball)
	AudioSubsystem.get_node("SFX_Reload_Ball").play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	list.process(delta)
	if list.list.size() > 0:
		var pos1 = list.list[list.list.size() - 1]["ball"].global_position
		var ball_velocity = list.list[list.list.size() - 1]["velocity"].normalized()
		$Line2D.clear_points()
		$Line2D.add_point(pos1)
		$Line2D.add_point(pos1 + ball_velocity * 50)
		
	var elapsed_time = Time.get_unix_time_from_system() - time_start
	$VBoxContainer/HBoxContainer/valueTime.set_text(str(floor(elapsed_time)))
	for ball in list.list:
		var ball_path = ball["ball"].get_parent()
		ball_path.progress = ball["progress"]
		var add = 1 + floor(elapsed_time / 5) / 10
		ball["ball"].SPEED = 100 * add

func _on_player_add_ball():
	if !ball_being_added and curr_ball and !list.is_full():
		ball_being_added = true
		AudioSubsystem.get_node("SFX_Shoot_Ball").play()
		curr_ball.direction = curr_ball.position.direction_to(get_global_mouse_position())
		await get_tree().create_timer(.2).timeout
		prepare_ball()
		ball_being_added = false
	
func _on_ball_collided_with(projectile: Ball, collided_with: int):
	var collided_with_data = list.get_data(collided_with)
	if collided_with_data:
		var ball = collided_with_data["ball"]
		var pos1 = ball.global_position
		var pos2 = projectile.global_position
		var ball_velocity: Vector2 = collided_with_data["velocity"].normalized()
		var pos_vector = (pos1 - pos2).normalized()
		var sqr_vel = sqrt(pow(ball_velocity.x, 2) + pow(ball_velocity.y, 2))
		var sqr_pos = sqrt(pow(pos_vector.x, 2) + pow(pos_vector.y, 2))
		var angle = acos((ball_velocity.dot(pos_vector))/(sqr_vel * sqr_pos))
		
		
		var path_to_follow = PathFollow2D.new()
		if angle >= 90:
			list.add_ball_after(projectile, collided_with)
		else:
			list.add_ball_after(projectile, collided_with, false)
		$Path2D.add_child(path_to_follow)
		projectile.position = Vector2(0,0)
		projectile.reparent(path_to_follow, false)


func _on_player_add_ball_auto():
	var not_running = $TimerAddBallAuto.is_stopped()
	var running = !not_running
	
	if running:
		$TimerAddBallAuto.stop()
		$VBoxContainer/labelAutospawn.hide()
	
	if not_running and !list.is_full():
		$TimerAddBallAuto.start(.25)
		$VBoxContainer/labelAutospawn.show()

func _on_timer_add_ball_auto_timeout():
	if list.is_full():
		$TimerAddBallAuto.stop()
		$VBoxContainer/labelAutospawn.hide()
	else:
		_on_player_add_ball()
	
	
