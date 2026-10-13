@tool

class_name ItemData
extends Resource

enum ItemType {RESOURCE, TOOL, CONSUMABLE}
enum EquipSlot {NONE, HANDS, HEAD, BODY, LEGS, CHARM}

@export var type: ItemType = ItemType.RESOURCE
@export var mesh: Mesh = preload('res://src/mesh/rock.tres')
@export var name: String = "Item"
@export var icon: CompressedTexture2D
@export var id: int = -1
@export var max_stack: int = 10
@export var scale: int = 1
@export var equip_slot: EquipSlot = EquipSlot.NONE
