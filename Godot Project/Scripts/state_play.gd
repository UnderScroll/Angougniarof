extends GameState
class_name GameStatePlay

# ------------------------------------------------------------------------------ OVERIDE METHODS


func enter_state():
	show()
	prepare_play()
	$TimerUI/icon.max_value = $Playtime.wait_time
	$Playtime.start()

func exit_state():
	$Playtime.stop()
	prepare_screenshot()
	$AnimationPlayer.play("time_up")
	await $AnimationPlayer.animation_finished
	
	change_state_to(StateHandler.States.WAIT)
	
	
# ------------------------------------------------------------------------------ BASIC METHODS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimerUI/icon.value = $Playtime.time_left
	var s = int($Playtime.time_left)
	var ms = ($Playtime.time_left - s) * 100
	$TimerUI/P/MP/TimerLabel.text = "%02d:%02d" % [s, ms]

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
