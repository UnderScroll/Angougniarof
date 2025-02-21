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
	
	$IntroAudio.play(1.02)
	
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	$MusicLoop.play()
	is_on = true
	
	

func exit_state():
	$Clic.play()
	is_on = false
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
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
