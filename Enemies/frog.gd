extends CharacterBody2D

var SPEED = 50
var player
var chase := false

func _ready():
	$AnimatedSprite2D.play("Idle")
	
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if chase == true:
		if $AnimatedSprite2D.animation != "Death":
			$AnimatedSprite2D.play("Jump")
		player = $"../../Player/Foxxi"
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		velocity.x = direction.x	 * SPEED
	else:
		if $AnimatedSprite2D.animation != "Death":
			$AnimatedSprite2D.play("Idle")
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
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
