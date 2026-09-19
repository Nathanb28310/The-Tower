# **<u>The Tower</u>** 

# **Cahier des charges** 

Vert : Idée qui n’a pas été retenue/à développer pour des raisons de dev, d’équilibrage... 

Rouge : A faire 

## **<u>Fonctionnement :</u>** 

- On choisit au début de l’aventure une classe parmi celles disponibles. On est dans une tour et on parcours plusieurs étages, à chaque étage on affronte 1 monstre parmi les monstres disponibles. 

- Si l’étage est un multiple de 10, on affronte un boss parmi ceux disponibles. Tout les 2 étages on regagne de la vie (30% de la vie max). 

- Chaque boss battu donne un contrat : avec 1 bonus et 1 malus 

- Après chaque étage, la vie, l’attaque et l’XP des monstre augmentent à hauteur de 3%, 2% et 5% 

- Si la barre d’XP du joueur est rempli (avec comme valeur 100 au départ), il augmente de niveau, ce qui augmente ses statistiques et sa vie se régénère au max (mais le niveau d’XP du prochain niveau augmente de 12%) 

## **<u>Classes :</u>** 

- Nathan : a un katana et une dague qui font du saignement, quand la barre de saignement de l'ennemi est rempli cela fait des dégâts supplémentaires (20% de la vie max de l’ennemi). 

- Paul : tous les tours il a 50% de chance de doublé ses dégâts ou de diviser ses dégâts par 2. 

- Baptiste : quand il tue un ennemi il récupère son âme (à un stock de 3). Et plus tard il peut soit là consommer pour se soigner de 15% et reprendre 1 PA ou sacrifier l’âme pour déclencher un effet. 

- Maëlle : une simple prêtresse 

### **<u>Capacité :</u>** 

- Nathan : 

   - <u>Changement : peut changer entre le mode dague et le mode katana, la</u> dague fait moins de dégâts mais plus de saignement et inversement pour le katana (le joueur commence avec le katana) **(1 PA).** 

   - <u>Contre quasi totale : passe en posture défensive jusqu'à son prochain tour.</u> S'il subit une attaque, il esquive 50% des dégâts et riposte immédiatement avec son arme équipée (en appliquant du saignement) **(2 PA).** 

- Paul : 

   - <u>Reset : peut remettre à zéro sa chance (son attaque redevient celle de</u> base), mais perd 15% de sa vie actuelle **(1 PA).** 

- <u>All-in : ⅓ de x3, ⅓ de x1, ⅓ de faire redescendre l’attaque à 1</u> **(3 PA).** 

- Baptiste : 

   - <u>Collection d’âme :</u> **(dans la limite de 3 âmes stockées + 1 ou 2 PA) : Gobelin : +30% d’attaque (1 PA) Ogre :** 

      - **Araignée : bloque l’ennemi pendant 1 tour (2 PA)** 

      - **Squelette : 35% d’esquiver l’attaque ennemi (1 PA) Sorcière : -5% de PV max ennemi/tour (2 PA)** 

      - **Golem : -10% d’attaque ennemi/tour (2 PA)** 

   - <u>Copieur</u> **<u>:</u>** prend la capacité immédiatement **(1 fois par combat, mais ne récupère pas la capacité en tuant le monstre + 2 PA).** 

- Maëlle : 

   - <u>Prière : peut prier et elle a 33% de récupérer la moitié de sa vie, de</u> booster ses dégâts de 50%, ou de prendre la moitié des dégâts. Et elle a 1% de récupérer toute sa vie et de tuer l'ennemi **(2 PA).** 

   - <u>Mur de lumière : Convertit 30% des dégâts subis en soin pendant 2 tours</u> **(2 PA).** 

### **<u>Statistiques :</u>** 

|**Nom Classe**|**Nathan**|**Paul**|**Baptiste**|**Maëlle**|
|---|---|---|---|---|
|PV|100|130|100|95|
|Attaque|5|6|5|4|
|Attaque<br>(dague)|3|X|X|X|
|Saignement<br>(katana)|30%|X|X|X|
|Saignement<br>(dague)|50%|X|X|X|



### **<u>Statistiques (augmentation de niveau) :</u>** 

|**Nom Classe**|**Nathan**|**Paul**|**Baptiste**|**Maëlle**|
|---|---|---|---|---|
|PV|+25|+30|+20|+15|
|Attaque|+1.5|+1.8|+1.2|+1|



## **<u>Ennemis :</u>** 

- Gobelin : pas d’effet Ogre : 50% de chance de charger une attaque qui fait +20 dégâts Araignée : 20% de chance de bloquer le joueur pendant 1 tour Squelette : 35% de chance d’esquiver l’attaque du joueur 

