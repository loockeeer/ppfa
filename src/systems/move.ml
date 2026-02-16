open Ecs
open Component_defs

type t = physics

let init _ = ()

let update (_, dt) =
  Seq.iter (fun x ->
    let v = x#velocity#get in
    x#position#set (Vector.add x#position#get (Vector.mult dt v)))
;;
