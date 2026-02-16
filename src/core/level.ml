open Ecs
open System_defs

type selector =
  | Position of (int * int)
  | Named of char (* position takes precedence over named *)

type layer =
  { contents : string (* the contents for this layer *)
  ; offsets : (selector, Vector.t) Hashtbl.t
    (* a mapping of offsets for the objets to be properly placed *)
  }

type level =
  { layers : layer list (* a list of layers, from back to front *)
  ; camera : float * int * int (* zoom, position *)
  ; width : int (* the view to slice layers[].contents properly as a matrix *)
  ; stride : Rect.t (* how much to advance in each direction *)
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
            let x = idx mod lvl.width * lvl.stride.width in
            let y = idx / lvl.width * lvl.stride.height in
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
    lvl.layers
;;
