extends Control

@onready var barre_pv_joueur = $"Action/UI joueur/Barre joueur/vie joueur"
@onready var barre_pv_monstre = $"monstre/vie monstre"
@onready var barre_sang_joueur = $"Action/UI joueur/Barre joueur/saignement joueur"
@onready var barre_sang_monstre = $"monstre/saignement monstre"
@onready var barre_xp_joueur = $"Action/UI joueur/Barre joueur/xp"
@onready var barre_pv_joueur_text = $"Action/UI joueur/Barre joueur/vie joueur/vie joueur"
@onready var barre_pv_monstre_text = $"monstre/vie monstre/vie monstre"
@onready var barre_xp_joueur_text = $"Action/UI joueur/Barre joueur/xp/xp joueur"
@onready var barre_sang_joueur_text = $"Action/UI joueur/Barre joueur/saignement joueur/saignement joueur"
@onready var barre_sang_monstre_text = $"monstre/saignement monstre/saignement monstre"
@onready var fond: TextureRect = $Fond
@onready var monstre: TextureRect = $"monstre/monstre"
@onready var message = $Action/Message
@onready var nom_monstre = $"monstre/nom monstre"
@onready var son_attaque: AudioStreamPlayer2D = $"Son attaque"
@onready var son_parade: AudioStreamPlayer2D = $"Son parade"
@onready var musique_combat: AudioStreamPlayer2D = $"musique combat"


var vie_joueur = Global.stats_joueur["vie"]
var vie_max_joueur = Global.stats_joueur["vie max"]
var classe_joueur = Global.stats_joueur["classe"]
var xp_joueur = Global.stats_joueur["xp"]
var xp_next_lvl = Global.xp_prochain_lvl
var xp
var PA = 3
var vie_monstre
var vie_max_monstre
var sang_joueur = 0
var sang_monstre = 0
var joueur = true
var degat_joueur = Global.stats_joueur["attaque"]
var degat_monstre
var mort_monstre = false
var passe_monstre = false
var passe_joueur = false
var compteur = 0
var bloquer = false
var esquive_joueur = false
var poison_monstre = false
var defense = false
var prière = false
var rng = RandomNumberGenerator.new()
var blocage_spider = false
var bouclier = false
var type_monstre
var contre = false
var copier = false
var mur_lumiere = [false, 0]
var soins_monstre = [false, 0]
var rejouer_monstre = false
var ind_ame_actuelle
var boost_gobelin = false

signal message_fermee
signal decision 

func _ready() -> void:
	barre_sang_joueur.hide()
	#if Global.etage%10 == 0 and Global.etage != 0 and len(Enemi.stat_boss) > 0:
	if Enemi.enemi_actuel in Enemi.stat_boss.keys() :
		type_monstre = "Boss"
		vie_monstre = (Enemi.stat_boss[Enemi.enemi_actuel])["vie"]
		vie_max_monstre = (Enemi.stat_boss[Enemi.enemi_actuel])["vie max"]
		degat_monstre = (Enemi.stat_boss[Enemi.enemi_actuel])["attaque"]
		xp = Enemi.stat_boss[Enemi.enemi_actuel]["xp"]
		if Enemi.enemi_actuel == "Nathan" or Enemi.enemi_actuel == "Roi vampire" or (Enemi.enemi_actuel == "Titik l'enfant rapide" and classe_joueur == "Nathan") :
			barre_sang_joueur.show()
			set_saignement_joueur(barre_sang_joueur, sang_joueur, barre_sang_joueur_text)	
		#musique_combat.stream = preload("res://assets/sons/castle-music-loop-1.wav")
	else :
		type_monstre = "Monstre"
		vie_monstre = (Enemi.stat_monstre[Enemi.enemi_actuel])["vie"]
		vie_max_monstre = (Enemi.stat_monstre[Enemi.enemi_actuel])["vie max"]
		degat_monstre = (Enemi.stat_monstre[Enemi.enemi_actuel])["attaque"]
		xp = Enemi.stat_monstre[Enemi.enemi_actuel]["xp"]
		#musique_combat.stream = preload("res://assets/sons/stress-musicambient-loop.wav")
	musique_combat.play()
	await bouton_capa()
	$"Action/UI joueur/barre PA".value = Global.stats_joueur["barre PA"]
	$"Action/UI joueur/barre PA/barre PA".text = str(Global.stats_joueur["barre PA"])
	$"Action nécromantien".hide()
	$"Action inventaire".hide()
	$Contrat.hide()
	$Action/LineEdit.hide()
	if classe_joueur == "Nathan" :
		barre_sang_monstre.show()
		set_saignement_monstre(barre_sang_monstre, sang_monstre, barre_sang_monstre_text)
	else :
		barre_sang_monstre.hide()
	nom_monstre.text = Enemi.enemi_actuel
	message.hide()
	monstre.texture = Enemi.img_monstre[Enemi.enemi_actuel]
	fond.texture = Enemi.fond_monstre[Enemi.enemi_actuel]
	$"Action/UI joueur/info joueur/Pseudo".text = Global.stats_joueur["classe"]
	$"Action/UI joueur/info joueur/Niveau".text = "Niveau : " + str(Global.stats_joueur["niv"])
	$"Action/UI joueur/info joueur/PA".text = "PA : " + str(PA)
	set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
	set_xp(barre_xp_joueur, xp_joueur, xp_next_lvl, barre_xp_joueur_text)
	set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
	if Enemi.enemi_actuel == "Titik l'enfant rapide" and (classe_joueur == "Nathan" or classe_joueur == "Paul") :
		$Action/boutons.hide()
		afficher_message("L'ennemi vous copie ! \nEt il joue avant vous !")
		await message_fermee
		tour_enemi()
	elif Enemi.enemi_actuel == "Titik l'enfant rapide" :
		$Action/boutons.hide()
		afficher_message("L'ennemi joue avant vous !")
		await message_fermee
		tour_enemi()
	else :
		await effet_contrat()
	
func set_health(barre, vie, vie_max, texte, player) : #remplacer la progress bar
	if vie <= 0 :
		barre.value = 0
		texte.text = "PV : " + str(0) + "/" + str(vie_max)
		mort_monstre = true
	else :
		barre.value = vie
		barre.max_value = vie_max
		texte.text = "PV : " + str(vie) + "/" + str(vie_max) 
	if player == true :
		Global.stats_joueur["vie"] = vie_joueur
		if vie_joueur <= 0 :
			call_deferred("game_over")
	
