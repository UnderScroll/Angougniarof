extends GameState
class_name GameStateScore

@export var score_label : Label
## goes from 0% to 100% -> match between the prompt and the shadow
var score : float = 0.0

func enter_state():
	show()
	score = $"../..".last_score
	$AnimationPlayer.play("open")

func exit_state():
	hide()
	change_state_to(StateHandler.States.PLAY)

func reveal():
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(update_counter.bind(score_label), 0, score, 2)
	tween.tween_callback(end_reveal)

func update_counter(new_exp : int, label : Label):
	label.text = str(new_exp)+"%"

func end_reveal():
	$CenterContainer/GPUParticles2D.emitting = true
