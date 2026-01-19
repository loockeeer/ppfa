open Ecs
open Component_defs

type t = physics

let init _ = ()

let update ttime =
    let dt = let g = Global.get () in ttime -. g.last_update in
    Seq.iter (fun x ->
    let f = Vector.mult (dt /. x#mass#get) x#forces#get in
    let v = x#velocity#get in
    x#velocity#set (Vector.add f v));;