func set_xp(barre, xp_act, xp_max, texte) : #remplacer la progress bar
	xp_act = Global.stats_joueur["xp"]
	barre.value = xp_act
	barre.max_value = xp_max
	texte.text = "Exp : " + str(xp_act) + "/" + str(xp_max) 

func set_saignement_joueur(barre, sang, texte) :
	var degat_sang = vie_max_joueur * 0.20
	barre.max_value = 100
	if sang >= 100 :
		sang_joueur = sang - 100
		barre.value = sang_joueur
		texte.text = "Saignement : " + str(sang_joueur) + " %"
		afficher_message("L'arme de l'ennemi te fait saigner !\nCela inflige " + str(degat_sang) + " dégats en plus de tes dégats de base.\nVous infligez " + str(degat_sang+degat_joueur) + " dégats."  )
		if (vie_joueur - degat_sang) > 0 :
			vie_joueur -= degat_sang
			Global.stats_joueur["vie"] = vie_joueur
			set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
			await message_fermee
		else : 
			vie_joueur = 0
			set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
			await message_fermee
	else :
		barre.value = sang
		texte.text = "Saignement : " + str(sang_joueur) + " %"

func set_saignement_monstre(barre, sang, texte) :
	var degat_sang = vie_max_monstre * 0.20
	barre.max_value = 100
	if sang >= 100 :
		sang_monstre = sang - 100
		barre.value = sang_monstre
		texte.text = "Saignement : " + str(sang_monstre) + " %"
		afficher_message("Ton arme fait saigner l'ennemi !\nCela inflige " + str(degat_sang) + " dégats en plus de tes dégats de base.\nVous infligez " + str(degat_sang+degat_joueur) + " dégats."  )
		if (vie_monstre - degat_sang) > 0 :
			vie_monstre -= degat_sang
			set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
			await message_fermee
		else : 
			vie_monstre = 0
			mort_monstre = true
			set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
			await message_fermee
	else :
		barre.value = sang
		texte.text = "Saignement : " + str(sang_monstre) + " %"

func augmenter_niv() : 
	Global.stats_joueur["niv"] += 1
	if Global.stats_joueur["xp"] == Global.xp_prochain_lvl :
		Global.stats_joueur["xp"] = 0
	elif Global.stats_joueur["xp"] > Global.xp_prochain_lvl :
		Global.stats_joueur["xp"] -= Global.xp_prochain_lvl
	Global.xp_prochain_lvl = Global.xp_prochain_lvl*1.12
	Global.xp_prochain_lvl = int(Global.xp_prochain_lvl)
	$"Action/UI joueur/info joueur/Niveau".text = "Niveau : " + str(Global.stats_joueur["niv"])
	Global.augmenter_stats()
	vie_joueur = Global.stats_joueur["vie"]
	vie_max_joueur = Global.stats_joueur["vie max"]
	set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
	if Global.stats_joueur["xp"] >= Global.xp_prochain_lvl :
		augmenter_niv()
		
func fin_combat() :
	$Action/boutons.hide()
	if classe_joueur == "Baptiste" and copier == false:
		afficher_message("Vous volez l'âme du monstre")
		await message_fermee
		if len(Global.stats_joueur["ame"]) <= 3 :
			(Global.stats_joueur["ame"]).append(Enemi.enemi_actuel)
		else :
			afficher_message("Vous possédez trop d'âme ! Vous devez en jeter une !")
			await message_fermee
			jeter_ame()
			await decision
			$Action/boutons.hide()
	if "Le Salopard" in Global.contrat_actif :
		xp = xp*0.65
	Global.stats_joueur["xp"] += xp
	Global.stats_joueur["altération"] = false
	Global.spawn_monstre = false
	Global.spawn_portail = true	
	set_xp(barre_xp_joueur, xp_joueur, xp_next_lvl, barre_xp_joueur_text)	
	afficher_message("Le monstre : " + Enemi.enemi_actuel + " est mort.\n" +  "Et vous gagnez " + str(xp) + " points d'experience.")
	await message_fermee
	if Global.stats_joueur["xp"] >= Global.xp_prochain_lvl :
		augmenter_niv()
		afficher_message("Vous montez en niveau !")
		set_xp(barre_xp_joueur, xp_joueur, Global.xp_prochain_lvl, barre_xp_joueur_text)
		await message_fermee
	var alea = rng.randi_range(1,100)
	var objet = "Rien"
	# faire le systeme d'item/loot
	if alea <= 5 :
		objet = "Kit de soin"	
	elif alea <= 30 :
		objet = "Bouclier"
	elif alea <= 45 :
		objet = "Explosifs"
	if objet != "Rien" :	
		Global.ajouter_objet_inventaire(objet)
		afficher_message("L'ennemi laisse tomber un objet")
		await message_fermee
		afficher_message("L'objet : " + objet + " à été rajouter à ton inventaire")
		await message_fermee
	if type_monstre == "Boss" :
		Enemi.stat_boss.erase(Enemi.enemi_actuel)
		contrat(Enemi.enemi_actuel) 
	else :
		call_deferred("change_level")
	
func change_level() :
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	
func _on_attaque_button_down() -> void:
	if $Action/boutons/attaque.text == "Accepter" :
		Global.ajouter_contrat(Enemi.enemi_actuel)
		call_deferred("change_level")
	elif $Action/boutons/attaque.text == "Consommation d'âme" :
		$Action/boutons.hide()
		$"Action nécromantien".hide()
		afficher_message("Vous vous soignez et vous récupérez 1 PA")
		await message_fermee
		$Action/boutons.show()
		(Global.stats_joueur["ame"]).pop_at(ind_ame_actuelle)
		PA += 1
		Global.soigner(0.15)
		vie_joueur = Global.stats_joueur["vie"]
		$Action/boutons/attaque.text = "Attaque\n(1 PA)"
		$"Action/boutons/capacité".text = "Capacité"
		if "Titik l'enfant rapide" in Global.contrat_actif :
			$Action/boutons/inventaire.text = "Inventaire\n(3 PA)"
		else : 
			$Action/boutons/inventaire.text = "Inventaire\n(2 PA)"
		$Action/boutons/passer.show()
		set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
		update_PA()
	elif classe_joueur == "Baptiste" and $Action/boutons/attaque.text == Global.stats_joueur["ame"][0] :
		Global.stats_joueur["ame"].pop_at(0)
		(Global.stats_joueur["ame"]).append(Enemi.enemi_actuel)
		decision.emit()
	else :
		tour_joueur()
	
