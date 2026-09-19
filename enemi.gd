extends Node

var img_monstre = {"Gobelin" : preload("res://assets/icon.svg"),
"Ogre" : preload("res://assets/icon.svg"),
"Araignée" : preload("res://assets/icon.svg"),
"Squelette" : preload("res://assets/icon.svg"),
"Sorcière" : preload("res://assets/icon.svg"),
"Golem" : preload("res://assets/icon.svg"),
"Nathan" : preload("res://assets/icon.svg"),
"Paul" : preload("res://assets/icon.svg"),
"Roi vampire" : preload("res://assets/icon.svg"),
"La Liche" : preload("res://assets/icon.svg"),
"Golem en adamantium" : preload("res://assets/icon.svg"),
"Titik l'enfant rapide" : preload("res://assets/icon.svg"),
"Le Salopard" : preload("res://assets/icon.svg")}

var fond_monstre = {"Gobelin" : preload("res://assets/icon.svg"),
"Ogre" : preload("res://assets/icon.svg"),
"Araignée" : preload("res://assets/icon.svg"),
"Squelette" : preload("res://assets/icon.svg"),
"Sorcière" : preload("res://assets/icon.svg"),
"Golem" : preload("res://assets/icon.svg"),
"Nathan" : preload("res://assets/icon.svg"),
"Paul" : preload("res://assets/icon.svg"),
"Roi vampire" : preload("res://assets/icon.svg"),
"La Liche" : preload("res://assets/icon.svg"),
"Golem en adamantium" : preload("res://assets/icon.svg"),
"Titik l'enfant rapide" : preload("res://assets/icon.svg"),
"Le Salopard" : preload("res://assets/icon.svg")}

var enemi_actuel = "Gobelin"

var stat_gobelin = {"vie" : 40, "vie max" : 40, "attaque" : 6, "xp" : 15}
var stat_ogre = {"vie" : 80, "vie max" : 80, "attaque" : 10, "xp" : 30}
var stat_spider = {"vie" : 45, "vie max" : 45, "attaque" : 8, "xp" : 20}
var stat_skull = {"vie" : 30, "vie max" : 30, "attaque" : 11, "xp" : 25}
var stat_witch = {"vie" : 60, "vie max" : 60, "attaque" : 10, "xp" : 25}
var stat_golem = {"vie" : 100, "vie max" : 100, "attaque" : 16, "xp" : 50}
var stat_monstre = {"Gobelin" : stat_gobelin, 
"Ogre" : stat_ogre,
"Araignée" : stat_spider,
"Squelette" : stat_skull,
"Sorcière" : stat_witch,
"Golem" : stat_golem}

var boss_nathan = {"vie" : 100 , "vie max" : 100, "attaque" : 5, "saignement" : {"katana" : 15, "dague" : 25}, "xp" : 700}
var boss_paul = {"vie" : 130, "vie max" : 130, "attaque" : 6, "xp" : 700}
var roi_vampire = {"vie" : 150, "vie max" : 150, "attaque" : 8, "xp" : 100, 'compteur' : 1}
var liche = {"vie" : 200, "vie max" : 200, "attaque" : 10, "xp" : 150, 'compteur' : 0}
var golem_adamantium = {"vie" : 350, "vie max" : 350, "attaque" : 0, "xp" : 250, "stockage" : 0 ,'compteur' : 0}
var titik = {"vie" : 250, "vie max" : 250, "attaque" : 12, "xp" : 350, 'compteur' : 0}
var salopard = {"vie" : 400, "vie max" : 400, "attaque" : 0, "xp" : 500}
var stat_boss = {"Nathan" : boss_nathan, 
"Paul" : boss_paul, 
"Roi vampire" : roi_vampire,
"La Liche" : liche,
"Golem en adamantium" : golem_adamantium,
"Titik l'enfant rapide" : titik,
"Le Salopard" : salopard}

func set_stat_boss():
	for nom in stat_boss.keys() :
		if nom == "Nathan" : 
			stat_boss[nom]["vie"] += 25*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["attaque"] += 1.5*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 70*(Global.stats_joueur["niv"]-1)
		elif nom == "Paul" :
			stat_boss[nom]["vie"] += 30*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 70*(Global.stats_joueur["niv"]-1)
		elif nom == "Roi vampire" : 
			stat_boss[nom]["vie"] += 30*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["attaque"] += 1.2*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 35*(Global.stats_joueur["niv"]-1)
		elif nom == "La Liche" : 
			stat_boss[nom]["vie"] += 35*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["attaque"] += 1.4*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 40*(Global.stats_joueur["niv"]-1)
		elif nom == "Golem en adamantium" : 
			stat_boss[nom]["vie"] += 60*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 45*(Global.stats_joueur["niv"]-1)
		elif nom == "Titik l'enfant rapide" : 
			stat_boss[nom]["vie"] += 40*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["attaque"] += 1.6*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 50*(Global.stats_joueur["niv"]-1)
		elif nom == "Le Salopard" : 
			stat_boss[nom]["vie"] += 50*(Global.stats_joueur["niv"]-1)
			stat_boss[nom]["xp"] += 60*(Global.stats_joueur["niv"]-1)
		stat_boss[nom]["vie max"] = stat_boss[nom]["vie"]

func augmenter_stats() :
	for i in stat_monstre :
		for k in stat_monstre[i].keys() :
			if k == "xp" :
				stat_monstre[i][k] = stat_monstre[i][k] * 1.05
			elif k == "vie" or k == "vie max" :
				stat_monstre[i][k] = stat_monstre[i][k] * 1.03
			elif k == "attaque" :
				stat_monstre[i][k] = stat_monstre[i][k] * 1.02
			stat_monstre[i][k] = int(ceil(stat_monstre[i][k]))
			
