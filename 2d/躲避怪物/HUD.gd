extends CanvasLayer

signal s_开始游戏

func f_显示消息(v_文本):
	$N_消息标签.text = v_文本
	$N_消息标签.show()
	$N_消息计时器.start()


func f_显示游戏结束():
	f_显示消息("游戏结束")
	await $N_消息计时器.timeout
	$N_消息标签.text = "躲避怪物"
	$N_消息标签.show()
	await get_tree().create_timer(1).timeout
	$N_开始按钮.show()


func f_更新分数(v_分数):
	$N_分数标签.text = str(v_分数)


func _on_开始按钮_按下():
	$N_开始按钮.hide()
	s_开始游戏.emit()


func _on_消息计时器_结束():
	$N_消息标签.hide()
