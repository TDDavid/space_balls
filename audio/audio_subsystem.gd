extends Node2D

var is_muted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_music_volume(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("mute"):
		is_muted = not is_muted
		set_music_volume(1 if is_muted else 0)

func set_music_volume(volume: float):
	$SFX_Button_Hover.set_volume_db(linear_to_db(volume))
	$SFX_Button_Click.set_volume_db(linear_to_db(volume))
	$SFX_Shoot_Ball.set_volume_db(linear_to_db(volume))
	$SFX_Reload_Ball.set_volume_db(linear_to_db(volume))
	$Music_Gameplay.set_volume_db(linear_to_db(volume))
