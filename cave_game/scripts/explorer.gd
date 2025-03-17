extends AnimatedSprite2D

const FLIP_SPEED = 1.5
var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	
	if timer >= FLIP_SPEED:
		if flip_h:
			flip_h = false
		else:
			flip_h = true
		timer = 0
	pass
