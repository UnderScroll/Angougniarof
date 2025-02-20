extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Wwise.register_game_obj(self, self.name)
	Wwise.register_listener(self)
	Wwise.load_bank("MainSB")
	Wwise.post_event("Play_TestBlip_LP", self)
