open Ecs
open Component_defs

type t = physics

let paused = ref false
let pause () = paused := not !paused
let init _ = ()

let update (_, dt) elts =
  if !paused
  then ()
  else
    Seq.iter
      (fun x ->
         let nv = Vector.mult (dt /. x#mass#get) x#forces#get in
         let v = x#velocity#get in
         x#velocity#set (Vector.add nv v))
      elts
;;
