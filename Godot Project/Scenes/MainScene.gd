extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
@export var feed : Window

signal result_ready

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
	
	print(diff)
	$Result/ResultRect.texture = ImageTexture.create_from_image(img)
	result_ready.emit()


func _on_wait_screen_ask_result() -> void:
	result()
