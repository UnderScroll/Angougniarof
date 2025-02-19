extends GameState
class_name GameStatePlay

func enter_state():
	show()
	set_process(true)
	$Playtime.start()

func exit_state():
	set_process(false)
	$Playtime.stop()
	change_state_to(StateHandler.States.SCORE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Progress/Bar.value = $Playtime.time_left

func _on_playtime_timeout() -> void:
	exit_state()