func tour_joueur() :
	PA -= 1
	update_PA()
	$"Action inventaire".hide()
	$"Action nécromantien".hide()
	var esquive = false
	$Action/boutons.hide()
	if Enemi.enemi_actuel == "Squelette" or Enemi.enemi_actuel == "Le Salopard" or (Enemi.enemi_actuel == "Roi vampire" and Enemi.stat_boss["Roi vampire"]["compteur"] == 2) :
		var alea = rng.randi_range(1,100)
		if (alea <= 35 and Enemi.enemi_actuel == "Squelette") or (alea <= 50 and Enemi.enemi_actuel == "Le Salopard") or (Enemi.enemi_actuel == "Roi vampire") :
			esquive = true
			afficher_message("Le monstre esquive l'attaque")
		else :
			if classe_joueur == "Paul" :
				quitte_ou_double()
			vie_monstre -= degat_joueur
	else :
		if classe_joueur == "Paul" :
			quitte_ou_double()
		vie_monstre -= degat_joueur
	
	if classe_joueur != "Paul" and esquive == false:
		afficher_message("Vous infligez " + str(degat_joueur) + " dommages")
	if Enemi.enemi_actuel == "Golem en adamantium" : 
		Enemi.stat_boss["Golem en adamantium"]["stockage"] += degat_joueur*0.5	
		$"monstre/nom monstre".text = "Golem en adamantium \n (stockage : %s)" %[Enemi.stat_boss["Golem en adamantium"]["stockage"]]
	#if Enemi.enemi_actuel == "Titik l'enfant rapide" and soins_monstre[0] == true :
		#afficher_message("Le mur de lumière soigne le boss")
		#await message_fermee
		vie_monstre += degat_joueur*soins_monstre[1]
	son_attaque.play()
	set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)	
	await message_fermee
	if "La Liche" in Global.contrat_actif :
		afficher_message("Votre attaque vous soigne")
		await message_fermee
		Global.soigner(degat_joueur*0.5)
		vie_joueur = Global.stats_joueur["vie"]
		set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
	if vie_monstre > 0 :
		if classe_joueur == "Nathan" and esquive == false:
			sang_monstre += Global.stats_joueur["saignement"][Global.stats_joueur["mode"]]
			await set_saignement_monstre(barre_sang_monstre, sang_monstre, barre_sang_monstre_text)
		if vie_monstre > 0 :
			if Enemi.enemi_actuel != "Roi vampire" and esquive == true :
				esquive = false
			if PA <= 0 :
				if (Enemi.enemi_actuel == "Roi vampire" and Enemi.stat_boss["Roi vampire"]["compteur"] == 2) :
					Enemi.stat_boss["Roi vampire"]["compteur"] = 0
					esquive = false
				tour_enemi()
			else : 
				$Action/boutons.show()
	#else :
		#mort_monstre = true
	if mort_monstre == true :
		if type_monstre == "Monstre" :
			$monstre.queue_free()
		if Enemi.enemi_actuel != "La Liche" :
			fin_combat()
		elif PA <= 0 : #Enemi.enemi_actuel == "La Liche"
			tour_enemi()
		else :
			$Action/boutons.show()	
				
			
func tour_enemi():
	$Action/boutons.hide()
	$"Action inventaire".hide()
	afficher_message("Au tour de l'ennemi :")
	await message_fermee
	var fin_liche = false
	if Enemi.enemi_actuel == "La Liche" and mort_monstre == true:
		if Enemi.stat_boss["La Liche"]["compteur"] == 2 :
			fin_liche = true
			await fin_combat()
		else :
			Enemi.stat_boss["La Liche"]["compteur"] += 1
	if fin_liche == false :	
		if poison_monstre == true :
			vie_monstre -= vie_max_monstre * 0.05
			set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
			afficher_message("Vous infligez 5% de poison !")
			await message_fermee
		if bloquer == false and esquive_joueur == false :
			if Enemi.enemi_actuel == "Titik l'enfant rapide" and (classe_joueur == "Nathan" or classe_joueur == "Paul") :
				await effet_enemi(classe_joueur)
			 #elif classe_joueur == "Baptiste" :
				#await effet_enemi(Enemi.stat_monstre.keys()[rng.randi_range(0, len(Enemi.stat_monstre)-1)])
			await effet_enemi(Enemi.enemi_actuel)
			if passe_monstre == false :
				if defense == true or bouclier == true or contre == true or "Golem en adamantium" in Global.contrat_actif :
					vie_joueur -= degat_monstre*0.5
					set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
					if contre == true or "Golem en adamantium" in Global.contrat_actif :
						if classe_joueur == "Paul" :
							pass #faire effet de Paul mais sur les degats renvoyés
							var alea = rng.randf_range(0,1)
							if alea == 0 :
								vie_monstre -= degat_monstre
								afficher_message("Vous renvoyez la moitié des dégâts, mais avec votre chance légendaire vous les doublez !")
								await message_fermee
							else :
								vie_monstre -= degat_monstre*0.25
								afficher_message("Vous renvoyez la moitié des dégâts, mais avec votre malchance légendaire vous les divisez par 2 encore !")
								await message_fermee
						else :
							vie_monstre -= degat_monstre*0.5
							afficher_message("Vous renvoyez la moitié des dégâts")
							await message_fermee
						set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
						if contre == true :
							contre = false
							afficher_message("Contre quasi totale ! Vous vous prenez tous les deux des dégats")
							await message_fermee
						if classe_joueur == "Nathan" :
							sang_monstre += Global.stats_joueur["saignement"][Global.stats_joueur["mode"]]
							set_saignement_monstre(barre_sang_monstre, sang_monstre, barre_sang_monstre_text)
						if mort_monstre == true :
							if type_monstre == "Monstre" :
								$monstre.queue_free()
							if Enemi.enemi_actuel != "La Liche" :
								await fin_combat()
					else :
						afficher_message("Le monstre : %s t'inflige %d dommages" %[Enemi.enemi_actuel,degat_monstre*0.75])
						await message_fermee
						set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
					bouclier = false
		 
					
				else :
					vie_joueur -= degat_monstre
					if degat_monstre > 1 : 
						afficher_message("Le monstre : %s t'inflige %d dommages" %[Enemi.enemi_actuel,degat_monstre])
						await message_fermee
					elif degat_monstre == 1 :
						afficher_message("Le monstre : %s t'inflige %d dommage" %[Enemi.enemi_actuel,degat_monstre])
						await message_fermee
					else :
						afficher_message("Le monstre ne t'infliges pas de dommages")
						await message_fermee
					set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)		
				if soins_monstre[0] == true :
					if vie_monstre + degat_monstre*(soins_monstre[1]) >= vie_max_monstre :
						vie_monstre = vie_max_monstre
					else :
						vie_monstre += degat_monstre*(soins_monstre[1])
					vie_monstre = snapped(vie_monstre, 0.01)
					afficher_message("L'attaque de l'ennemi le soigne !")
					await message_fermee
					set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
				if mur_lumiere[0] == true :
					mur_lumiere[1] += 1
					vie_joueur += degat_monstre*0.3
					afficher_message("Le mur de lumière te soigne légèrement")
					await message_fermee
					set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
					if mur_lumiere[1] == 2 :
						afficher_message("Le mur de lumière disparait")
						await message_fermee
						mur_lumiere[0] = false
						mur_lumiere[1] = 0
		else :
			if bloquer == true :
				bloquer = false
				afficher_message("l'ennemi est bloqué")
				await message_fermee
			elif esquive_joueur == true :
				esquive_joueur = false
				afficher_message("Vous esquivez l'attaque")
				await message_fermee
		
		if blocage_spider == false and rejouer_monstre == false :
			if Enemi.enemi_actuel == "Paul" :
				degat_monstre = Enemi.stat_boss["Paul"]["attaque"] + 4*(Global.stats_joueur["niv"]-1)
			elif Enemi.enemi_actuel == "Nathan" :
				degat_monstre = Enemi.stat_boss["Nathan"]["attaque"] + 5*(Global.stats_joueur["niv"]-1)
			afficher_message("À ton tour : ")
			await message_fermee
			if boost_gobelin == true :
				degat_joueur = Global.stats_joueur["attaque"]
				boost_gobelin = false
			await effet_contrat()
			if passe_joueur == false :
				if "Titik l'enfant rapide" not in Global.contrat_actif :
					PA = 3
					update_PA()
				if Global.stats_joueur["altération"] == true :
					vie_joueur -= vie_max_joueur * 0.05
					set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
					afficher_message("Vous vous prenez 5% de poison !")
					await message_fermee
				$Action/boutons.show()
			else :
				passe_joueur = false
			if compteur == 1 :
					compteur = 0
					degat_monstre -= 20
			if passe_monstre == true :
					compteur += 1
					passe_monstre = false 
		else :
			if rejouer_monstre == true :
				afficher_message("Le boss est tellement rapide qu'il rejoue !")
				await message_fermee
			blocage_spider = false
			tour_enemi()	
			
