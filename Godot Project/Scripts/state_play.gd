extends GameState
class_name GameStatePlay
# ------------------------------------------------------------------------------ OVERIDE METHODS

func enter_state():
	show()
	$Playtime.start()

func exit_state():
	$Playtime.stop()
	prepare_screenshot()
	change_state_to(StateHandler.States.WAIT)
	
	
# ------------------------------------------------------------------------------ BASIC METHODS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Progress/Bar.value = $Playtime.time_left

# ------------------------------------------------------------------------------ CUSTOM METHODS
## Callled right before screenshot
func prepare_screenshot():
	$Progress.hide()

## Callled right AFTER screenshot, reset the view to default
func prepare_play():
	$Progress.show()
# ------------------------------------------------------------------------------ SIGNALS
func _on_playtime_timeout() -> void:
	exit_state()

func _on_wait_screen_ask_result() -> void:
	prepare_screenshot()
