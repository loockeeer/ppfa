open Ecs
open Component_defs

type t = physics

let init _ = ()

let update (_, dt) =
  Seq.iter (fun x ->
    let nv = Vector.mult (dt /. x#mass#get) x#forces#get in
    let v = x#velocity#get in
    x#velocity#set (Vector.add nv v))
;;
