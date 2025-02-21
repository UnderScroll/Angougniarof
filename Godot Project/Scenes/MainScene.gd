extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
@export var feed : Window

@export var max_nb_of_games : int = 3
var nb_game : int = 0

var reference : Image

var last_score : float = 0.0
var total_score : float = 0.0


signal result_ready
signal reference_ready
signal end_game

func get_reference():
	reference = feed.get_viewport().get_texture().get_image()
	reference_ready.emit()

func compare_feed_picture():
	var img2 = feed.get_viewport().get_texture().get_image()
	img2.resize(reference.get_width(), reference.get_height())
	
	var i1 = ImageTexture.create_from_image(reference)
	var i2 = ImageTexture.create_from_image(img2)
	$ScoreManager.set_tex1(i1)
	$ScoreManager.set_tex2(i2)
	
	
	# 0.2 = 100
	# 0.13 = ?
	print("---------------")
	var res_f : float = (1.0-$ScoreManager.ManageCShader()) # value between 0.8 and 1.0
	print(res_f)
	res_f = clamp(res_f - 0.8, 0.0,0.19) # value between 0.0 and 0.2
	print(res_f)
	res_f = (res_f * 100) / 0.19 # value betwwen 0 and 100 !
	print(res_f)
	
	on_game_done(res_f)

func on_game_done(score : float) -> void:
	nb_game += 1
	last_score = score
	total_score += score
	$CanvasLayer/EndScore.scores.append(int(score))
	$CanvasLayer/EndScore.endscore = int(total_score)
	result_ready.emit()
	if nb_game >= max_nb_of_games:
		end_game.emit()


func _on_game_ask_result() -> void:
	compare_feed_picture()

func _on_game_ask_reference():
	get_reference()

func _on_end_score_restart() -> void:
	nb_game = 0
	last_score = 0
	total_score = 0
	$StateHandler.is_end = false


func _on_start_screen_no_games_changed(value) -> void:
	max_nb_of_games = value
