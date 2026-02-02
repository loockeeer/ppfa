(* Main spécifique à SDL *)
let () =
  Game.run
    Game.
      { move_up = "z"
      ; move_down = "s"
      ; move_left = "q"
      ; move_right = "d"
      ; attack = "a"
      ; pause = "p"
      ; start = "s"
      ; interact = "e"
      }
;;
