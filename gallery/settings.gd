extends Node

var config = ConfigFile.new()
const setting_path = "user://settings.ini"

var auto_play : bool = true
var art_show : String = ""

func _ready():
	if !FileAccess.file_exists(setting_path):
		config.set_value("Settings", "Auto_Play", auto_play)
		config.set_value("Settings", "Art_Folder", art_show)
		
		config.save(setting_path)
	else:
		config.load(setting_path)
		auto_play = config.get_value("Settings", "Auto_Play")
		art_show = config.get_value("Settings","Art_Folder")


func save_settings(key: String, value):
	config.set_value("Settings", key, value)
	config.save(setting_path)
