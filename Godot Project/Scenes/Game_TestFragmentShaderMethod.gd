extends Control

const Pixelmatch := preload("res://addons/pixelmatch/pixelmatch.gd")
var img1 : Image = null
var img2 : Image = null

@export var diff_texture: TextureRect;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_get_score_button_pressed() -> void:
	var start_time = Time.get_ticks_msec();
	
	var image: Image = diff_texture.get_texture().get_image();
	
	var sum: float = 0;
	
	var image_data = image.get_data();
	
	const pixel_ratio: float = 1.0 / 255.0;
	
	for i in range(0, image_data.size(), 4):
		sum += image_data[i] * pixel_ratio;
		
	var score: float = 1 - sum / (image.get_width() * image.get_height());
		
	var end_time = Time.get_ticks_msec();
	var elapsed_time = end_time - start_time;
	
	print("Got score of %s in %sms" % [score, elapsed_time]);

func _on_set_ref_button_pressed() -> void:
	var texture_rect = $SubViewport/ShaderPass/TextureRect;
	texture_rect.material.set_shader_parameter("reference_image", texture_rect.texture);
