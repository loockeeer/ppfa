open System_defs
open Component_defs
open Ecs

let init dt =
  Ecs.System.init_all dt;
  let g = Global.get () in
  Global.set { g with last_update = dt };
  Some ()
;;

let update dt =
  let () = Input.handle_input () in
  Collision_system.update dt;
  Move_system.update dt;
  Draw_system.update dt;
  Physics_system.update dt;
  let g = Global.get () in
  Global.set { g with last_update = dt };
  None
;;

let ( let@ ) f k = f k

let run () =
  let window_spec =
    Format.sprintf "game_canvas:%dx%d:" Cst.window_width Cst.window_height
  in
  let window = Gfx.create window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
  let _walls = Block.walls () in
  let global =
    Global.{ window; ctx; last_update = 0.0; mouse_x = 0; mouse_y = 0; explode = false }
  in
  Global.set global;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in
  ()
;;
