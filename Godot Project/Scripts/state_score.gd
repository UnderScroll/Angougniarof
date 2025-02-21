extends GameState
class_name GameStateScore

@export var reveal_duration : float = 2.0
@export var score_label : Label
## goes from 0% to 100% -> match between the prompt and the shadow
var score : float = 0.0

func enter_state():
	$Fizzle.restart()
	$MarginContainer/VBoxContainer/Fizzle2.restart()
	show()
	score = $"../..".last_score
	$AnimationPlayer.play("open")
	$MarginContainer/VBoxContainer/Fizzle2.amount_ratio = 0
	$MarginContainer/VBoxContainer/Fizzle2.emitting = false
	$MarginContainer/VBoxContainer/Label.text = "0%"
	$ProgressBar.value = 0

func exit_state():
	hide()
	change_state_to(StateHandler.States.PLAY)

func reveal():
	$Fizzle.emitting = true
	$MarginContainer/VBoxContainer/Fizzle2.emitting = true
	
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(update_counter.bind(score_label), 0, score, reveal_duration)
	tween.set_parallel()
	tween.tween_property($ProgressBar, "value", score, reveal_duration)
	tween.set_parallel()
	tween.tween_property($MarginContainer/VBoxContainer/Fizzle2, "amount_ratio", 1, reveal_duration)
	await tween.finished
	end_reveal()

func update_counter(new_exp : int, label : Label):
	label.text = str(new_exp)+"%"

func end_reveal():
	$MarginContainer/VBoxContainer/Fizzle2.emitting = false
	$EndScoreReveal.start()

func _on_end_score_reveal_timeout():
	change_state_to(StateHandler.States.PLAY)