func effet_enemi(enemi) :
	if enemi == "Ogre" :
		var alea = rng.randi_range(0,2)
		if alea != 1 and passe_monstre == false and compteur == 0:
			degat_monstre += 20
			if Enemi.enemi_actuel != "Titik l'enfant rapide" : 
				afficher_message("L'orque se prépare pour une attaque plus puissante !")
			else :
				afficher_message("Titik l'enfant rapide se prépare pour une attaque plus puissante !")
			passe_monstre = true
			await message_fermee
		
	elif enemi == "Araignée" :
		var alea = rng.randi_range(1,100)
		if alea <= 20 :
			blocage_spider = true
			if Enemi.enemi_actuel != "Titik l'enfant rapide" : 
				afficher_message("L'araignée te bloque pendant 1 tour !")
			else :
				afficher_message("Titik l'enfant rapide te bloque pendant 1 tour !")
			await message_fermee
			
	elif enemi == "Sorcière" :
		var alea = rng.randi_range(1,100)
		if alea <= 20 and Global.stats_joueur["altération"] == false :
			if Enemi.enemi_actuel != "Titik l'enfant rapide" : 
				afficher_message("La sorcière vous empoisonne")
			else :
				afficher_message("Titik l'enfant rapide vous empoisonne")
			Global.stats_joueur["altération"] = true 
			await message_fermee
			
	elif enemi == "Golem" and degat_joueur * 0.95 > 1 :
		degat_joueur = degat_joueur * 0.95
	
	elif enemi == "Nathan" : 
		var alea = rng.randi_range(0,2)
		if alea == 0 :
			degat_monstre = degat_monstre * 0.6
			sang_joueur += (Enemi.stat_boss["Nathan"]["saignement"])["dague"]
		else :
			sang_joueur += (Enemi.stat_boss["Nathan"]["saignement"])["katana"]
		await set_saignement_joueur(barre_sang_joueur, sang_joueur, barre_sang_joueur_text)
	
	elif enemi == "Paul" : 
		var alea = rng.randi_range(0,1)
		if alea == 0 :
			degat_monstre = degat_monstre * 0.5
			afficher_message("Le boss est maudit : il inflige moins de dégats !")
		elif alea == 1 :
			afficher_message("Le boss n'est pas béni ou maudit")
		else :
			degat_monstre = degat_monstre * 1.5
			afficher_message("Le boss est béni : il inflige plus de dégats !")
		await message_fermee
	
	elif enemi == "Roi vampire" : 
		Enemi.stat_boss[enemi]["compteur"] += 1 
		soins_monstre[0] = true
		soins_monstre[1] = 0.3
		sang_joueur += 15
		await set_saignement_joueur(barre_sang_joueur, sang_joueur, barre_sang_joueur_text)
	
	elif enemi == "La Liche" :
		soins_monstre[0] = true
		soins_monstre[1] = 1
		if mort_monstre == true :
			soins_monstre[0] = false
			
	elif enemi == "Golem en adamantium" :
		Enemi.stat_boss[enemi]["compteur"] += 1 
		if Enemi.stat_boss[enemi]["compteur"] == 4 :
			Enemi.stat_boss[enemi]["compteur"] = 0 
			afficher_message("Le boss vous renvoie les dégats qu'il a encaissé pendant 3 tours")
			await message_fermee
			vie_joueur -= Enemi.stat_boss[enemi]["stockage"]
			Enemi.stat_boss[enemi]["stockage"] = 0
			$"monstre/nom monstre".text = "Golem en adamantium \n (stockage : %s)" %[Enemi.stat_boss[enemi]["stockage"]]
			set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
	
	elif enemi == "Titik l'enfant rapide" :
		#if classe_joueur == "Maëlle" :
			#soins_monstre[0] = true
			#soins_monstre[1] = 0.3
			#if soins_monstre[0] == false :
				#soins_monstre[0] = true
				#afficher_message("Le boss se protège avec un mur de lumière")
				#await message_fermee
		if rejouer_monstre == false :
			Enemi.stat_boss[enemi]["compteur"] += 1 
		if Enemi.stat_boss[enemi]["compteur"] == 2 and rejouer_monstre == false :
			Enemi.stat_boss[enemi]["compteur"] = 0
			rejouer_monstre = true
		elif rejouer_monstre == true :
			rejouer_monstre = false
		
		
	
	elif enemi == "Le Salopard" :
		var alea = rng.randi_range(1,100)
		if alea <= 50 :
			afficher_message("Le Salopard te retire 20% de votre barre d'expérience !")
			await message_fermee
			if Global.stats_joueur["xp"] - Global.xp_prochain_lvl* 0.2 <= 0 :
				Global.stats_joueur["xp"] = 0
			else :
				Global.stats_joueur["xp"] -= Global.xp_prochain_lvl* 0.2
			xp_joueur = Global.stats_joueur["xp"]
			set_xp(barre_xp_joueur, xp_joueur, xp_next_lvl, barre_xp_joueur_text)
			
