extends Node

var stats_joueur = {}
var inventaire = {}
var contrat_actif = []
var xp_prochain_lvl = 100
var spawn_monstre = true
var spawn_portail = false
var etage = 0

var save = "user://ficher_sauvegarde"

func augmenter_stats() :
	if stats_joueur["classe"] == "Nathan" :
		stats_joueur["vie max"] += 25
		stats_joueur["attaque"] += 1.5
	elif stats_joueur["classe"] == "Paul" :
		stats_joueur["vie max"] += 30
		stats_joueur["attaque"] += 1.8
	elif stats_joueur["classe"] == "Baptiste" :
		stats_joueur["vie max"] += 20
		stats_joueur["attaque"] += 1.2
	elif stats_joueur["classe"] == "Maëlle" :
		stats_joueur["vie max"] += 15
		stats_joueur["attaque"] += 1
	stats_joueur["vie"] = stats_joueur["vie max"]
		
func choisir_classe(classe) :
	stats_joueur["classe"] = classe
	if classe == "Nathan" :
		stats_joueur["vie max"] = 100
		stats_joueur["attaque"] = 5
		stats_joueur["saignement"] = {"katana" : 30, "dague" : 50}
		stats_joueur["mode"] = "katana"
	elif classe == "Paul" :
		stats_joueur["vie max"] = 130
		stats_joueur["attaque"] = 6
	elif classe == "Baptiste" : #nécromantien
		stats_joueur["vie max"] = 100
		stats_joueur["attaque"] = 5
		stats_joueur["ame"] = ["Gobelin"]
	elif classe == "Maëlle" : #pretresse
		stats_joueur["vie max"] = 95
		stats_joueur["attaque"] = 4
	stats_joueur["barre PA"] = 0
	stats_joueur["vie"] = stats_joueur["vie max"]	
	stats_joueur["niv"] = 1
	stats_joueur["xp"] = 0
	stats_joueur["altération"] = false
	
func ajouter_objet_inventaire(objet) :
	if objet not in inventaire.keys() :
		inventaire[objet] = 1 
	else :
		inventaire[objet] += 1
		
func ajouter_contrat(contrat) :
	Enemi.stat_boss.erase(contrat)
	if contrat not in contrat_actif :
		contrat_actif.append(contrat)
	if contrat == "Nathan" or contrat == "Paul" :
		changement_de_classe(contrat)
	elif contrat == "Roi vampire" :
		stats_joueur["Roi vampire"] = 0
	elif contrat == "La Liche" :
		stats_joueur["vie max"] = stats_joueur["vie max"]*0.5
		stats_joueur["vie"] = stats_joueur["vie max"]
	elif contrat == "Golem en adamantium" :
		stats_joueur["vie max"] = stats_joueur["vie max"]*2
		stats_joueur["vie"] = stats_joueur["vie max"]
	elif contrat == "Titik l'enfant rapide" :
		stats_joueur["Titik l'enfant rapide"] = 0

func soigner(soin) :
	if (stats_joueur["vie"] + stats_joueur["vie max"]*soin) < stats_joueur["vie max"] :
		stats_joueur["vie"] += stats_joueur["vie max"]*soin
	else :
		stats_joueur["vie"] = stats_joueur["vie max"]

func reset():
	etage = 0
	inventaire = {}
	contrat_actif = []
	#ajouter_contrat("")
	Enemi.enemi_actuel = "Gobelin"
	Enemi.stat_gobelin = {"vie" : 40, "vie max" : 40, "attaque" : 6, "xp" : 15}
	Enemi.stat_ogre = {"vie" : 80, "vie max" : 80, "attaque" : 10, "xp" : 30}
	Enemi.stat_spider = {"vie" : 45, "vie max" : 45, "attaque" : 8, "xp" : 20}
	Enemi.stat_skull = {"vie" : 30, "vie max" : 30, "attaque" : 11, "xp" : 25}
	Enemi.stat_witch = {"vie" : 60, "vie max" : 60, "attaque" : 10, "xp" : 25}
	Enemi.stat_golem = {"vie" : 100, "vie max" : 100, "attaque" : 16, "xp" : 50}
	Enemi.stat_monstre = {"Gobelin" : Enemi.stat_gobelin, 
	"Ogre" : Enemi.stat_ogre,
	"Araignée" : Enemi.stat_spider,
	"Squelette" : Enemi.stat_skull,
	"Sorcière" : Enemi.stat_witch,
	"Golem" : Enemi.stat_golem}
	
func changement_de_classe(classe) :
	stats_joueur["classe"] = classe
	if classe == "Nathan" :
		stats_joueur["vie max"] = 100 + 25 * (stats_joueur["niv"]-1)
		stats_joueur["attaque"] = 5 + 1.5 * (stats_joueur["niv"]-1)
		stats_joueur["saignement"] = {"katana" : 30, "dague" : 50}
		stats_joueur["mode"] = "katana"
	elif classe == "Paul" :
		stats_joueur["vie max"] = 130 + 30 * (stats_joueur["niv"]-1)
		stats_joueur["attaque"] = 6 + 1.8 * (stats_joueur["niv"]-1)
	stats_joueur["vie"] = stats_joueur["vie max"]	

func save_data() : 
	var file = FileAccess.open(save, FileAccess.WRITE)
	file.store_var(stats_joueur)
	file.store_var(etage)
	file.store_var(inventaire)
	file.store_var(contrat_actif)
	file.store_var(xp_prochain_lvl)
	file.store_var(Enemi.enemi_actuel)
	file.store_var(Enemi.stat_monstre)
	file.store_var(Enemi.stat_boss)
	file.close()
	
func load_data() :
	if FileAccess.file_exists(save) :
		var file = FileAccess.open(save, FileAccess.READ)
		stats_joueur = file.get_var()
		etage = file.get_var()
		inventaire = file.get_var()
		contrat_actif = file.get_var()
		xp_prochain_lvl = file.get_var()
		Enemi.enemi_actuel = file.get_var()
		Enemi.stat_monstre = file.get_var()
		Enemi.stat_boss = file.get_var()
		file.close()
	else :
		reset()
		
func supprimer_savegarde() :
	if FileAccess.file_exists(save) :
		var dir = DirAccess.open("user://")
		dir.remove(save)
