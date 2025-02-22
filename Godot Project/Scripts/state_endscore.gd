extends GameState
class_name GameStateEndScore

@export var scores : Array[int] = []
@export var endscore : int = 0
@export var captach_result_node : Control

var result_inst = preload("res://Scenes/loop_result.tscn")
var is_on : bool = false

signal restart

func enter_state() -> void:
	is_on = true
	$MC/VB/Total/Value.text = ""
	$MC/VB/Conclusion.text = "RESULT :"
	for i in captach_result_node.get_children() : i.queue_free() # clean results
	show()
	update_results()


func exit_state() -> void:
	is_on = false
	scores.clear()
	hide()
	change_state_to(StateHandler.States.START)
	restart.emit()

func _input(event: InputEvent) -> void:
	if is_on and event is InputEventKey :
		exit_state()
	

func update_results():
	var ct : int = 0
	for i in scores:
		await get_tree().create_timer(1.0).timeout
		var inst : LoopResult = result_inst.instantiate()
		inst.score = i
		inst.no = ct+1
		ct += 1
		inst.update_result()
		captach_result_node.add_child(inst)
	$MC/VB/Total/Value.text = str(endscore)
	await get_tree().create_timer(1.0).timeout
	end_result()

func end_result():
	var loops = scores.size()
	@warning_ignore("integer_division")
	var median_score = endscore / loops
	
	if median_score < 50:
		$MC/VB/Conclusion.text = "RESULT : AI"
		return
	if median_score < 100:
		$MC/VB/Conclusion.text = "RESULT : HUMAN"
		return
	$EndGameSFX.play()
	$MC/VB/Conclusion.text = "RESULT : ALIEN"
	
