extends Resource

class_name ItemData

@export var ItemName : String # name of the item
@export var Icon : Texture2D # icon of the item in the inventory
@export var buyPrice : int # price to purchase this item
@export var sellPrice : int # price to sell the item
@export var ItemModelPrefab : PackedScene # the scene of the item you drop / pickup
