extends GameState
class_name GameStateStart

var is_on : bool = true

signal no_games_changed
signal timer_length_changed

func _ready():
	enter_state()

func enter_state():
	show()
	$AnimationPlayer.play("RESET")
	await $AnimationPlayer.animation_finished
	fade_in_ambGame()
	$IntroAudio.play(1.02)
	$AmbBG.play()
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	$MusicLoop.play()
	is_on = true
	
	
func exit_state():
	$Clic.play()
	is_on = false
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	fade_out_ambGame()
	hide()
	change_state_to(StateHandler.States.PLAY)

func _input(event: InputEvent) -> void:
	if is_on and event is InputEventKey :
		exit_state()


func _on_h_slider_value_changed(value: float) -> void:
	$ColorRect/VBoxContainer/MC/VB/NoGames/Label2.text = str(value)
	no_games_changed.emit(value)

func _on_timer_slider_value_changed(value: float) -> void:
	$ColorRect/VBoxContainer/MC/VB/LengthTimer/Label2.text = str(value) + " seconds"
	timer_length_changed.emit(value)
	
func fade_in_ambGame():
	var tween = create_tween()
	tween.tween_property($AmbBG, "volume_db", 0, 0.5)
	
func fade_out_ambGame():
	var tween = create_tween()
	tween.tween_property($AmbBG, "volume_db", -80, 1.5)
	tween.tween_callback($AmbBG.stop)
