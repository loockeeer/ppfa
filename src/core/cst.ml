type keymap =
  { move_left : string
  ; move_right : string
  ; jump : string
  }

let window_width = 600
let window_height = 400
let player_width = 20
let player_height = 20
let player_speed = 0.4
let player_mass = 1.
let player_jump_speed = 1.
let g = Vector.{ x = 0.; y = 0.005 }
