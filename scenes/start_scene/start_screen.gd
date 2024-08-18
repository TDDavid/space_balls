extends Control

var simultaneous_scene = preload("res://scenes/level_one/level_one.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_exit_pressed():
	AudioSubsystem.get_node("SFX_Button_Click").play()
	await AudioSubsystem.get_node("SFX_Button_Click").finished
	get_tree().quit()

func _on_button_start_pressed():
	AudioSubsystem.get_node("SFX_Button_Click").play()
	await AudioSubsystem.get_node("SFX_Button_Click").finished
	get_node(".").queue_free()
	get_tree().root.add_child(simultaneous_scene)


func _on_button_start_mouse_entered():
	AudioSubsystem.get_node("SFX_Button_Hover").play()


func _on_button_exit_mouse_entered():
	AudioSubsystem.get_node("SFX_Button_Hover").play()
	
