type keymap =
  { move_left : string
  ; move_right : string
  ; jump : string
  ; hat_interact : string
  ; respawn : string
  }

let window_width = 40*32
let window_height = 23*32
let player_width = 19*3/2
let player_height = 19*3/2
let player_speed = 0.3
let player_mass = 1000.
let player_jump_speed = (* tag::player_jump_speed[] *)
0.75
(* end::player_jump_speed[] *)

let background_color = Gfx.color 63 56 81 255

let hat_mass = 100.

let max_hat_pickup_norm = player_width * 2 |> float
let hat_spawn_player_offset = Vector.{ x = 0.; y = -5. }
let hat_spawn_velocity_mag = 0.5

(* hdf : haut de forme *)
let hdf_height = 16 (* à ajuster 16 *)
let hdf_width = 15 (* à ajuster 15 *)
let hdf_jump_speed = (* tag::hdf_jump_speed[] *)
1.2
(* end::hdf_jump_speed[] *)
let fez_height = 12 (* à ajuster 8 *)
let fez_width = 22 (* à ajuster 15 *)

let fez_explode_radius = (* tag::fez_explode_radius[] *)
30
(* end::fez_explode_radius[] *)
let fez_explode_velocity = (* tag::fez_explode_velocity[] *)
0.2

(* end::fez_explode_velocity[] *)
let beret_height = 16 (* à ajuster 8 *)
let beret_width = 30 (* à ajuster 15*)
let beret_velocity = 0.1

(* pc : porte chapeau *)
let pc_height = 40 (* à ajuster 20 *)
let pc_width = 30 (* à ajuster 15*)
let block_width = 34
let block_height = 28
let layer_count = 2
let g = Vector.{ x = 0.; y = 0.005 }
let fader_tick_speed = 0.0000001
let hat_worn_offset = Vector.{ x = 9.; y = -10. }
let min_threshold_collision =  0.08
