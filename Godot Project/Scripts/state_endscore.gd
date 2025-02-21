extends GameState
class_name GameStateEndScore

@export var scores : Array[int] = []
@export var endscore : int = 0
@export var captach_result_node : Control

var result_inst = preload("res://Scenes/loop_result.tscn")



func enter_state() -> void:
	$MC/VB/Conclusion.text = "RESULT :"
	update_results()
	show()

func exit_state() -> void:
	scores.clear()
	hide()

func update_results():
	for i in captach_result_node.get_children() : i.queue_free() # clean results
	var ct : int = 0
	for i in scores:
		var inst : LoopResult = result_inst.instantiate()
		inst.score = i
		inst.no = ct+1
		ct += 1
		inst.update_result()
		captach_result_node.add_child(inst)
	end_result()

func end_result():
	$MC/VB/Total/Value.text = str(endscore)
	var loops = scores.size()
	var median_score = endscore / loops
	
	if median_score < 50:
		$MC/VB/Conclusion.text = "RESULT : AI"
		return
	if median_score < 100:
		$MC/VB/Conclusion.text = "RESULT : HUMAN"
		return
	
	$MC/VB/Conclusion.text = "RESULT : ALIEN"
	
		
