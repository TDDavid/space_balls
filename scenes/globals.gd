extends Node

var DEBUG_ENABLED: bool = false

signal debug_toggled

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggle_debug"):
		DEBUG_ENABLED = !DEBUG_ENABLED
		debug_toggled.emit(DEBUG_ENABLED)
