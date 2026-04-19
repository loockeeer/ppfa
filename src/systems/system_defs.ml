open Ecs
module Camera_system = System.Make (Camera)
module Collision_system = System.Make (Collision)
module Physics_system = System.Make (Physics)
module Move_system = System.Make (Move)
module Animation_system = System.Make (Animation)
module Explosion_system = System.Make (Explosion_sys)
