open Ecs
open Component_defs

type t = movable

let init _ = ()

let update _ =
  Seq.iter (fun mov -> mov#position#set (Vector.add mov#position#get mov#velocity#get))
;;
