extends Node

@export var v_怪物场景: PackedScene
var v_分数

func f_游戏结束():
	$N_得分计时器.stop()
	$N_怪物计时器.stop()
	$HUD.f_显示游戏结束()
	$Music.stop()
	$DeathSound.play()


func f_新游戏():
	get_tree().call_group(&"mobs", &"queue_free")
	v_分数 = 0
	$N_玩家.f_开始($N_开始地点.position)
	$N_开始计时器.start()
	$HUD.f_更新分数(v_分数)
	$HUD.f_显示消息("做好准备")
	$Music.play()


func _on_怪物计时器_结束():
	# 创建一个新的 Mob 场景实例。
	var v_怪物 = v_怪物场景.instantiate()

	# 在 Path2D 上选择一个随机位置。
	var v_怪物生成位置 = $"N_怪物路径/N_怪物生成位置"
	v_怪物生成位置.progress = randi()

	# 将怪物的方向设置为与路径方向垂直。
	var v_方向 = v_怪物生成位置.rotation + PI / 2

	# 将怪物的位置设置为随机位置。
	v_怪物.position = v_怪物生成位置.position

	# 在方向上添加一些随机性。
	v_方向 += randf_range(-PI / 4, PI / 4)
	v_怪物.rotation = v_方向

	# 为怪物选择速度。
	var v_速率 = Vector2(randf_range(150.0, 250.0), 0.0)
	v_怪物.linear_velocity = v_速率.rotated(v_方向)

	# 通过将怪物添加到 Main 场景中来生成怪物。
	add_child(v_怪物)

func _on_得分计时器_结束():
	v_分数 += 1
	$HUD.f_更新分数(v_分数)


func _on_开始计时器_结束():
	$N_怪物计时器.start()
	$N_得分计时器.start()
