open Ecs
module Camera_system = System.Make (Camera)
module Collision_system = System.Make (Collision)
module Physics_system = System.Make (Physics)
module Move_system = System.Make(Move)
