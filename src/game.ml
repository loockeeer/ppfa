open System_defs
open Component_defs
open Ecs

let init (_, dt) =
  Ecs.System.init_all dt;
  Some ()
;;

(* On crée une fenêtre *)

let update (ticks, dt) =
  let () = Input.handle_input (ticks, dt) in
  Camera_system.update dt;
  None
;;

let ( let@ ) f k = f k

let run keymap =
  let window_spec =
    Format.sprintf "game_canvas:%dx%d:" Cst.window_width Cst.window_height
  in
  let window = Gfx.create window_spec in
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
  let global =
    Global.
      { window
      ; ctx
      ; mouse_x = 0
      ; mouse_y = 0
      ; camera_x = 0
      ; camera_y = 0
      ; camera_zoom = 1.
      ; player = None
  }
  in
  Global.set global;
  Input.register_map keymap;
  Player.create 400 300 (Texture.red) |> ignore;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in
  ()
;;
