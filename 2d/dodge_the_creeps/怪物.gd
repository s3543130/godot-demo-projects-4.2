extends RigidBody2D

func _ready():
	$N_动画精灵2D.play()
	var v_怪物类型s = Array($N_动画精灵2D.sprite_frames.get_animation_names())
	$N_动画精灵2D.animation = v_怪物类型s.pick_random()


func _on_屏幕可见性通知器2d_屏幕离开():
	queue_free()