func afficher_message(texte):
	#message.global_position = $"Action/position texte".global_position
	message.show()
	message.text = texte
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("accept"):
		message.hide()
		message_fermee.emit()

func game_over() :
	afficher_message("Vous êtes mort")
	await message_fermee
	get_tree().change_scene_to_file("res://scenes/menu_mort.tscn") #à changer pour le menu de mort 
	
func quitte_ou_double() :
	var alea = rng.randi_range(0,2)
	if alea == 0 and degat_joueur > 1 :
		degat_joueur = degat_joueur*0.5
		Global.stats_joueur["attaque"] = degat_joueur
		if degat_joueur == 1 :
			afficher_message("Vous êtes maudit : Vous infligez 2 fois moins de dégats !\nVous infligez " + str(degat_joueur) + " dommage")
		else :
			afficher_message("Vous êtes maudit : vous infligez 2 fois moins de dégats !\nVous infligez " + str(degat_joueur) + " dommages")
	elif alea == 0 and degat_joueur == 1 :
			afficher_message("Cela fait tellement de fois que vous êtes maudit que vous infligez plus que 1 dommage")
	else :
		degat_joueur = degat_joueur*2
		Global.stats_joueur["attaque"] = degat_joueur
		afficher_message("Vous êtes béni : vous infligez 2 fois plus de dégats !\nVous infligez " + str(degat_joueur) + " dommages")
	await message_fermee

	
func bouton_capa() :
	if classe_joueur == "Nathan" :
		if Global.stats_joueur["mode"] == "katana" :
			#$Action/boutons.position.x += 50
			$"Action inventaire/objet inventaire/Objet 4".text = "Mode dague \n (1 PA)"
		else : #Global.stats_joueur["mode"] == "dague"
			#$Action/boutons.position.x += 50
			$"Action inventaire/objet inventaire/Objet 4".text = "Mode katana \n (1 PA)"
		$"Action inventaire/objet inventaire/Objet 5".text = "Contre quasi totale \n (2 PA)"
	elif classe_joueur == "Paul" :
		$"Action inventaire/objet inventaire/Objet 4".text = "Reset \n (1 PA)"
		$"Action inventaire/objet inventaire/Objet 5".text = "All-in \n (3 PA)"
	elif classe_joueur == "Baptiste" :
		#$Action/boutons.position.x += 150
		$"Action inventaire/objet inventaire/Objet 4".text = "Collection d'âme"
		$"Action inventaire/objet inventaire/Objet 5".text = "Vole d'âme \n (2 PA)" 
	elif classe_joueur == "Maëlle" :
		$"Action inventaire/objet inventaire/Objet 4".text = "Prière \n (2 PA)"
		$"Action inventaire/objet inventaire/Objet 5".text = "Mur de lumière \n (2 PA)"
	if "Le Salopard" in Global.contrat_actif :
		$"Action inventaire/objet inventaire/Objet 6".text = "Vente d'expérience"

func _on_capacité_button_down() -> void:
	if $"Action/boutons/capacité".text == "Refuser" :
		call_deferred("change_level")
	elif $"Action/boutons/capacité".text == "Capacité d'âme" :
		$Action/boutons.hide()
		$"Action nécromantien".hide()
		if Global.stats_joueur["ame"][ind_ame_actuelle] == "Gobelin" and PA >= 1 :
			PA -= 1
			afficher_message("Votre attaque augmente pour le reste du tour")
			await message_fermee
			degat_joueur = degat_joueur*1.3
			boost_gobelin = true
		elif Global.stats_joueur["ame"][ind_ame_actuelle] == "Ogre" and PA >= 2 :
			PA -= 2
			afficher_message("Vous vous préparez à faire une attaque plus puissante")
			await message_fermee
			degat_joueur += 20
			passe_joueur = true
			await tour_enemi()
			await tour_joueur()
			degat_joueur -= 20
		elif Global.stats_joueur["ame"][ind_ame_actuelle] == "Araignée" and PA >= 2 :
			PA -= 2
			afficher_message("Vous bloquez l'ennemi")
			await message_fermee
			bloquer = true 
		elif Global.stats_joueur["ame"][ind_ame_actuelle] == "Squelette" and PA >= 1 :
			PA -= 1
			afficher_message("Vous avez 35% de chance d'esquivez la prochaine attaque")
			await message_fermee
			var alea = rng.randi_range(0, 100)
			if alea <= 35 :
				esquive_joueur = true
		elif Global.stats_joueur["ame"][ind_ame_actuelle] == "Sorcière" and PA >= 2:
			if poison_monstre == true:
				afficher_message("L'ennemi est deja empoisonné")
				await message_fermee
				$Action/boutons.show()
			else :
				PA -= 2
				afficher_message("Vous empoisonnez l'ennemi")
				await message_fermee
				poison_monstre = true
		elif classe_joueur == "Baptiste" and Global.stats_joueur["ame"][ind_ame_actuelle] == "Golem" and PA >= 2:
			PA -= 2
			afficher_message("L'attaque de l'ennemi diminue de 5%")
			await message_fermee
			degat_monstre = degat_monstre * 0.95
		update_PA()
		Global.stats_joueur["ame"].pop_at(ind_ame_actuelle)
		$Action/boutons.show()
		$Action/boutons/attaque.text = "Attaque\n(1 PA)"
		$"Action/boutons/capacité".text = "Capacité"
		if "Titik l'enfant rapide" in Global.contrat_actif :
			$Action/boutons/inventaire.text = "Inventaire\n(3 PA)"
		else : 
			$Action/boutons/inventaire.text = "Inventaire\n(2 PA)"
		$Action/boutons/passer.show()
	elif classe_joueur == "Baptiste" and $"Action/boutons/capacité".text == Global.stats_joueur["ame"][1] :
		Global.stats_joueur["ame"].pop_at(1)
		(Global.stats_joueur["ame"]).append(Enemi.enemi_actuel)
		decision.emit()
	else :
		bouton_capa()
		$"Action inventaire".show()
		$"Action inventaire/objet inventaire/Objet 1".hide()
		$"Action inventaire/objet inventaire/Objet 2".hide()
		$"Action inventaire/objet inventaire/Objet 3".hide()
		$"Action inventaire/objet inventaire/Objet 4".show()
		$"Action inventaire/objet inventaire/Objet 5".show()
		if "Le Salopard" in Global.contrat_actif :
			$"Action inventaire/objet inventaire/Objet 6".show()
		else :
			$"Action inventaire/objet inventaire/Objet 6".hide()
		$Action/boutons.hide()
		afficher_message("Quel capacité voulez vous utiliser ?")
		await message_fermee
		$Action/boutons.show()

