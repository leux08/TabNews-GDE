extends CanvasLayer

onready var ReplyCont = $PostView/Replies/ScrollContainer/HFlowContainer

func _ready():
	TabNewsAPI.connect("POST_RETRIEVED", self, "_post_retrieved")
	TabNewsAPI.connect("REPLIES_RETRIEVED", self, "_load_replies")

func _show(postDic: Dictionary):
	for children in ReplyCont.get_children(): ReplyCont.remove_child(children)
	$PostView/Title.text = ""
	$PostView/Body.bbcode_text = ""
	
	self.show()
	TabNewsAPI.retrieve_post(postDic["owner_username"], postDic["slug"])
	TabNewsAPI.retrieve_replies(postDic["owner_username"], postDic["slug"])

func _on_Button_pressed():
	self.hide()

func _post_retrieved(postDic):
	$PostView/Title.text = postDic["title"]
	$PostView/Body.bbcode_text = postDic["body"]

func _load_replies(replies):
	for reply in replies:
		var Reply = RichTextLabel.new()
		Reply.bbcode_enabled = true
		Reply.bbcode_text = reply["body"]
		Reply.hint_tooltip = reply["owner_username"]
		Reply.rect_min_size.x = 550
		Reply.fit_content_height = true
		ReplyCont.add_child(Reply)
