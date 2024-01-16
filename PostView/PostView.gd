extends CanvasLayer

onready var ReplyCont = $PostView/Replies/ScrollContainer/HFlowContainer

func _ready():
	TabNewsAPI.connect("POST_RETRIEVED", self, "_post_retrieved")
	TabNewsAPI.connect("REPLIES_RETRIEVED", self, "_load_replies")

func _show(postDic: Dictionary):
	for c in ReplyCont.get_children(): c.queue_free()
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
		Reply.set_use_bbcode(true)
		Reply.bbcode_text = reply["body"]
		Reply.hint_tooltip = reply["owner_username"]
		Reply.set_fit_content_height(true)
		Reply.set_selection_enabled(true)
		ReplyCont.add_child(Reply)

func _process(delta):
	if ReplyCont.get_child_count() > 0:
		var Posts = ReplyCont.get_children()
		for post in Posts:
			post.rect_min_size.x = $PostView/Replies.rect_size.x
