extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await Global.supprimer_savegarde()
	if Global.etage <= 1 :
		$texte/score.text = "Tu as monté " + str(Global.etage) + " étage"
	else :
		$texte/score.text = "Tu as monté " + str(Global.etage) + " étages"
		
func _on_menu_principal_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

func _on_crédit_button_down() -> void:
	pass # Replace with function body.

func _on_quitter_button_down() -> void:
	get_tree().quit()
