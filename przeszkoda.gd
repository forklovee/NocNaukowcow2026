extends RigidBody2D


func _physics_process(delta: float) -> void:
	for kolizja in get_colliding_bodies():
		if kolizja.is_in_group("Pocisk"):
			trafiony(kolizja)

func trafiony(pocisk: RigidBody2D):
	if pocisk.linear_velocity.length() > 50.0:
		print(self, " trafiony przez ", pocisk)
		queue_free()

