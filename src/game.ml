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
     x                              \
     xxxxxxxxxxxx                   \
     xxxxxxxxxx                     \
     xxxxxxxx             xxxxxxxx  \
     xxxxxx                         \
     xxxxx                          \
     xxxx                           \
     xxx                            \
     xx              xxxxxxxxxxxxx  \
     x                              \
     x     @                        \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";;

let lvl = Level.{
    layers = [
        Level.{
            contents = layer_content;
            offsets = 
                let tbl = Hashtbl.create 16 in
                Hashtbl.add tbl (Level.Named '@') (Vector.{x = 0.; y = 0.});
                tbl
        }
    ];
    camera = 1., 0, 0;
    width = 31;
    stride = Rect.{width = 20; height = 20};
};;

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
      ; textures = Hashtbl.create 16
      }
  in
  List.iter
    (fun (name, im) -> Hashtbl.add Global.(global.textures) name (Texture.Image im))
    images;
  Global.set global;
  Input.register_map keymap;
  Level.load (fun chr layer position ->
    if chr = 'x' then
        Block.create layer position Rect.{width = 20; height = 20} Texture.black |> ignore
    else if chr = '@' then
        Player.create layer position [|Global.get_texture "extra_character_a"|] |> ignore
    else ()
  ) lvl;
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
