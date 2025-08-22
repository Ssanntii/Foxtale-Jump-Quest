extends CharacterBody2D

const JUMP_VELOCITY = -300
var SPEED = 100
var player
var chase := false
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("Idle")
	
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if chase == true:
		if anim.animation != "Death":
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				anim.play("Jump")
			if velocity.y > 0:
				anim.play("Fall")
		player = $"../../Player/Foxxi"
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
		velocity.x = direction.x	 * SPEED
	else:
		if anim.animation != "Death":
			anim.play("Idle")
		velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.name == "Foxxi":
		chase = true
		
func _on_player_detection_body_exited(body: Node2D) -> void:
	if body.name == "Foxxi":
		chase = false
		
func _on_player_death_body_entered(body: Node2D) -> void:
	if body.name == "Foxxi":
		death()

func _on_player_collision_body_entered(body: Node2D) -> void:
	if body.name == "Foxxi":
		Game.PlayerHP -= 3
		death()
	
func death():
	Game.Gold += 5
	Utils.saveGame()
	chase = false
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()
