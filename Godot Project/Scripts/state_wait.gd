extends GameState
class_name GameStateWait

signal ask_result

func enter_state():
	show()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	#ask_result.emit()
	#await get_tree().create_timer(0.1).timeout # waiting for game state to receive call
	exit_state()


func exit_state():
	change_state_to(StateHandler.States.SCORE)

func _on_game_result_ready() -> void:
	exit_state()