- Sorcière : 20% de chance d’empoisonner le joueur (qui enlève 5% de la vie max jusqu'à la fin du combat) 

Golem : baisse de 10% l’attaque du joueur par tour 

### **<u>Statistiques :</u>** 

|**Nom**<br>**Ennemi**|**Gobelin**|**Ogre**|**Araignée**|**Squelette**|**Sorcière**|**Golem**|
|---|---|---|---|---|---|---|
|PV|40|80|45|30|60|100|
|Attaque|6|10|8|11|10|16|
|XP|15|30|20|25|25|50|



## **<u>Objets :</u>** 

Le joueur peut récupérer des objets sur des monstres et les utilise pendant le combat, mais consommer un objet fait gaspiller deux PA. 

|**Nom Objet**|**Kit de soin**|**Explosifs**|**Bouclier**|
|---|---|---|---|
|Taux d’apparition|5%|15%|25%|
|Effet|Rend toute la vie<br>au joueur|Infliges 50 dégâts<br>à l’ennemi mais<br>le joueur prend<br>50% des dégâts<br>comme<br>contrecoup|Le prochain coup<br>t’infliges 50% de<br>dégât en moins|



## **<u>Boss :</u>** 

Roi vampire : son attaque le soigne de 30% de ses dégâts et met du saignement (15%) ignore tous les dégâts un tour sur deux. 

<u>Contrat : le joueur</u> ignore une attaque tout les 7 tours mais il perd 5% de sa vie tous les 3 tours. 

La Liche : son attaque le soigne du même montant que ses dégâts, ne peut pas se faire one shoot, à sa mort il revient à la vie pendant 2 tours. 

<u>Contrat : le joueur se soigne du même montant que la moitié de ses dégâts, mais</u> perd 50% de sa vie. 

- Golem en adamantium : il a de la vie aberrante, n’attaque même pas il renvoie 50% des dégâts du joueur qu’il a stocké au troisième tour. 

<u>Contrat : le joueur double sa vie</u> mais inflige 50% de dégâts en moins, il a un renvoie 50% des dégâts et les dégâts appliquée active également l’effet de la classe. 

- Titik l’enfant rapide : il joue avant toi et joue deux fois d’affilée tous les deux tours, le premier tours il ne fait rien et t’observe, il copie chacune de tes attaques mais les reproduit deux fois avec l’effet de ta classe. 

<u>Contrat : le joueur aura un effet d’une autre classe qu’il aura choisie tous les 3</u> tours, en échange les ennemis joueront toujours un tours de plus que lui tous les deux tours. 

<u>Contrat : le joueur gagne 1 PA mais le prix des objets augmentent de 1 PA et le</u> soin de la jauge de PA est divisé par 2. 

- Le Salopard : il a 50% de chance d’esquiver ton attaque mais il ne te met pas de dégât. Si il te touche tu a 50% de chance de perdre 20% de ta barre d’XP. 

<u>Contrat : le joueur gagne 50% moins d’XP, mais il gagne la possibilité d’échanger</u> l’XP de sa barre contre de la vie (si sa barre est remplie à 80%, il peut échanger cela contre 40% de vie). 

<u>Contrat : le joueur gagne la capacité Vente d’expérience : peut vendre 25% de sa</u> barre d’XP contre 30% de vie, mais il gagne 35% d’XP en moins 

- Nathan/Paul : deux boss avec les mêmes attaques et effets que leur classe respective. Il ont les stats de leur classe au même niveau que le joueur. 

<u>Contrat : tu peux échanger de classe pour prendre la classe du boss battu.</u> 

### **<u>Statistiques (n=niveau joueur) :</u>** 

|**Nom**<br>**Boss**|Roi<br>vampire|Liche|Golem|Titik|Salopard|Nathan/Paul|
|---|---|---|---|---|---|---|
|PV|150 +<br>30n|200 +<br>35n|350 +<br>60n|250<br>+<br>40n|400 + 50n|voir description|
|Attaque|8 + 1.2n|10 +<br>1.4n|X|12 +<br>1.6n|X|voir description|
|XP|100 +<br>35n|150 +<br>40n|250 +<br>45n|350<br>+<br>50n|500 + 60n|700 + 70n|



## **<u>Fonctionnement du tour par tour :</u>** 

- Le joueur commence chaque tour avec 3 PA. 

- À la fin de ton tour, tes PA restants remplisse une barre et au bout de 5 PA dans la barre, cela te soigne de 30%. Et tu récupères 3 PA au début du tour suivant. 

- Cela peut permettre à la classe de Paul d’augmenter sa chance avec son attaque : 1 PA = 50% de x2 ou 50% de /2, 2 PA = 60% de x1.5 ou 40% de /2.25, 3 PA = 75% de x1.25 ou 50% de /2.5 

## **<u>À faire :</u>** 

- Trouver des assets (sprites, sons...) et les mettres dans le jeux Gérer le problème des float qui ne s’affiche pas correctement 

- Problème avec le saignement de Nathan qui peut faire apparaitre plein de 9 (arrondir constamment les différents PV à max 2 chiffres après la virgule) Équilibrer le jeu, pour rajouter de la difficulté et de la stratégie car pour l’instant le jeu est trop simple (Nathan roule sur le jeu notamment). 

   - Rendre le premier boss difficile pour les premières run 

- Rajouter un système comme les autres rogue-like pour pouvoir améliorer son perso après une run 

- Jeu infini ou ajouter une fin ? 


