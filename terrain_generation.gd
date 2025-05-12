class_name TerrainGeneration
extends Node

var mesh : MeshInstance3D
var size_depth : int = 200
var size_width : int = 200
var mesh_resolution : int = 2

var rng := RandomNumberGenerator.new()

@export var noise : FastNoiseLite

@onready var grass := preload("res://assets/materials/base.tres")

func _ready():
	rng.randomize()
	noise.seed = randi_range(0, 1000)
	generate()

func generate():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size_width, size_depth)
	plane_mesh.subdivide_depth = size_depth * mesh_resolution
	plane_mesh.subdivide_width = size_width * mesh_resolution
	
	var surface = SurfaceTool.new()
	var data = MeshDataTool.new()
	surface.create_from(plane_mesh, 0)
	
	var array_plane = surface.commit()
	data.create_from_surface(array_plane, 0)
	
	for i in range(data.get_vertex_count()):
		var vertex = data.get_vertex(i)
		
		var y = get_noise_y(vertex.x, vertex.z)
		vertex.y = y
		
		data.set_vertex(i, vertex)
	
	array_plane.clear_surfaces()
	
	data.commit_to_surface(array_plane)
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.create_from(array_plane, 0)
	surface.generate_normals()
	
	mesh = MeshInstance3D.new()
	mesh.mesh = surface.commit()
	mesh.set_surface_override_material(0, grass)
	mesh.create_trimesh_collision()
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mesh)
	
	var static_body = null
	for child in mesh.get_children():
		if child is StaticBody3D:
			static_body = child
			break
	if static_body:
		static_body.collision_layer = 0b00000011   
		static_body.collision_mask = 0b00000011

func get_noise_y(x, z) -> float:
	var value = noise.get_noise_2d(x, z)
	return value * 3.0
