open Ecs
open Component_defs

type t = collidable

let init _ = ()

let rec iter_pairs f s =
  match s () with
  | Seq.Nil -> ()
  | Seq.Cons (e, s') ->
    Seq.iter (fun e' -> f e e') s';
    iter_pairs f s'
;;

let update _ =
  iter_pairs (fun (e1 : t) (e2 : t) ->
    let m1, m2 = e1#mass#get, e2#mass#get in
    if Float.is_finite m1 || Float.is_finite m2
    then (
      let s_pos, s_rect =
        Rect.mdiff e1#position#get e1#box#get e2#position#get e2#box#get
      in
      if Rect.has_origin s_pos s_rect
      then (
        let n = Rect.penetration_vector s_pos s_rect in
        let r = Vector.norm e1#velocity#get +. Vector.norm e2#velocity#get in
        let n1, n2 =
          if Float.is_infinite m1
          then 0.0, 1.0
          else if Float.is_infinite m2
          then 1.0, 0.0
          else if e1#velocity#get = Vector.zero && e2#velocity#get = Vector.zero then
              0.5, 0.5
          else Vector.norm e1#velocity#get /. r, Vector.norm e2#velocity#get /. r
        in
        e1#position#set (Vector.add e1#position#get (Vector.mult n1 n));
        e2#position#set (Vector.sub e2#position#get (Vector.mult n2 n));
        let n = Vector.normalize n in
        let v = Vector.sub e1#velocity#get e2#velocity#get in
        let e = match e1#tag#get, e2#tag#get with
        | Wall, _ | _, Wall -> 0.9
        | _ -> 1.
        in
        let j = -.(1. +. e) /. ((1. /. m1) +. (1. /. m2)) *. Vector.dot v n in
        e1#velocity#set (Vector.add e1#velocity#get (Vector.mult (j /. m1) n));
        e2#velocity#set (Vector.sub e2#velocity#get (Vector.mult (j /. m2) n)))))

;;
