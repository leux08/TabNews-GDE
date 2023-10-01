extends Node

signal POSTS_RETRIEVED(postsArray)
signal POST_RETRIEVED(postDic)
signal REPLIES_RETRIEVED(repliesArray)

var BaseURL := "https://www.tabnews.com.br/api/v1"
var BaseContents := "https://www.tabnews.com.br/api/v1/contents"

var page := "?page="
var ppage := "&per_page="
var strategy := "&strategy="

func _create_http(type):
	var http = HTTPRequest.new()
	var requestType = str("_request_completed_" + type)
	http.connect("request_completed", self, requestType)
	add_child(http)
	return http
	
func retrieve_posts(pageNum: String = "1", per_page: String = "20", strategyOrder: String = "new"):
	var http = _create_http("posts")
	http.request(BaseContents + page + pageNum + ppage + per_page + strategy + strategyOrder)

func retrieve_post(user, slug):
	var http = _create_http("post")
	http.request(BaseContents + "/" + user + "/" + slug)

func retrieve_replies(user, slug):
	var http = _create_http("replies")
	http.request(BaseContents + "/" + user + "/" + slug + "/children")

func _request_completed_posts(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var Posts = parse_json(body.get_string_from_utf8())
	emit_signal("POSTS_RETRIEVED", Posts)

func _request_completed_post(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var Post = parse_json(body.get_string_from_utf8())
	emit_signal("POST_RETRIEVED", Post)

func _request_completed_replies(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	var replies = parse_json(body.get_string_from_utf8())
	emit_signal("REPLIES_RETRIEVED", replies)
