extends Control

var postInfo: Dictionary
var index: String

func _ready():
	$Title.bbcode_text = index + ". " + "[url=]" +  postInfo["title"] + "[/url]"
	# XX tabcoins · XX comentários · user  · X dias atrás
	$Infos.bbcode_text = str(postInfo["tabcoins"]) + " tabcoins " + "· " + str(postInfo["children_deep_count"]) + " comentários " + "· " + postInfo["owner_username"]

func _on_Title_meta_clicked(meta):
	PostView._show(postInfo)
