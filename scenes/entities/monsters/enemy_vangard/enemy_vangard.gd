extends CharacterBody2D

const SPEED: int = 150
const KNOCKBACK_FORCE: int = 100

var is_alive: bool = true
var health: int = 100
var target = null


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if is_alive and target: 
		_attack(delta)


func _attack(_delta: float) -> void:
	# Calculate direction using global_position to handle node hierarchy accurately
	var direction = (target.global_position - global_position).normalized()
	
	# Set velocity and use move_and_slide() to trigger physics collision with obstacles
	velocity = direction * SPEED
	move_and_slide()
	
	animated_sprite_2d.play("attack")


func take_damage(damage: int, attacker_position: Vector2) -> void:
	health -= damage
	print(health)
	if health <= 0:
		_die()
	else:
		# Calculate knockback direction using global_position
		var knockback_direction = (global_position - attacker_position).normalized()
		var target_position = global_position + knockback_direction * KNOCKBACK_FORCE
		
		# Smooth knockback animation using Tween
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)	
		tween.tween_property(self, "global_position", target_position, 0.5)


func _die() -> void:
	is_alive = false
	velocity = Vector2.ZERO
	animated_sprite_2d.play("die")
	
	# Disable collisions safely
	$CollisionShape2D.set_deferred("disabled", true)
	$VisionRange/CollisionShape2D.set_deferred("disabled", true)


func _on_vision_range_body_entered(body: Node2D) -> void:
	# Set target when Player enters vision range
	if body.name == "PlayerLilith" or body.is_in_group("player"):
		target = body


func _on_vision_range_body_exited(body: Node2D) -> void:
	# Reset target when Player leaves vision range
	if (body.name == "PlayerLilith" or body.is_in_group("player")) and is_alive:
		target = null
		velocity = Vector2.ZERO
		animated_sprite_2d.play("idle")
