extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -100.0
const GRAVITY = Vector2(0, 4)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += GRAVITY # add custom gravity

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = 0
	if Input.is_action_pressed("move_left"):
		velocity.x = -1 * SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	

	move_and_slide()
