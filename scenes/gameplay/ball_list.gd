class_name BallList

@export var list: Array = []
var max_size = 999

var last_head_pos: Vector2

# ball list direction
# movement: <------------
# balls in list: X X X X X X X
# index in list: 0 1 2 3 4 5 6

signal matched_count

func process(delta):
	var count: int = list.size()
	var current_color: Color
	var current_matches: Array = []
	var all_matches: Array = []
	var has_current_color = false
	while count > 0:
		var idx = count - 1
		update_progress(delta, idx)
				
		var obj_color = list[idx]["ball"].modulate
		if count == list.size():
			current_color = obj_color
			current_matches.append(idx)
			has_current_color = true
		elif obj_color == current_color:
			current_matches.append(idx)
			has_current_color = true
		else:
			if has_current_color and current_matches.size() >= 3:
				all_matches.append(current_matches.duplicate())
			current_matches.clear()
			current_color = obj_color
			current_matches.append(idx)
			has_current_color = true
				
		count -= 1
	
	for indexes in all_matches:
		matched_count.emit(indexes.size())
		for idx in indexes:
			var remove_ball = list[idx]["ball"]
			list.remove_at(idx)
			remove_ball.queue_free()

func update_progress(delta, idx):
	if idx == (list.size() - 1):
		var new_pos = list[idx]["ball"].global_position
		
		list[idx]["velocity"] = new_pos - last_head_pos
		list[idx]["progress"] += delta * list[idx]["ball"].SPEED
		
		last_head_pos = new_pos
	else:
		var old_pos = list[idx]["ball"].global_position
		var new_pos = list[idx - 1]["ball"].global_position
		list[idx]["velocity"] = new_pos - old_pos
		list[idx]["progress"] = list[idx + 1]["progress"] - 30
	

func add_ball(new_ball: Ball):
	list.insert(0, {"ball": new_ball, "progress": 0})
	
func add_ball_after(new_ball: Ball, at_id: int, after: bool = true):
	var idx: int = 0
	var item_to_add
	var add_at_index
	for ball in list:
		var curr_ball = ball["ball"]
		if curr_ball.id == at_id:
			add_at_index = idx if after else idx + 1
			item_to_add = {"ball": new_ball, "progress": list[idx]["progress"]}
			
		if curr_ball.id >= at_id:
			ball["progress"] -= 30
			
		idx += 1
	
	#print("Add ball at index %d, collided with id %d" % [add_at_index, at_id])
	
	list.insert(add_at_index, item_to_add)
	
func get_data(id: int) -> Dictionary:
	var retval: Dictionary
	for ball in list:
		if ball["ball"].id == id:
			retval = ball
			break
	
	return retval
	
func get_ball(id: int) -> Ball:
	var retval: Ball
	for ball in list:
		if ball["ball"].id == id:
			retval = ball["ball"]
			break
	
	return retval
	
func is_full():
	return list.size() >= max_size
