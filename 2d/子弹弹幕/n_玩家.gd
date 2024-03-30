extends Node2D
# 这个示例演示了如何使用逻辑和碰撞来控制大量的2D对象，而不使用场景中的节点。
# 这种技术比使用实例化和节点更高效，但需要更多的编程，并且不太直观。
# 子弹在`v_子弹s.gd`脚本中一起管理。

# 当前被玩家触碰的v_子弹数量。
var v_碰撞 = 0

@onready var v_精灵 = $N_动画精灵2D


func _ready():
	# 玩家自动跟随鼠标光标，因此没有必要显示鼠标光标。
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event):
	# 获取鼠标的移动，以便精灵可以跟随其位置。
	if event is InputEventMouseMotion:
		position = event.position - Vector2(0, 16)


func _on_body_shape_entered(_body_id, _body, _body_shape, _local_shape):
	# 玩家被子弹触碰，精灵变成悲伤的表情。
	v_碰撞 += 1
	if v_碰撞 >= 1:
		v_精灵.frame = 1


func _on_body_shape_exited(_body_id, _body, _body_shape, _local_shape):
	v_碰撞 -= 1
	# 当没有任何v_子弹触碰玩家时，精灵变成开心的表情。
	if v_碰撞 == 0:
		v_精灵.frame = 0
