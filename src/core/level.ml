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
  Physics.pause ()
;;

let fade_in () = failwith "wip"
let fade_out () = failwith "wip"
