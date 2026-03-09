open Ecs
open System_defs

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
  Collision_system.reset ();
  Animation_system.reset ();
  Move_system.reset ();
  Physics_system.reset ();
  Camera_system.reset ()
;;

let load f lvl =
  List.iteri
    (fun layer_idx layer ->
       String.iteri
         (fun idx chr ->
            let x = idx mod layer.width * layer.stride.width in
            let y = idx / layer.width * layer.stride.height in
            let position =
              match
                ( Hashtbl.find_opt layer.offsets (Position (x, y))
                , Hashtbl.find_opt layer.offsets (Named chr) )
              with
              | None, None -> Vector.{ x = float x; y = float y }
              | Some v, _ | None, Some v ->
                (* precedence made obvious here *)
                Vector.add v Vector.{ x = float x; y = float y }
            in
            f chr layer_idx position)
         layer.contents)
    lvl.layers;
  let zoom, pos = lvl.camera in
  Global.update (fun g -> { g with camera = { zoom; pos } })
;;

let pause () =
  Collision.pause ();
  Move.pause ();
  Physics.pause ();
  Input.pause ()
;;

let fader_array = Array.init 256 (fun i -> Texture.Color (Gfx.color 0 0 0 i))
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
  pause ();
  fade_in (fun () ->
    f ();
    fade_out pause)
;;