func _on_ame_button_down(indice) :
	ind_ame_actuelle = indice
	$Action/boutons.show()
	$Action/boutons/inventaire.hide()
	$Action/boutons/attaque.show()	
	$Action/boutons/attaque.text = "Consommation d'âme"
	$"Action/boutons/capacité".show()	
	$"Action/boutons/capacité".text = "Capacité d'âme"
	$"Action/boutons/inventaire".show()	
	$"Action/boutons/inventaire".text = "Annuler"
	$Action/boutons/passer.hide()
		
func _on_inventaire_button_down() -> void:
	if $"Action/boutons/inventaire".text == "Annuler" :
		$Action/boutons/attaque.text = "Attaque\n(1 PA)"
		$"Action/boutons/capacité".text = "Capacité"
		if "Titik l'enfant rapide" in Global.contrat_actif :
			$Action/boutons/inventaire.text = "Inventaire\n(3 PA)"
		else : 
			$Action/boutons/inventaire.text = "Inventaire\n(2 PA)"
	elif classe_joueur == "Baptiste" and $Action/boutons/inventaire.text == Global.stats_joueur["ame"][2] :
		Global.stats_joueur["ame"].pop_at(2)
		(Global.stats_joueur["ame"]).append(Enemi.enemi_actuel)
		decision.emit()
	else :
		$Action/boutons.hide()
		$"Action nécromantien".hide()
		
		if len(Global.inventaire) <= 0 :
			afficher_message("Votre inventaire est vide")
			await message_fermee
			$Action/boutons.show()
		else :
			bouton_inventaire()
			$"Action inventaire".show()
			afficher_message("Quel objet voulez vous utiliser ?")
			await message_fermee
			$Action/boutons.show()
			
func bouton_inventaire() :
	$"Action inventaire/objet inventaire/Objet 4".hide()
	$"Action inventaire/objet inventaire/Objet 5".hide()
	$"Action inventaire/objet inventaire/Objet 6".hide()
	if len(Global.inventaire) > 0 :
		if len(Global.inventaire) >= 1 :
			$"Action inventaire/objet inventaire/Objet 1".text = ((Global.inventaire).keys())[0] + " (x " + str(((Global.inventaire).values())[0]) + ")"
			$"Action inventaire/objet inventaire/Objet 1".show()
		else :
			$"Action inventaire/objet inventaire/Objet 1".hide()
		if len(Global.inventaire) >= 2 :
			$"Action inventaire/objet inventaire/Objet 2".text = ((Global.inventaire).keys())[1] + " (x " + str(((Global.inventaire).values())[1]) + ")"
			$"Action inventaire/objet inventaire/Objet 2".show()
		else :
			$"Action inventaire/objet inventaire/Objet 2".hide()
		if len(Global.inventaire) >= 3 :
			$"Action inventaire/objet inventaire/Objet 3".text = ((Global.inventaire).keys())[2] + " (x " + str(((Global.inventaire).values())[2]) + ")"	
			$"Action inventaire/objet inventaire/Objet 3".show()
		else :
			$"Action inventaire/objet inventaire/Objet 3".hide()
			
	
