extends CharacterBody2D

enum  {            # стейтмашин отвечает за анимации
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	BLOCK,
	JUMP 
}
	

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var health = 100
var state = MOVE


func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ATTACK2:
			pass
		ATTACK3:
			pass
		JUMP:
			pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
		
	if health <= 0:
		health = 0
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")
		

	move_and_slide()
	
func move_state ():                                 # функция для передвижения персонажа 
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("Idle")
	if direction == -1:
		anim.flip_h = true
	
	elif direction == 1:
		anim.flip_h = false
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animPlayer.play("jump")

func attack_state():
	velocity.x = 0
	animPlayer.play("attack")
	await  animPlayer.animation_finished
	state = MOVE
	
