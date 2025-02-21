extends HBoxContainer
class_name LoopResult

@export var no : int = 1
@export var score : int = 50

func update_result():
	$Name.text = "- Captacha " + str(no) + " : "
	$Score.text = str(score)
