extends Node2D

@onready var portail = preload("res://scenes/sortie.tscn")
@onready var monstre = preload("res://scenes/monstre.tscn")
@onready var ambiance: AudioStreamPlayer2D = $ambiance


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/message.hide()
	$CanvasLayer/action.hide()
	$CanvasLayer/Etage.text = "Étage n°" + str(Global.etage)
	
	if Global.spawn_monstre == true :
		var nouveau_monstre = monstre.instantiate()
		get_node("/root/Level").add_child(nouveau_monstre)
		nouveau_monstre.global_position = $"position monstre".global_position
	
	if Global.spawn_portail == true :
		var nouveau_portail = portail.instantiate()
		get_node("/root/Level").add_child(nouveau_portail)
		nouveau_portail.global_position = $"position portail".global_position
	$Player.global_position = $"spawn joueur".global_position
	ambiance.play()	

func message(text) : 
	$CanvasLayer/message.show()
	$CanvasLayer/message/message.text = text

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("accept") and $CanvasLayer/message/message.visible : 
		$CanvasLayer/message.hide()
	if Input.is_action_just_pressed("pause") :
		$CanvasLayer/action.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_reprendre_button_down() -> void:
	$CanvasLayer/action.hide()

func _on_sauvegarder_et_quitter_button_down() -> void:
	if Global.spawn_monstre == false :
		message("Veuillez traverser le portail pour pouvoir sauvegarder et quitter")
	else :
		await Global.save_data()
		get_tree().quit()
