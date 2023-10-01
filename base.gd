extends Control

var page := "1"
var posts_per_page := "30"
var strategy := "new"

onready var PostsContainer := $Posts/PostsContainer

func _ready():
	TabNewsAPI.connect("POSTS_RETRIEVED", self, "_load_posts")
	TabNewsAPI.retrieve_posts(page, posts_per_page, strategy)
	
func _load_posts(postsArray):
	for children in PostsContainer.get_children(): PostsContainer.remove_child(children)
	
	var index := 0
	for posts in postsArray:
		index += 1
		var AppCard = load("res://UIParts/PostCard/PostCard.tscn").instance()
		AppCard.index = str(index)
		AppCard.postInfo = posts
		PostsContainer.add_child(AppCard)


func _on_OptionButton_item_selected(index):
	match index:
		0:
			strategy = "new"
		1:
			strategy = "relevant"
	TabNewsAPI.retrieve_posts(page, posts_per_page, strategy)
