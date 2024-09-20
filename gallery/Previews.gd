extends BoxContainer

var art_gallery: Array = []
var art_gallery_full = []

var image1 = Image.new()
var image1_texture = ImageTexture.new()

var image2 = Image.new()
var image2_texture = ImageTexture.new()

var image3 = Image.new()
var image3_texture = ImageTexture.new()

var voted : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().set_transparent_background(true)
	
	if !Settings.art_show == "":
		_art_int()
		pick_random_highlight()
	else:
		Settings.auto_play = false
		%PlayPauseButton.set_pressed(true)

	$%ProgressBar.max_value = $%ArtTimer.wait_time
	
func _art_int():
		var dir := DirAccess.open(Settings.art_show)
		var file_names := dir.get_files()

		for file_name in file_names:
			if file_name.contains(".png") || file_name.contains(".jpg"): #only adds images to the array
				art_gallery.append(str(Settings.art_show,"/",file_name))
			
		randomize()
		art_gallery_full = art_gallery.duplicate()
		art_gallery.shuffle()
			
		display_art()

# Shuffle images in Showcase folder and prevent duplicates
func get_art():
	if art_gallery.is_empty():
		art_gallery = art_gallery_full.duplicate()
		art_gallery.shuffle()

		
	var random_art = art_gallery.pop_front()
	return random_art

# Replace placeholders with art
func display_art():
	var art1 = get_art()
	image1.load(art1)
	image1_texture.set_image(image1)
	$%TextureRect.set_texture(image1_texture)
	
	var art2 = get_art()
	image2.load(art2)
	image2_texture.set_image(image2)
	$%TextureRect2.set_texture(image2_texture)
	
	var art3 = get_art()
	image3.load(art3)
	image3_texture.set_image(image3)
	$%TextureRect3.set_texture(image3_texture)
	
func pick_random_highlight():
	var randomHighlight = [image1_texture, image2_texture, image3_texture]
	randomize()
	randomHighlight.shuffle()
	$%BigViewer.set_texture(randomHighlight.pick_random())
	print("Highlight picked from random? ", !randomHighlight)
	
func highlight_art():
	var totalArt1 = $%Vote1.get_child_count()
	var totalArt2 = $%Vote2.get_child_count()
	var totalArt3 = $%Vote3.get_child_count()
	
	if totalArt1 > totalArt2 && totalArt1 > totalArt3:
		$%BigViewer.set_texture(image1_texture)
	elif totalArt2 > totalArt1 && totalArt2 > totalArt3:
		$%BigViewer.set_texture(image2_texture)
	elif totalArt3 > totalArt1 && totalArt3 > totalArt2:
		$%BigViewer.set_texture(image3_texture)
	elif $%BigViewer.get_texture() == load("res://icon.svg"):
		pick_random_highlight()

func _on_gallyer_controls_auto_art_1():
	$%BigViewer.set_texture(image1_texture)


func _on_gallyer_controls_auto_art_2():
	$%BigViewer.set_texture(image2_texture)


func _on_gallyer_controls_auto_art_3():
	$%BigViewer.set_texture(image3_texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Settings.auto_play :
		highlight_art()
	$%ProgressBar.value = $%ArtTimer.time_left
	
func _on_art_timer_timeout():
	display_art()

func _on_file_dialog_dir_selected(dir):
	Settings.art_show = dir
	Settings.save_settings("Art_Folder", Settings.art_show)
	art_gallery.clear()
	art_gallery_full.clear()
	%PlayPauseButton.set_pressed(false)
	_art_int()
	pick_random_highlight()
	
