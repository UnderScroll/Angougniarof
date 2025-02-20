extends GameState
class_name GameStateWait



func enter_state():
	show()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	exit_state()


func exit_state():
	change_state_to(StateHandler.States.SCORE)

func _on_game_result_ready() -> void:
	exit_state()
