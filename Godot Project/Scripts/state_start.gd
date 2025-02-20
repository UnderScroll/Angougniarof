extends GameState
class_name GameStateStart

var is_on : bool = true

func _ready():
	enter_state()

func enter_state():
	show()
	$AnimationPlayer.play("RESET")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	is_on = true
	

func exit_state():
	is_on = false
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	hide()
	change_state_to(StateHandler.States.PLAY)

func _input(event: InputEvent) -> void:
	if is_on and event is InputEventKey :
		exit_state()
