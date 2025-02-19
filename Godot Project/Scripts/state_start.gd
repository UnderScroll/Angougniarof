extends GameState
class_name GameStateStart

var is_on : bool = true

func enter_state():
	is_on = true
	show()

func exit_state():
	is_on = false
	hide()

func _input(event: InputEvent) -> void:
	if is_on and event is InputEventKey :
		change_state_to(StateHandler.States.PLAY)
