extends Area2D

var alea = RandomNumberGenerator.new()

func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		var salle_alea = int(alea.randf_range(1,101))
		Global.spawn_monstre = true
		Global.spawn_portail = false
		Global.etage += 1
		await Enemi.augmenter_stats()
		if Global.etage%10 == 0 and Global.etage != 0 and len(Enemi.stat_boss) > 0 : 
			call_deferred("change_level_boss", salle_alea)	
		else :
			
			call_deferred("change_level", salle_alea)

func change_level(num) :
	if num <= 30 : #gobelin
		Enemi.enemi_actuel = "Gobelin"
	elif 30 < num and num <= 50 : #Ogre
		Enemi.enemi_actuel = "Ogre"		
	elif 50 < num and num <= 65 : #spider
		Enemi.enemi_actuel = "Araignée"	
	elif 65 < num and num <= 80 : #skull
		Enemi.enemi_actuel = "Squelette"		
	elif 80 < num and num <= 95 : #witch
		Enemi.enemi_actuel = "Sorcière"	
	else : #golem
		Enemi.enemi_actuel = "Golem"
	get_tree().change_scene_to_file("res://scenes/level.tscn")
		
func change_level_boss(num) :
	Enemi.set_stat_boss()
	var taille = len(Enemi.stat_boss)
	var chance = 100.0/float(taille)
	if num <= chance or taille == 1 : 
		Enemi.enemi_actuel = Enemi.stat_boss.keys()[0]
	else :
		Enemi.enemi_actuel = Enemi.stat_boss.keys()[randi_range(0,taille)]
	if taille > 1 and (Enemi.enemi_actuel == "Nathan" and Global.stats_joueur["classe"] == "Nathan") or (Enemi.enemi_actuel == "Paul" and Global.stats_joueur["classe"] == "Paul") :
		change_level_boss(num)
	elif taille == 1 and (Enemi.enemi_actuel == "Nathan" and Global.stats_joueur["classe"] == "Nathan") or (Enemi.enemi_actuel == "Paul" and Global.stats_joueur["classe"] == "Paul") :
		change_level(num)
	else :
		get_tree().change_scene_to_file("res://scenes/level.tscn")	
			
