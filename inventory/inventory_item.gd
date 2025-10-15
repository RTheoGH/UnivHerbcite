extends Resource

class_name InventoryItem

@export var name : String = ""
@export var quantity : int = 1
@export var texture : Texture2D # or texture
@export var tags : Array[String] #if tags are specific things create a class and replace String with Tags class
@export var description : String = "" # Optional
