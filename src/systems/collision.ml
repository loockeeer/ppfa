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

let update _ el = el |> iter_pairs (fun (e1 : t) (e2 : t) -> () (* à compléter *))
