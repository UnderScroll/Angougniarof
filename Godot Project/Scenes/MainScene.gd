extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
@export var feed : Window



func result():
	#$CanvasLayer/Progress.hide()
	#await get_tree().create_timer(0.1).timeout
	#
	#compare_feed_picture()
#
	#$CanvasLayer/Progress.show()
	pass

func compare_feed_picture():
	var img1 = feed.get_viewport().get_texture().get_image()
	var img2 = get_viewport().get_texture().get_image()
	img2.resize(img1.get_width(), img1.get_height())
	
	var matcher := Pixelmatch.new()
	matcher.threshold = 0.1
	
	var img : Image = Image.create(img1.get_width(),img1.get_height(),false,Image.FORMAT_RGBA8)
	$CanvasLayer/WaitScreen.show()
	await get_tree().create_timer(0.1).timeout
	var diff = matcher.diff(img1, img2, img, img1.get_width(), img.get_height())
	$CanvasLayer/WaitScreen.hide()
	
	print(diff)
	$Result/ResultRect.texture = ImageTexture.create_from_image(img)

func _on_playtime_timeout() -> void:
	result()
