open Ecs
open System_defs
open Component_defs

type selector =
  | Position of (int * int)
  | Named of char (* position takes precedence over named *)

type layer =
  { contents : string (* the contents for this layer *)
  ; offsets :
      ( selector
        , Vector.t )
        Hashtbl.t (* a mapping of offsets for the objets to be properly placed *)
  ; width : int (* the view to slice layers[].contents properly as a matrix *)
  ; stride : Rect.t (* how much to advance in each direction *)
  }

type level =
  { layers : layer list (* a list of layers, from back to front *)
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
    if idx >= String.length layer.contents then None else Some layer.contents.[idx]
  | None -> None
;;

let f chr layer position =
  if chr = 'x' then 
    Block.create layer position Rect.{ width = 20; height = 20 } Texture.black |> ignore
  else if chr = '@' then  
    Player.create layer position [| Global.get_texture "extra_character_a" |] |> ignore
  else if chr = 'f' then 
    Hat.create position.x position.y layer (Global.get_texture "fez") Fez
  else if chr = 'h' then 
    Hat.create position.x position.y layer (Global.get_texture "hdf") Hdf
  else if chr = 'b' then 
    Hat.create position.x position.y layer (Global.get_texture "beret") (Beret position.y)
  else if chr = 'p' then 
    Pc.create position.x position.y layer (Global.get_texture "pc")
  else ()
;;

let get_offset x y layer chr = 
  match
  ( Hashtbl.find_opt layer.offsets (Position (x, y))
  , Hashtbl.find_opt layer.offsets (Named chr) )
with
| None, None -> Vector.{ x = 0.; y = 0. }
| Some v, _ | None, Some v ->
  (* precedence made obvious here *) v

let load f lvl =
  List.iteri
    (fun layer_idx layer ->
       String.iteri
         (fun idx chr ->
            let x = idx mod layer.width * layer.stride.width in
            let y = idx / layer.width * layer.stride.height in
            let position = Vector.add Vector.{ x = float x; y = float y } (get_offset x y layer chr) in 
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
