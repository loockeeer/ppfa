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
          match x#tag#get with
          | Player -> Printf.printf "(%f, %f)\n" Vector.(x#position#get.x) Vector.(x#position#get.y)
          | _ -> ();
         let v = x#velocity#get in
         x#position#set (Vector.add x#position#get (Vector.mult dt v)))
      elts
;;
