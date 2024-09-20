extends BoxContainer

var control_toggle = false
var timed_switch = 0

signal auto_art1
signal auto_art2
signal auto_art3

# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.auto_play:
		%AutoAllButton.set_pressed(true)
	
	visible_controll_toggle()
	
	timed_switch = %ArtTimer.wait_time/(%Previews.get_child_count(false)+1)
	print("Gallery count: ", timed_switch)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Settings.auto_play || Settings.auto_play && Settings.art_show == "":
		if %ArtTimer.get_time_left() >= 60:
			emit_signal("auto_art1")
		elif %ArtTimer.get_time_left() <= 60 && %ArtTimer.get_time_left() >= 30:
			emit_signal("auto_art2")
		elif %ArtTimer.get_time_left() <= 30:
			emit_signal("auto_art3")

func visible_controll_toggle():
	if %VisibleButton.text == "︾":
		%VisibleButton.set_self_modulate(Color(1,1,1,1))
		%PlayPauseButton.visible = true
		%AutoAllButton.visible = true
		%FolderButton.visible = true
		%CreditsButton.visible = true
		if Settings.auto_play:
			%AuthButton.visible = false
		else:
			%AuthButton.visible = true
	else:
		%VisibleButton.set_self_modulate(Color(1,1,1,.5))
		%PlayPauseButton.visible = false
		%AutoAllButton.visible = false
		%FolderButton.visible = false
		%CreditsButton.visible = false
		%AuthButton.visible = false
	
func _on_visible_button_mouse_entered():
	%VisibleButton.text = "︾"
	visible_controll_toggle()

func _on_play_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		%ArtTimer.paused = true
		%PlayPauseButton.text = "⏸"
		%PlayPauseButton.set_self_modulate(Color.RED)
	else:
		%ArtTimer.paused = false
		%PlayPauseButton.text = "▶"
		%PlayPauseButton.set_self_modulate(Color(1,1,1,1))



func _on_auto_all_button_toggled(toggled_on):
	if toggled_on:
		%AutoAllButton.set_self_modulate(Color.GREEN)
		Settings.auto_play = true
		Settings.save_settings("Auto_Play", Settings.auto_play)
		%AuthButton.visible = false
		
		%Vote1.visible = false
		%Vote2.visible = false
		%Vote3.visible = false
	else:
		%AutoAllButton.set_self_modulate(Color(1,1,1,1))
		Settings.auto_play = false
		Settings.save_settings("Auto_Play", Settings.auto_play)
		%AuthButton.visible = true

		%Vote1.visible = true
		%Vote2.visible = true
		%Vote3.visible = true


func _on_folder_button_pressed():
	%FileDialog.popup_centered()


func _on_folder_button_mouse_entered():
	%FolderButton.set_tooltip_text(str("Current Folder:\n", Settings.art_show))


func _on_credits_button_pressed():
	OS.shell_open("https://pinkwispslinkie.carrd.co/")


func _on_mouse_exited():
	%VisibleButton.text = ""
	visible_controll_toggle()


func _on_mouse_entered():
	%VisibleButton.text = "︾"


func _on_auth_button_pressed():
	if !FileAccess.file_exists("user://auth.txt"):
		%AuthButton.tooltip_text = """Gift plugin not included in the free version. 
		Feel free to download the source code and 
		install a twitch plugin yourself or 
		buy the convenience version."""
		%AuthButton.set_self_modulate(Color.RED)
		$Timer.start()
	else:
		var file = FileAccess.open("user://auth.txt",FileAccess.READ)
		%TextEdit.text = file.get_as_text()
		
		#make sure everything is hidden before window pops up
		%TextEdit.visible = false
		%CensorButton.visible = true
		%Window.visible = false
		%Button.text = "Save"
		%Button.set_self_modulate(Color(1,1,1,1))
		%Window.popup_centered()
		
		%AuthButton.tooltip_text = """Connect to twitch so chat can vote for their favs. 
		GIFT plugin by issork
		Thank you for your support! ❤👻"""
	

func _on_timer_timeout():
	%AuthButton.set_self_modulate(Color(1,1,1,1))
	%AuthButton.tooltip_text = "Connect to twitch so chat can vote for their favs. \n GIFT plugin by issork"


func _on_censor_button_pressed():
	%TextEdit.visible = true
	%CensorButton.visible = false


func _on_window_close_requested():
	_on_button_pressed()
	%TextEdit.visible = false
	%CensorButton.visible = true
	%Window.visible = false


func _on_button_pressed() -> void:
	var file = FileAccess.open("user://auth.txt",FileAccess.WRITE)
	file.store_string(%TextEdit.text)
