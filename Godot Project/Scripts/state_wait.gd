extends GameState
class_name GameStateWait

signal ask_result

func enter_state():
	ask_result.emit()
	#await get_tree().create_timer(0.1).timeout # waiting for game state to receive call
	show()


func exit_state():
	hide()
	change_state_to(StateHandler.States.SCORE)

func _on_game_result_ready() -> void:
	exit_state()
