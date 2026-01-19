open Ecs
open Component_defs

type t = movable

let init _ = ()

let update ttime el =
  let dt = let g = Global.get () in ttime -. g.last_update in
  Seq.iter
    (fun (e : t) ->
       let v = Vector.mult dt e#velocity#get in
       e#position#set Vector.(add v e#position#get))
    el
;;
