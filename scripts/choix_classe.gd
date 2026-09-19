extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_nathan_button_down() -> void:
	Global.choisir_classe("Nathan")
	await Global.save_data()
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_paul_button_down() -> void:
	Global.choisir_classe("Paul")
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_baptiste_button_down() -> void:
	Global.choisir_classe("Baptiste")
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_maëlle_button_down() -> void:
	Global.choisir_classe("Maëlle")
	get_tree().change_scene_to_file("res://scenes/level.tscn")
