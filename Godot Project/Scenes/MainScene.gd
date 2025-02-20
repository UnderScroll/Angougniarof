extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
@export var feed : Window

@export var max_nb_of_games : int = 5
var nb_game : int = 0

var last_score : float = 0.0
var total_score : float = 0.0


signal result_ready
signal end_game


func result():
	#await get_tree().create_timer(0.1).timeout # wait for the play UI to hide
	compare_feed_picture()

func compare_feed_picture():
	var img1 = feed.get_viewport().get_texture().get_image()
	var img2 = get_viewport().get_texture().get_image()
	img2.resize(img1.get_width(), img1.get_height())
	
	var i1 = ImageTexture.create_from_image(img1)
	var i2 = ImageTexture.create_from_image(img2)
	$ScoreManager.set_tex1(i1)
	$ScoreManager.set_tex2(i2)
	
	var res_f : float = (1.0 - $ScoreManager.ManageCShader()) * 100
	on_game_done(res_f)

func on_game_done(score : float) -> void:
	nb_game += 1
	last_score = score
	total_score += score
	result_ready.emit()
	#if nb_game >= max_nb_of_games:
		#end_game.emit()


func _on_game_ask_result() -> void:
	compare_feed_picture()
