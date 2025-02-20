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
	
	var matcher := Pixelmatch.new()
	matcher.threshold = 0.1
	
	var img : Image = Image.create(img1.get_width(),img1.get_height(),false,Image.FORMAT_RGBA8)

	await get_tree().create_timer(0.1).timeout
	var diff = matcher.diff(img1, img2, img, img1.get_width(), img.get_height())
	$Result/ResultRect.texture = ImageTexture.create_from_image(img)
	var score = (diff * 100) / 250000
	on_game_done(score) # temporary - used for testing
	result_ready.emit()

func on_game_done(score : float) -> void:
	nb_game += 1
	last_score = score
	total_score += score
	result_ready.emit()
	#if nb_game >= max_nb_of_games:
		#end_game.emit()

func _on_wait_screen_ask_result() -> void:
	result()
