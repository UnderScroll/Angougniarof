extends GameState
class_name GameStatePlay

# ------------------------------------------------------------------------------ OVERIDE METHODS
signal ask_reference
signal ask_result

func enter_state():
	$AnimationPlayer.play("RESET")
	await $AnimationPlayer.animation_finished
	var crt_mat = $CRTFilter.material
	crt_mat.set_shader_parameter("static_noise_intensity", 0.0)
	$Shadow.random_shadow()
	$Shadow.scale = Vector2(0.0,0.0)
	show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Shadow, "scale", Vector2(1.0,1.0), 1.5)
	await tween.finished
	
	prepare_screenshot()
	await get_tree().create_timer(0.1).timeout
	ask_reference.emit()


func exit_state():
	$Playtime.stop()
	prepare_screenshot()
	await get_tree().create_timer(0.1).timeout
	ask_result.emit() 

# ------------------------------------------------------------------------------ BASIC METHODS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$TimerUI/icon.value = $Playtime.time_left
	var s = int($Playtime.time_left)
	var ms = ($Playtime.time_left - s) * 100
	$TimerUI/P/MP/TimerLabel.text = "%02d:%02d" % [s, ms]

# ------------------------------------------------------------------------------ CUSTOM METHODS
## Callled right before screenshot
func prepare_screenshot():
	$GPUParticles2D.hide()
	$GPUParticles2D.restart()
	$Progress.hide()
	$BG.hide()
	$CRTFilter.hide()
	$TimerUI.hide()
	

## Callled right AFTER screenshot, reset the view to default
func prepare_play():
	$Progress.show()
	$BG.show()
	$CRTFilter.show()
	$TimerUI.show()
	$GPUParticles2D.show()

func static_tween_fx():
	var crt_mat = $CRTFilter.material
	crt_mat.set_shader_parameter("static_noise_intensity", 0.0)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(crt_mat,"shader_parameter/static_noise_intensity", 0.4, $Playtime.wait_time)

# ------------------------------------------------------------------------------ SIGNALS
func _on_playtime_timeout() -> void:
	exit_state()
	

func _on_wait_screen_ask_result() -> void:
	prepare_screenshot()

func _on_game_result_ready() -> void:
	$AnimationPlayer.play("time_up")
	await $AnimationPlayer.animation_finished
	change_state_to(StateHandler.States.WAIT)

func _on_game_reference_ready():
	prepare_play()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	$TimerUI/icon.max_value = $Playtime.wait_time
	
	$Playtime.start()
	static_tween_fx()
