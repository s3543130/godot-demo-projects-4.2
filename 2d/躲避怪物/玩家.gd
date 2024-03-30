extends Area2D

signal s_击中

@export var v_速度 = 400 # 玩家移动速度（像素/秒）。
var v_屏幕尺寸 # 游戏窗口的大小。

func _ready():
	v_屏幕尺寸 = get_viewport_rect().size
	hide()


func _process(v_间隔):
	var v_速率 = Vector2.ZERO # 玩家的移动向量。
	if Input.is_action_pressed(&"move_right"):
		v_速率.x += 1
	if Input.is_action_pressed(&"move_left"):
		v_速率.x -= 1
	if Input.is_action_pressed(&"move_down"):
		v_速率.y += 1
	if Input.is_action_pressed(&"move_up"):
		v_速率.y -= 1

	if v_速率.length() > 0:
		v_速率 = v_速率.normalized() * v_速度
		$N_动画精灵2D.play()
	else:
		$N_动画精灵2D.stop()

	position += v_速率 * v_间隔
	position = position.clamp(Vector2.ZERO, v_屏幕尺寸)

	if v_速率.x != 0:
		$N_动画精灵2D.animation = &"右"
		$N_动画精灵2D.flip_v = false
		$N_轨迹.rotation = 0
		$N_动画精灵2D.flip_h = v_速率.x < 0
	elif v_速率.y != 0:
		$N_动画精灵2D.animation = &"上"
		rotation = PI if v_速率.y > 0.0 else 0.0


func f_开始(v_位置):
	position = v_位置
	rotation = 0
	show()
	$N_物理形状2D.disabled = false


func _on_玩家实体进入(_body):
	hide() # 玩家被击中后消失。
	s_击中.emit()
	# 必须延迟执行，因为我们不能在物理回调中更改物理属性。
	$N_物理形状2D.set_deferred(&"disabled", true)
