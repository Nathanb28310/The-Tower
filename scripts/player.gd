extends CharacterBody2D
class_name Player

@onready var screen_size = get_viewport_rect().size
@export var speed = 300
@export var acceleration = 100
@onready var animation_player
var last_direction = "up"

func _physics_process(_delta: float) -> void:
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	var direction = Input.get_vector("left", "right", "up", "down") 
	velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
	velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
	move_and_slide()
	#update_animation(direction)
	
func update_animation(dir) :
	if Global.stats_joueur["classe"] == "Nathan" : 
		animation_player = $"Animation Nathan"
	elif Global.stats_joueur["classe"] == "Paul" :
		animation_player = $"Animation Paul"
	elif Global.stats_joueur["classe"] == "Baptiste" :
		animation_player = $"Animation Baptiste"
	elif Global.stats_joueur["classe"] == "Maëlle" :
		animation_player = $"Animation Maëlle"
	
	if dir != Vector2.ZERO :
		if abs(dir.x) >= abs(dir.y) :
			if dir.x > 0 :
				last_direction = "right"
			else :
				last_direction = "left"
		else :
			if dir.y > 0 :
				last_direction = "down"
			else :
				last_direction = "up"		
		animation_player.play("walk_" + last_direction)
	else :		
		animation_player.play("idle_" + last_direction)