func _on_objet_button_down(indice_objet) -> void:
	if indice_objet <= 2 :
		if len(Global.inventaire) > indice_objet :
			$Action/boutons.hide()
			afficher_message("Vous utilisez l'objet : " + ((Global.inventaire).keys())[indice_objet]) 
			await message_fermee
			var objet = ((Global.inventaire).keys())[indice_objet]
			if ((Global.inventaire).keys())[indice_objet] == "Kit de soin" and ((Global.inventaire).values())[indice_objet] > 0:
				afficher_message("Vous vous soignez")
				await message_fermee
				Global.soigner(1)
				vie_joueur = Global.stats_joueur["vie"]
				set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
			elif ((Global.inventaire).keys())[indice_objet] == "Bouclier" and ((Global.inventaire).values())[indice_objet] > 0:
				bouclier = true
				afficher_message("Vous vous protégez")
				await message_fermee
				afficher_message("La prochaine attaque t'infligeras 2 fois moins de dégât")
				await message_fermee
			elif ((Global.inventaire).keys())[indice_objet] == "Explosifs" and ((Global.inventaire).values())[indice_objet] > 0:
				var degat_explosion = 50
				vie_monstre -= degat_explosion
				Global.stats_joueur["vie"] -= degat_explosion*0.5
				vie_joueur = Global.stats_joueur["vie"]
				afficher_message("Vous provoquez une explosion touchant tout le monde")
				await message_fermee
				set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
				set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
				if vie_monstre <= 0 :
					mort_monstre = true
			if "Titik l'enfant rapide" in Global.contrat_actif :
				PA -= 3
			else :
				PA -= 2
			(Global.inventaire)[objet] -= 1	
			bouton_inventaire()	
			if (Global.inventaire)[objet] <= 0 :
				(Global.inventaire).erase(objet)
			if mort_monstre == true :
				$monstre.queue_free()
				fin_combat()
			else :
				$"Action inventaire".hide()
				tour_enemi()
	else :
		if classe_joueur == "Nathan" and indice_objet == 3 and PA >= 1 : #changement
			PA -= 1 
			$Action/boutons.show()
			if Global.stats_joueur["mode"] == "katana" :
				$"Action inventaire/objet inventaire/Objet 4".text = "Mode katana \n (1 PA)"
				Global.stats_joueur["mode"] = "dague"
				Global.stats_joueur["attaque"] = Global.stats_joueur["attaque"] * 0.6
				degat_joueur = Global.stats_joueur["attaque"]
			else : #Global.stats_joueur["mode"] == "dague"
				$"Action inventaire/objet inventaire/Objet 4".text = "Mode dague \n (1 PA)"
				Global.stats_joueur["mode"] = "katana"
				Global.stats_joueur["attaque"] = Global.stats_joueur["attaque"] / 0.6
				degat_joueur = Global.stats_joueur["attaque"]
		elif classe_joueur == "Nathan" and indice_objet == 4 and PA >= 2 : #contre quasi totale	
			PA -= 2	
			$Action/boutons.hide()
			afficher_message("Vous vous préparez à contrer")
			await message_fermee
			$Action/boutons.show()
			contre = true		
		elif classe_joueur == "Paul" and indice_objet == 3 and PA >= 1 : #reset 
			PA -= 1
			if vie_joueur > vie_joueur*0.15 and vie_joueur != 1:
				vie_joueur -= vie_joueur*0.15
				set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
				$Action/boutons.hide()
				afficher_message("Vous sacrifiez une partie de votre santé pour pouvoir remettre ta chance à 0")
				await message_fermee
				$Action/boutons.show()
				Global.stats_joueur["attaque"] = 12 + 4*(Global.stats_joueur["niv"]-1)
				degat_joueur = Global.stats_joueur["attaque"]
		elif classe_joueur == "Paul" and indice_objet == 4 and PA >= 3 : #all-in
			PA -= 3
			$Action/boutons.hide()
			var pv_sacrifier = await demander_valeur_valide()
			await all_in(pv_sacrifier)
		
		elif classe_joueur == "Baptiste" and indice_objet == 3 and len(Global.stats_joueur["ame"]) > 0 : #capacité de monstre
			$"Action inventaire".hide()
			$Action/boutons.hide()
			$"Action nécromantien/capa monstre/Âme 1".text = Global.stats_joueur["ame"][0]
			if len(Global.stats_joueur["ame"]) > 1 :
				$"Action nécromantien/capa monstre/Âme 2".text = Global.stats_joueur["ame"][1]
			else :
				$"Action nécromantien/capa monstre/Âme 2".hide()
			if len(Global.stats_joueur["ame"]) > 2 :	
				$"Action nécromantien/capa monstre/Âme 3".text = Global.stats_joueur["ame"][2]
			else :
				$"Action nécromantien/capa monstre/Âme 3".hide()
			$"Action nécromantien".show()
			afficher_message("Quelle capacité de monstre voulez vous utilisez ?")
			await message_fermee
			$Action/boutons.show()
		elif classe_joueur == "Baptiste" and indice_objet == 4 and PA >= 2 and copier == false: #copieur
			if (Enemi.enemi_actuel in Global.stats_joueur["capa_monstre"].keys()) :
				PA -= 2
				$Action/boutons.hide()
				(Global.stats_joueur["capa_monstre"])[Enemi.enemi_actuel] += 1
				afficher_message("Vous copiez la capacité du monstre imédiatement")
				await message_fermee
				copier = true
			else :
				$Action/boutons.hide()
				afficher_message("Vous ne pouvez pas copier la capacité du monstre")
				await message_fermee
			$Action/boutons.show()
		elif classe_joueur == "Maëlle" and indice_objet == 3 and PA >= 2 : #prière
			$Action/boutons.hide()
			if prière == false :
				PA -= 2
				prière = true
				var alea = rng.randi_range(1,100)
				afficher_message("Vous priez")
				await message_fermee
				if alea < 34 : # attaque
					afficher_message("Vous êtes beni et vous êtes plus fort !")
					await message_fermee
					degat_joueur = degat_joueur * 1.5
				elif alea < 67 : # defense
					afficher_message("Vous êtes beni et vous êtes plus robuste !")
					await message_fermee
					defense = true
				elif alea < 100 : # soin
					afficher_message("Vous êtes beni et vous regagnez de la vie !")
					await message_fermee
					Global.soigner(0.50)
					vie_joueur = Global.stats_joueur["vie"]
					set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
				elif alea == 100 : # Dieu !
					afficher_message("Dieu ?!")
					await message_fermee
					vie_monstre -= vie_monstre
					set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
					afficher_message("Vous gagnez le combat et vous regagnez toute ta vie")
					await message_fermee
					fin_combat()
				$Action/boutons.show()
			else :
				$Action/boutons.show()
		elif classe_joueur == "Maëlle" and indice_objet == 4 and PA >= 2  : #mur de lumière
			$Action/boutons.hide()
			if mur_lumiere[0] == false :
				PA -= 2
				mur_lumiere[0] = true
				afficher_message("Vous vous protégez avec un mur de lumière")
				await message_fermee
			elif mur_lumiere[0] == true :
				afficher_message("Vous êtes déjà protégé")
				await message_fermee
			$Action/boutons.show()
		update_PA()
		if indice_objet == 5 and Global.stats_joueur["xp"] >= xp_next_lvl*0.25 :
			$Action/boutons.hide()
			afficher_message("Vous échangez 25% de la barre d'expérience pour 30% de vie")
			await message_fermee
			Global.stats_joueur["xp"] -= xp_next_lvl*0.25
			xp_joueur = Global.stats_joueur["xp"]
			Global.soigner(0.30)
			vie_joueur = Global.stats_joueur["vie"]
			set_xp(barre_xp_joueur, xp_joueur, xp_next_lvl, barre_xp_joueur_text)
			set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
			$Action/boutons.show()
		if PA <= 0 :
			tour_enemi()	

func update_PA() :
	$"Action/UI joueur/info joueur/PA".text = "PA : " + str(PA)

