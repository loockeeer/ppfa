open Ecs
open Component_defs

type t = physics

let init _ = ()

let update ttime =
  let dt =
    let g = Global.get () in
    ttime -. g.last_update
  in
  let explode, m_pos =
    let g = Global.get () in
    g.explode, Vector.{ x = float g.mouse_x; y = float g.mouse_y }
  in
  Seq.iter (fun x ->
    let f =
      Vector.add
        (if explode
         then 
             let v = Vector.sub x#position#get m_pos in
             let n = Vector.norm v in
             let v = Vector.mult (1. /. (n *. n)) v in
             Vector.mult (100.) v
         else Vector.zero)
        (x#forces#get)
    in
    let nv = Vector.mult (dt /. x#mass#get) f in
    let v = x#velocity#get in
    x#velocity#set (Vector.add nv v))
;;
