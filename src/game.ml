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
  for i = 0 to int_of_float (ceil dt) do
    let dt = ticks, dt /. ceil dt in
    let () = Input.handle_input dt in
    Physics_system.update dt;
    Move_system.update dt;
    Collision_system.update dt
  done;
  Camera_system.update (ticks, dt);
  Animation_system.update (ticks, dt);
  None
;;

let ( let@ ) f = f

let layer_content =
    "                               \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                 x            \
     xxxxxxxxxxxx                   \
     xxxxxxxxxx                     \
     xxxxxxxx             xxxxxxxx  \
     xxxxxx                         \
     xxxxx  @         x             \
     xxxx                           \
     xxx                   f        \
     xx              xxxxxxxxxxxxx  \
     x                              \
     x                              \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"[@@ocamlformat "disable"]

let lvl =
  Level.
    { layers =
        [ Level.
            { contents = layer_content
            ; offsets =
                (let tbl = Hashtbl.create 16 in
                 Hashtbl.add tbl (Level.Named '@') Vector.{ x = 0.; y = 0. };
                 tbl)
            ; width = 31
            ; stride = Rect.{ width = 20; height = 20 }
            }
        ]
    ; camera = (1., Vector.{ x = 0.; y = 0. })
    }
;;

let run_custom window keymap images =
  let ctx = Gfx.get_context window in
  let () = Gfx.set_context_logical_size ctx 800 600 in
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
      ; wild_hats = []
      }
  in
  List.iter
    (fun (name, im) -> Hashtbl.add Global.(global.textures) name (Texture.Image im))
    images;
  Global.set global;
  Input.register_map keymap;
  Fader.create ();
  Level.pause ();
  Level.load
    (fun chr layer position (str_x, str_y) ->
       if chr = 'x'
       then (
         let disable_top = Level.probe lvl layer str_x (str_y - 1) = Some 'x' in
         let disable_bot = Level.probe lvl layer str_x (str_y + 1) = Some 'x' in
         Printf.printf "(%d, %d) : (%b, %b)\n" str_x str_y false false;
         let b =
           Block.create
             layer
             position
             Rect.{ width = 20; height = 20 }
             (if disable_top && disable_bot
              then Texture.red
              else if disable_bot
              then Texture.blue
              else Texture.green)
         in
         b#tag#set (Solid { disable_top = false; disable_bot = false }))
       else if chr = '@'
       then (
         let p =
           Player.create layer position [| Global.get_texture "extra_character_a" |]
         in
         p#tag#set (Player None))
       else if chr = 'f'
       then ignore (Hat.create position.x position.y layer (Global.get_texture "fez") Fez)
       else ())
    lvl;
  Level.fade_out Level.pause;
  let@ () = Gfx.main_loop ~limit:false init in
  let@ () = Gfx.main_loop update in
  ()
;;

let run keys =
  let win = Gfx.create "game_canvtexturesas:800x600:" in
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
