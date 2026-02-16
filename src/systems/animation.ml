open Ecs
open Component_defs

type t = animated

let init _ = ()

let update (ticks, _) =
  Seq.iter
    (fun (e : t) ->
       if ticks > e#last_ticked#get +. e#tick_speed#get
       then (
         e#ticks#set (e#ticks#get + 1);
         e#last_ticked#set ticks;
         e#texture#set (e#textures#get.(e#ticks#get mod (Array.length e#textures#get)))))
;;
