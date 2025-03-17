extends CharacterBody2D

const WALK_FORCE = 10
const AIR_MOVE_FORCE = 5
const WALK_SPEED = 80
const CROUCH_SPEED = 20
const JUMP_VELOCITY = -100
const GRAVITY = Vector2(0, 4)
const WALL_SLIDE_SPEED = 20

var is_moving_left = false
var is_moving_right = false
var is_crouching = false
var can_jump

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	can_jump = false
	if is_on_floor() or is_on_wall():
		can_jump = true
	
	is_crouching = false
	if is_on_floor() and Input.is_action_pressed("crouch"):
		is_crouching = true
	
	# GET MOVEMENT INPUT
	is_moving_left = false
	is_moving_right = false
	var direction = Input.get_axis("move_left", "move_right") # get horizontal movement input
	if direction > 0:
		is_moving_right = true
	if direction < 0:
		is_moving_left = true
	
	if not is_on_floor(): # Player is falling
		if is_on_wall() and direction != 0: # wall sliding
			if velocity.y < WALL_SLIDE_SPEED:
				velocity += GRAVITY
			else:
				velocity.y = WALL_SLIDE_SPEED
		else: # free falling
			velocity += GRAVITY
	
	if direction == 0: # Stopping player's momentum
		if velocity.x > 0: # velocity is rightwards?
			velocity.x -= velocity.x / 2 # accelerate left towards 0
		elif velocity.x < 0: # velocity is leftwards?
			velocity.x -= velocity.x / 2 # accelerate right towards 0
	else: # Player is actively moving
		if not is_crouching: # NORMAL MOVEMENT
			if is_moving_left and velocity.x > (-1 * WALK_SPEED): # Player is moving left
				if is_on_floor():
					velocity.x += direction * WALK_FORCE # add movement velocity
				else:
					velocity.x += direction * AIR_MOVE_FORCE
			if is_moving_right and velocity.x < WALK_SPEED: # Player is moving right
				if is_on_floor():
					velocity.x += direction * WALK_FORCE # add movement velocity
				else:
					velocity.x += direction * AIR_MOVE_FORCE
		else: # CROUCHING MOVEMENT
			if is_moving_left and velocity.x > (-1 * CROUCH_SPEED): # Player is moving left
				if is_on_floor():
					velocity.x += direction * WALK_FORCE # add movement velocity
				else:
					velocity.x += direction * AIR_MOVE_FORCE
			if is_moving_right and velocity.x < CROUCH_SPEED: # Player is moving right
				if is_on_floor():
					velocity.x += direction * WALK_FORCE # add movement velocity
				else:
					velocity.x += direction * AIR_MOVE_FORCE
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			if is_on_floor(): # floor jump
				velocity.y = JUMP_VELOCITY
			elif is_on_wall_only(): # wall jump
				if is_moving_left:
					velocity.y = JUMP_VELOCITY * 0.7
					velocity.x -= JUMP_VELOCITY * 0.7
				elif is_moving_right:
					velocity.y = JUMP_VELOCITY * 0.7
					velocity.x += JUMP_VELOCITY * 0.7
	
	# ANIMATIONS
	if is_moving_right:
		animated_sprite_2d.flip_h = false
	if is_moving_left:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if is_crouching:
			animated_sprite_2d.play("crouching")
		else:
			if is_moving_right or is_moving_left: # moving right
				animated_sprite_2d.play("moving")
			else: # not moving
				animated_sprite_2d.play("idle")
	elif is_on_wall() and direction != 0: # wall sliding
		if is_moving_left:
			animated_sprite_2d.play("wall_sliding")
			animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
		if is_moving_right:
			animated_sprite_2d.play("wall_sliding")
			animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
	else: # not on wall or floor
		if velocity.y <= 0: # upwards momentum
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("falling")

	move_and_slide()
