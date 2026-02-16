type keymap =
  { move_left : string
  ; move_right : string
  ; jump : string
  }

type hat_type =
  | Hdf
  | Fez

let window_width = 600
let window_height = 400
let player_width = 20
let player_height = 20
let player_speed = 0.4
let player_mass = 1.
let player_jump_speed = 1.

(* hdf : haut de forme *)
let hdf_height = 20 (* à ajuster *)
let hdf_width = 20 (* à ajuster *)
let fez_height = 20 (* à ajuster *)
let fez_width = 20 (* à ajuster *)
let block_width = 20
let block_height = 20
let hat_stand_width = 40
let hat_stand_height = 100
let layer_count = 3
let g = Vector.{ x = 0.; y = 0.005 }