func _on_passer_button_down() -> void:
	if $Action/boutons/passer.text == "Passer le tour" : 
		$Action/boutons.hide()
		afficher_message("Vous passez votre tour et les PA restants vont dans la jauge")
		await message_fermee
		Global.stats_joueur["barre PA"] += PA
		PA = 0
		update_PA()
		$"Action/UI joueur/barre PA".value = Global.stats_joueur["barre PA"]
		$"Action/UI joueur/barre PA/barre PA".text = str(Global.stats_joueur["barre PA"])
		if Global.stats_joueur["barre PA"] >= 5 :
			Global.stats_joueur["barre PA"] -= 5 
			afficher_message("Vous avez remplie la jauge et cela vous soigne")
			await message_fermee
			$"Action/UI joueur/barre PA".value = Global.stats_joueur["barre PA"]
			$"Action/UI joueur/barre PA/barre PA".text = str(Global.stats_joueur["barre PA"])
			if "Titik l'enfant rapide" in Global.contrat_actif :
				Global.soigner(0.15)
			else :
				Global.soigner(0.3)
			vie_joueur = Global.stats_joueur["vie"]
			set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
		tour_enemi()
	elif classe_joueur == "Baptiste" and $Action/boutons/passer.text == Enemi.enemi_actuel :
		decision.emit()
	
func contrat(nom) :
	$Action/boutons.hide()
	afficher_message("Avant de mourrir, le boss a une dernière proposition")
	await message_fermee
	afficher_message("Il a un pacte à vous proposez :")
	await message_fermee
	if nom == "Nathan" or nom == "Paul" :
		$Contrat/Label.text = "Contrat : \n 
		Proposition : \n Vous pouvez changez de classe et prendre la classe " + str(nom) + "\n
		Contrainte : \n Il n'y a pas de contrainte pour ce contrat"
	elif nom == "Roi vampire" :
		$Contrat/Label.text = "Contrat : \n 
		Proposition : \n Vous ignorez une attaque tout les 7 tours " + "\n
		Contrainte : \n Vous perdez 5% de vie tous les 3 tours"
	elif nom == "La Liche" :
		$Contrat/Label.text = "Contrat : \n 
		Proposition : \n Vous vous soignez de 50% de vos dégâts " + "\n
		Contrainte : \n Vous perdez 50% de votre vie"
	elif nom == "Golem en adamantium" :
		$Contrat/Label.text = "Contrat : \n 
		Proposition : \n Vous doublez votre vie et vous renvoyez 50% des dégâts " + "\n
		Contrainte : \n Vous infligez 50% de dégâts en moins"
	elif nom == "Titik l'enfant rapide" :
		$Contrat/Label.text = "Contrat : \n 
		Proposition : \n Vous gagnez 1 PA supplémentaire " + "\n
		Contrainte : \n Les objets coûtent 1 PA de plus et les soins de la jauge sont divisés par 2"
	elif nom == "Le Salopard" :
		$Contrat/Label.text = "Contrat : \n 
		Proposition : \n Vous gagnez la possibilité d'échanger de l'expérience contre de la vie " + "\n
		Contrainte : \n Vous gagnez 50% d'expérience en moins"
	$Contrat.show()
	$Action/boutons.show()
	$Action/boutons/inventaire.hide()
	$Action/boutons/passer.hide()
	$Action/boutons/attaque.show()	
	$Action/boutons/attaque.text = "Accepter"
	$Action/boutons/attaque.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0, 1.0))
	$"Action/boutons/capacité".show()	
	$"Action/boutons/capacité".text = "Refuser"
	$"Action/boutons/capacité".add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))	 

func effet_contrat():
	$Action/boutons.hide()
	if "Roi vampire" in Global.contrat_actif :
		Global.stats_joueur["Roi vampire"] += 1 
		if Global.stats_joueur["Roi vampire"] > 0 :
			if Global.stats_joueur["Roi vampire"]%3 == 0 :
				vie_joueur -= vie_max_joueur*0.05
				Global.stats_joueur["vie"] = vie_joueur
				afficher_message("Vous perdez 5% de vie")
				await message_fermee
				set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
			if Global.stats_joueur["Roi vampire"]%7 == 0 :
				afficher_message("Vous esquiverez la prochaine attaque")
				await message_fermee
				esquive_joueur = true	
	if "Golem en adamantium" in Global.contrat_actif :
		degat_joueur = Global.stats_joueur["attaque"]*0.5
	if "Titik l'enfant rapide" in Global.contrat_actif :
		PA = 4
		$Action/boutons/inventaire.text = "Inventaire\n(3 PA)"
		update_PA()
	$Action/boutons.show()

func jeter_ame():
	$Action/boutons/attaque.text = Global.stats_joueur["ame"][0]
	$"Action/boutons/capacité".text = Global.stats_joueur["ame"][1]
	$Action/boutons/inventaire.text = Global.stats_joueur["ame"][2]
	$Action/boutons/passer.text = Enemi.enemi_actuel
	$Action/boutons.show()
	
func demander_valeur_valide() :
	
	var valeur_valide = false  
	var valeur = 0
	afficher_message("Choisissez un nombre de point de vie à mettre en jeu") 
	await message_fermee
	while not valeur_valide :
		$Action/LineEdit.show()
		var texte = await $Action/LineEdit.text_submitted
		if texte.is_valid_float() :
			valeur = float(texte)
			if valeur > 0 and valeur < vie_joueur :
				valeur_valide = true
			else :
				$Action/LineEdit.hide()
				afficher_message("Veuillez rentrer un nombre valide") 
				await message_fermee
				$Action/LineEdit.clear()
		else :
			$Action/LineEdit.hide()	
			afficher_message("Veuillez rentrer un nombre valide") 
			await message_fermee
			$Action/LineEdit.clear()
	$Action/LineEdit.clear()
	$Action/LineEdit.hide()
	return valeur
	
func all_in(pv_sacrifier) : 
	var alea = rng.randf_range(0,1)
	if alea <= 0.5 and pv_sacrifier*2 == 1 :
		afficher_message("Vous êtes béni des dieux\nVous infligez 1 dommage") 
		vie_monstre -= pv_sacrifier*2
	elif alea <= 0.5 :
		afficher_message("Vous êtes béni des dieux\nVous infligez " + str(pv_sacrifier*2) + " dommages")
		vie_monstre -= pv_sacrifier*2
	elif alea <= 1 :
		afficher_message("Vous avez joué avec le diable et vous perdez juste votre vie !")
	await message_fermee
	vie_joueur -= pv_sacrifier
	set_health(barre_pv_joueur, vie_joueur, vie_max_joueur, barre_pv_joueur_text, true)
	set_health(barre_pv_monstre, vie_monstre, vie_max_monstre, barre_pv_monstre_text, false)
	$Action/boutons.show()
	
