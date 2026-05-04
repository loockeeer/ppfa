open System_defs
open Component_defs
open Ecs

let init (_, dt) =
  Ecs.System.init_all dt;
  Some ()
;;

(* On crée une fenêtre *)

let last_ticks = ref 0.

let update (ticks, dt) =
  if !last_ticks +. 2000. < ticks
  then (
    Printf.printf "Current dt = %f\n" dt;
    last_ticks := ticks);
  for i = 0 to int_of_float (ceil (dt /. 5.)) do
    let dt = ticks, dt /. ceil (dt /. 5.) in
    let () = Input.handle_input dt in
    Physics_system.update dt;
    Move_system.update dt;
    Collision_system.update dt;
    Explosion_system.update dt;
  done;
  Camera_system.update (ticks, dt);
  Animation_system.update (ticks, dt);
  None
;;

let ( let@ ) f = f

let run_custom window keymap images =
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx Cst.window_width Cst.window_height in
  let global =
    Global.
      { window
      ; ctx
      ; mouse_x = 0
      ; mouse_y = 0
      ; camera = { zoom = 1.; pos = Vector.{ x = 0.; y = 0. } }
      ; player = None
      ; textures = Hashtbl.create 16
      ; fader = None
      ; pc = None
      ; wild_hats = []
      ; level = 0
      ; animations = Hashtbl.create 16
      }
  in
  List.iter
    (fun (name, im) -> Hashtbl.add Global.(global.textures) name (Texture.Image im))
    images;
  Global.set global;
  Input.register_map keymap;
  Fader.create ();
  Global.freeze ();
  (* Generate animations *)
  let txt_slice = Texture.slice ctx in
  let txt_sym = Texture.sym ctx in
  (* Idling *)
  let idling_frames =
    let sprite = Global.get_texture "player/idling" in
    txt_slice 19 19 sprite
  in
  Hashtbl.add Global.(global.animations) "player_idling_left" idling_frames;
  Hashtbl.add
    Global.(global.animations)
    "player_idling_right"
    (Array.map txt_sym idling_frames);
  (* Running *)
  let running_frames =
    let sprite = Global.get_texture "player/running" in
    txt_slice 19 19 sprite
  in
  Hashtbl.add Global.(global.animations) "player_running_left" running_frames;
  Hashtbl.add
    Global.(global.animations)
    "player_running_right"
    (Array.map txt_sym running_frames);
  (* Jumping *)
  let jumping_frames =
    let sprite = Global.get_texture "player/jumping" in
    txt_slice 19 19 sprite
  in
  Hashtbl.add Global.(global.animations) "player_jumping_left" jumping_frames;
  Hashtbl.add
    Global.(global.animations)
    "player_jumping_right"
    (Array.map txt_sym jumping_frames);
  (* Falling *)
  let falling_frames =
    let sprite = Global.get_texture "player/falling" in
    txt_slice 19 19 sprite
  in
  Hashtbl.add Global.(global.animations) "player_falling_left" jumping_frames;
  Hashtbl.add
    Global.(global.animations)
    "player_falling_right"
    (Array.map txt_sym falling_frames);
  Level.load Level.f Levels_content.levels.(global.level);
  Level.fade_out Global.freeze;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in
  ()
;;

let run keys =
  let win =
    Gfx.create
      (Printf.sprintf "game_canvtexturesas:%dx%d:" Cst.window_width Cst.window_height)
  in
  let ts = Gfx.load_file "resources/files/tile_set.txt" in
  Gfx.main_loop
    (fun _ -> Gfx.get_resource_opt ts)
    (fun txt1 ->
       let res_list =
         String.split_on_char '\n' txt1
         |> List.filter_map (fun p ->
           if p = ""
           then None
           else (
             let[@warning "-8"] (name :: _) = String.split_on_char '.' p in
             Some (name, Gfx.load_image (Gfx.get_context win) ("resources/images/" ^ p))))
       in
       Gfx.main_loop
         (fun _ ->
            let result =
              List.map (fun (name, x) -> name, Gfx.get_resource_opt x) res_list
            in
            if List.for_all (fun (_, x) -> x <> None) result
            then Some (List.map (fun (name, x) -> name, Option.get x) result)
            else None)
         (run_custom win keys))
;;
