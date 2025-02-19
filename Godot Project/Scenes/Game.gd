extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
var img1 : Image = null
var img2 : Image = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var material: ShaderMaterial = $TextureRect.material;
	material.set_shader_parameter("screen", $TextureRect.texture);

func _on_button_pressed() -> void:
	img1 = $TextureRect.texture.get_image()

func _on_button_2_pressed() -> void:
	img2 = $TextureRect.texture.get_image()

func _on_do_pressed() -> void:
	var matcher := Pixelmatch.new()
	matcher.threshold = 0.1
	var img : Image = Image.create($TextureRect.texture.get_width(),$TextureRect.texture.get_height(),false,Image.FORMAT_RGBA8)
	
	var diff = matcher.diff(img1, img2, img, $TextureRect.texture.get_width(), $TextureRect.texture.get_height())
	print(diff)
	$TextureRect2.texture = ImageTexture.create_from_image(img)
	printt($TextureRect.texture.get_width(), $TextureRect.texture.get_height())
