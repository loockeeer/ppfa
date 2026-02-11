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
  Collision_system.update dt;
  Move_system.update dt;
  Physics_system.update dt;
  Camera_system.update dt;
  None
;;

let ( let@ ) f k = f k

let run_custom keymap =
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
  Block.create (0, 550, 800, 50, Texture.black) |> ignore;
  Player.create 400 300 Texture.red |> ignore;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in
  ()
;;


let run keys =
  let win = Gfx.create "game_canvas:800x600:" in
  let ts = Gfx.load_file "resources/files/tile_set.txt" in
  Gfx.main_loop
    (fun _ -> Gfx.get_resource_opt ts)
    (fun txt1 ->
       let res_list =
         String.split_on_char '\n' txt1
         |> List.filter_map (fun p ->
           if p = ""
           then None
           else Some (Gfx.load_image (Gfx.get_context win) ("resources/images/" ^ p)))
       in
       Gfx.main_loop
         (fun _ ->
            let result = List.map Gfx.get_resource_opt res_list in
            if List.for_all (( <> ) None) result
            then Some (List.map Option.get result)
            else None)
         (run_custom win keys))
;;