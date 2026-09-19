extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(Global.save) : 
		$"boutons/Reprendre la partie".show()
	else :
		$"boutons/Reprendre la partie".hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/choix_classe.tscn")
	
func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_reprendre_la_partie_button_down() -> void:
	await Global.load_data()
	get_tree().change_scene_to_file("res://scenes/level.tscn")
