open System_defs
open Component_defs
open Ecs

let init (_, dt) =
  Ecs.System.init_all dt;
  Some ()
;;

(* On crée une fenêtre *)

let update dt =
  let () = Input.handle_input dt in
  Collision_system.update dt;
  Move_system.update dt;
  Physics_system.update dt;
  Camera_system.update dt;
  Animation_system.update dt;
  None
;;

let ( let@ ) f k = f k

let run_custom window keymap images =
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
      ; textures = Array.of_list (List.map (fun x -> Texture.Image x) images)
      }
  in
  Global.set global;
  Input.register_map keymap;
  Block.create (0, 550, 800, 50, Texture.black ) |> ignore;
  Player.create 400 300 [| global.textures.(0); Texture.black |] |> ignore;
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
