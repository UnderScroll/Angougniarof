extends Control


var img1 : Image = null
var img2 : Image = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	img1 = $TextureRect.texture

func _on_button_2_pressed() -> void:
	img2 = $TextureRect.texture

func _on_do_pressed() -> void:
	pass # Replace with function body.
