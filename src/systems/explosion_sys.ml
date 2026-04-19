open Ecs
open Component_defs

type t = explodable

let init _ = ()

let rec iter_pairs f s =
  match s () with
  | Seq.Nil -> ()
  | Seq.Cons (e, s') ->
    Seq.iter (fun e' -> f e e') s';
    iter_pairs f s'
;;

let center_dist src dest =
  Vector.(
    norm
      (sub
         (Rect.get_center src#box#get src#position#get)
         (Rect.get_center dest#box#get dest#position#get)))
;;

let marked_for_deletion : (explodable, unit) Hashtbl.t = Hashtbl.create 5

let update (_, dt) elts =
  if !Global.frozen
  then ()
  else (
    iter_pairs
      (fun self other ->
         match self#tag#get, other#tag#get with
         | TExplosion _, TExplosion _ -> ()
         | TExplosion force, _ ->
           if center_dist self other <= force
           then (
              Hashtbl.add marked_for_deletion self ();
             Hashtbl.add marked_for_deletion other ())
         | _ -> ())
      elts;
    Hashtbl.iter (fun explosion _ -> Printf.printf "destroy kaboom\n"; explosion#destroy#get ()) marked_for_deletion)
;;
