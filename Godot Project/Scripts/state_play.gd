extends GameState
class_name GameStatePlay

# ------------------------------------------------------------------------------ OVERIDE METHODS
signal ask_reference
signal ask_result

#@export var audio_nodes : Array[AudioStreamPlayer] = []
#@export_group("audio nodes")
#@export var audio_enter : AudioStreamPlayer
#@export var audio_exit : AudioStreamPlayer
#@export var audio_ente : AudioStreamPlayer
#@export var audio_ent : AudioStreamPlayer
#@export var audio_en : AudioStreamPlayer

var previous_int : int = 0

func enter_state():
	$AnimationPlayer.play("RESET")
	await $AnimationPlayer.animation_finished
	var crt_mat = $CRTFilter.material
	crt_mat.set_shader_parameter("static_noise_intensity", 0.0)
	$SFX_CRT.play()
	$Shadow.show()
	$Shadow.random_shadow()
	$Shadow.scale = Vector2(0.0,0.0)
	show()
	$ShapeAppear.play()
	fade_in_ambGame()
	$AudioGameAmb_Random.play()
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
	$Shadow.hide()
	fade_out_ambGame()
	await get_tree().create_timer(0.5).timeout
	ask_result.emit() 

# ------------------------------------------------------------------------------ BASIC METHODS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not $Playtime.is_stopped():
		$TimerUI/icon.value = $Playtime.time_left
		var s = int($Playtime.time_left)
		
		if previous_int != s :
			previous_int = s
			if s % 2 == 0 and s >= 10.0:
				$TimerTick.play()
			if s % 2 == 0 and s < 10.0 and s > 0:
				$TimerTense.play()
			if s == 2:
				$EndAudio.play()
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
	tween.tween_property(crt_mat,"shader_parameter/static_noise_intensity", 1.0, $Playtime.wait_time)

# ------------------------------------------------------------------------------ SIGNALS
func _on_playtime_timeout() -> void:
	exit_state()
	

func _on_wait_screen_ask_result() -> void:
	prepare_screenshot()

func _on_game_result_ready() -> void:
	$AnimationPlayer.play("time_up")
	$TimesUpVoice.play()
	await $AnimationPlayer.animation_finished
	change_state_to(StateHandler.States.WAIT)

func _on_game_reference_ready():
	prepare_play()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	$TimerUI/icon.max_value = $Playtime.wait_time
	$Playtime.start()
	static_tween_fx()

func fade_in_ambGame():
	var tween = create_tween()
	tween.tween_property($AudioGameAmb_Random, "volume_db", 0, 0.5)
	
func fade_out_ambGame():
	var tween = create_tween()
	tween.tween_property($AudioGameAmb_Random, "volume_db", -80, 0.8)
	tween.tween_callback($AudioGameAmb_Random.stop)

func fade_in_music():
	var tween = create_tween()
	tween.tween_property($BGM, "volume_db", 0, 1)

func fade_out_music():
	var tween = create_tween()
	tween.tween_property($BGM, "volume_db", -80, 1)
	tween.tween_callback($BGM.stop)

func _on_start_screen_timer_length_changed(value) -> void:
	$Playtime.wait_time = value
	pass # Replace with function body.

func _on_end_score_restart() -> void:
	fade_out_music()
