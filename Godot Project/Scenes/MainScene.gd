extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
@export var feed : Window
@export var pic : Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func compare_feed_picture():
	var img1 = feed.get_viewport().get_texture().get_image()
	var img2 = pic.get_viewport().get_texture().get_image()
	img2.resize(img1.get_width(), img1.get_height())
	
	var matcher := Pixelmatch.new()
	matcher.threshold = 0.1
	
	var img : Image = Image.create(img1.get_width(),img1.get_height(),false,Image.FORMAT_RGBA8)
	
	var diff = matcher.diff(img1, img2, img, img1.get_width(), img.get_height())
	print(diff)
	$Result/ResultRect.texture = ImageTexture.create_from_image(img)
	


func _on_do_pressed() -> void:
	compare_feed_picture()
