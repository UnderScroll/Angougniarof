extends GameState
class_name GameStateScore

@export var score_label : Label
## goes from 0% to 100% -> match between the prompt and the shadow
var score : float = 0.0

func enter_state():
	show()

func exit_state():
	hide()
	change_state_to(StateHandler.States.PLAY)

func reveal():
	pass
