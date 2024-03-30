extends Node2D
# 这个演示是一个控制大量2D对象的逻辑和碰撞的例子，而不使用场景中的节点。
# 这种技术比使用实例和节点更有效，但需要更多的编程，并且视觉效果较差。子弹在`v_子弹s.gd`脚本中一起管理。

const V_子弹计数 = 500
const V_最小速度 = 20
const V_最大速度 = 80

const V_子弹图像 = preload("res://子弹.png")


var v_子弹s := []
var v_形状

class C_子弹:
	var v_位置 := Vector2()
	var v_速度 := 1.0
	# 身体被存储为RID，这是一种"不透明"的方式来访问资源。
	# 对于大量的对象（成千上万或更多），使用RID可能比高级方法更快。
	var v_实体 = RID()



func _ready():
	v_形状 = PhysicsServer2D.circle_shape_create()
	# 设置每个子弹的碰撞形状的半径（以像素为单位）。
	PhysicsServer2D.shape_set_data(v_形状, 8)

	for _i in V_子弹计数:
		var v_子弹 = C_子弹.new()
		# 给每个子弹一个随机的速度。
		v_子弹.v_速度 = randf_range(V_最小速度, V_最大速度)
		v_子弹.v_实体 = PhysicsServer2D.body_create()

		PhysicsServer2D.body_set_space(v_子弹.v_实体, get_world_2d().get_space())
		PhysicsServer2D.body_add_shape(v_子弹.v_实体, v_形状)
		# 不让子弹检查与其他子弹的碰撞以提高性能。
		PhysicsServer2D.body_set_collision_mask(v_子弹.v_实体, 0)

		# 在视口上随机放置子弹，并将子弹移出
		# 游戏区域，使它们能够很好地淡入。
		v_子弹.v_位置 = Vector2(
			randf_range(0, get_viewport_rect().size.x) + get_viewport_rect().size.x,
			randf_range(0, get_viewport_rect().size.y)
		)
		var v_变换2d = Transform2D()
		v_变换2d.origin = v_子弹.v_位置
		PhysicsServer2D.body_set_state(v_子弹.v_实体, PhysicsServer2D.BODY_STATE_TRANSFORM, v_变换2d)

		v_子弹s.push_back(v_子弹)


func _process(_delta):
	# 指示CanvasItem在每个帧更新。
	queue_redraw()


func _physics_process(间隔):
	var v_变换2d = Transform2D()
	var offset = get_viewport_rect().size.x + 16
	for 子弹 in v_子弹s:
		子弹.v_位置.x -= 子弹.v_速度 * 间隔

		if 子弹.v_位置.x < -16:
			# 当子弹离开屏幕时，将子弹移回右边。
			子弹.v_位置.x = offset

		v_变换2d.origin = 子弹.v_位置
		PhysicsServer2D.body_set_state(子弹.v_实体, PhysicsServer2D.BODY_STATE_TRANSFORM, v_变换2d)


# 我们在这里一次绘制*所有*的子弹，而不是在每个子弹上附加的脚本中单独绘制每个子弹。
func _draw():
	var v_抵消 = -V_子弹图像.get_size() * 0.5
	for 子弹 in v_子弹s:
		draw_texture(V_子弹图像, 子弹.v_位置 + v_抵消)


# 执行清理操作（退出时需要避免控制台中的错误消息）。
func _exit_tree():
	for 子弹 in v_子弹s:
		PhysicsServer2D.free_rid(子弹.v_实体)

	PhysicsServer2D.free_rid(v_形状)
	v_子弹s.clear()
