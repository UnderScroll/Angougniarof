extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
@export var feed : Window

var is_start : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Debug.hide()
	$Result.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Progress/Bar.value = $Playtime.time_left
	pass

func _input(event: InputEvent) -> void:
	if is_start and event is InputEventKey: 
		start()

func start():
	is_start = false
	$CanvasLayer/StartScreen.hide()
	$Debug.show()
	$Result.show()
	$Playtime.start()

func result():
	$CanvasLayer/Progress.hide()
	await get_tree().create_timer(0.1).timeout
	
	compare_feed_picture()

	$CanvasLayer/Progress.show()

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
