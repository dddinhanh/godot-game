extends CharacterBody2D

const SPEED = 50.0

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player = null
var player_in_chat_zone = false


func _ready() -> void:
	randomize()
	start_pos = position


func _physics_process(_delta: float) -> void:

	# -------------------------
	# ANIMATION
	# -------------------------
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle_down")

	elif current_state == MOVE and !is_chatting:
		if dir == Vector2.RIGHT:
			$AnimatedSprite2D.play("walk_right")

		elif dir == Vector2.DOWN:
			$AnimatedSprite2D.play("walk_down")

		elif dir == Vector2.LEFT:
			$AnimatedSprite2D.play("walk_right")
			$AnimatedSprite2D.flip_h = true

		elif dir == Vector2.UP:
			$AnimatedSprite2D.play("idle_down")


	# -------------------------
	# ROAMING / MOVEMENT
	# -------------------------
	if is_roaming and !is_chatting:

		match current_state:

			IDLE:
				velocity = Vector2.ZERO

			NEW_DIR:
				dir = choose([
					Vector2.RIGHT,
					Vector2.LEFT,
					Vector2.UP,
					Vector2.DOWN
				])

				velocity = Vector2.ZERO

			MOVE:
				velocity = dir * SPEED
				move_and_slide()

	else:
		velocity = Vector2.ZERO


	# -------------------------
	# CHAT
	# -------------------------
	if player_in_chat_zone \
	and Input.is_action_just_pressed("chat") \
	and !is_chatting:

		print("Chatting with npc")

		$Dialogue.start()

		is_roaming = false
		is_chatting = true
		velocity = Vector2.ZERO

		$AnimatedSprite2D.play("idle_down")


func choose(array):
	array.shuffle()
	return array.front()


func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_in_chat_zone = true

		print("Player entered chat zone")


func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		player_in_chat_zone = false

		print("Player exited chat zone")


func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([
		0.5,
		1.0,
		1.5
	])

	current_state = choose([
		IDLE,
		NEW_DIR,
		MOVE
	])


func _on_dialogue_dialogue_finished() -> void:
	is_chatting = false
	is_roaming = true
