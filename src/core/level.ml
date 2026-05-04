open Ecs
open System_defs
open Component_defs

type 'a selector =
  | Position of (int * int)
  | Named of 'a (* position takes precedence over named *)

type 'a layer =
  { contents : 'a array (* the contents for this layer *)
  ; offsets :
      ( 'a selector
        , Vector.t )
        Hashtbl.t (* a mapping of offsets for the objets to be properly placed *)
  ; width : int (* the view to slice layers[].contents properly as a matrix *)
  ; stride : Rect.t (* how much to advance in each direction *)
  }

type 'a level =
  { layers : 'a layer list (* a list of layers, from back to front *)
  ; camera : float * Vector.t (* zoom, position *)
  }

let clear () =
  Global.update (fun g -> { g with wild_hats = []; player = None });
  Collision_system.reset ();
  Animation_system.reset ();
  Move_system.reset ();
  Physics_system.reset ();
  Camera_system.reset ();
  Explosion_system.reset ()
;;

let probe lvl layer x y =
  match List.nth_opt lvl.layers layer with
  | Some layer ->
    let idx = x + (layer.width * y) in
    if idx >= Array.length layer.contents then None else Some layer.contents.(idx)
  | None -> None
;;

let tileset_columns = 19

let get_tile_rect gid =
  if gid = 0
  then None
  else (
    let id = gid - 1 in
    let tx = id mod tileset_columns * 32 in
    let ty = id / tileset_columns * 32 in
    Some (tx, ty, Rect.{ width = 32; height = 32 }))
;;

let f chr layer position =
  Level_import.(
    match chr with
    | Some (Custom chr) ->
      if chr = '@'
      then (
        let _ =
          Player.create layer position [| Global.get_texture "extra_character_a" |]
        in
        ())
      else if chr = '/'
      then Hat.create position.x position.y layer (Global.get_texture "fez") Fez
      else if chr = ')'
      then Hat.create position.x position.y layer (Global.get_texture "hdf") Hdf
      else if chr = '('
      then
        Hat.create
          position.x
          position.y
          layer
          (Global.get_texture "beret")
          (Beret (position.y, 0.))
      else if chr = '['
      then Pc.create position.x position.y layer (Global.get_texture "pc")
    | Some (Terrain x) ->
      if x = 0 || x = 1 then ()
      else
      (match get_tile_rect x with
       | Some (src_x, src_y, src_rect) ->
         let texture =
           match Global.get_texture "world_tileset" with
           | Color c -> Texture.Color c
           | Image surf ->
             let glob = Global.get () in
             let new_surf = Gfx.create_surface glob.ctx src_rect.width src_rect.height in
             Gfx.blit_full
               glob.ctx
               new_surf
               surf
               src_x
               src_y
               src_rect.width
               src_rect.height
               0
               0
               src_rect.width
               src_rect.height;
             Image new_surf
         in
         let b = Block.create layer position Rect.{ width = 32; height = 32 } texture in
         if layer <> Cst.layer_count - 1
         then (
           Explosion_system.unregister (b :> explodable);
           Collision_system.unregister (b :> collidable))
       | None -> ())
    | None -> ())
;;

let get_offset x y layer chr =
  match
    ( Hashtbl.find_opt layer.offsets (Position (x, y))
    , Hashtbl.find_opt layer.offsets (Named chr) )
  with
  | None, None -> Vector.{ x = 0.; y = 0. }
  | Some v, _ | None, Some v -> (* precedence made obvious here *) v
;;

let load f lvl =
  List.iteri
    (fun layer_idx layer ->
       Array.iteri
         (fun idx chr ->
            let x = idx mod layer.width * layer.stride.width in
            let y = idx / layer.width * layer.stride.height in
            let position =
              Vector.add Vector.{ x = float x; y = float y } (get_offset x y layer chr)
            in
            f chr layer_idx position)
         layer.contents)
    lvl.layers;
  let zoom, pos = lvl.camera in
  Global.update (fun g -> { g with camera = { zoom; pos } })
;;

let fader_array = Array.init 255 (fun i -> Texture.Color (Gfx.color 0 0 0 i))
let unfader_array = Array.of_list (List.rev (Array.to_list fader_array))

let fade arr cb =
  let g = Global.get () in
  let fader = Option.get g.fader in
  fader#textures#set arr;
  fader#texture#set arr.(0);
  fader#paused#set false;
  fader#animation_callback#set (fun () ->
    fader#paused#set true;
    fader#texture#set arr.(Array.length arr - 1);
    cb ())
;;

let fade_in = fade fader_array
let fade_out = fade unfader_array

let fade_in_out f =
  Global.freeze ();
  fade_in (fun () ->
    f ();
    fade_out Global.freeze)
;;
