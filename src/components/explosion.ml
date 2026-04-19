open Component_defs
open System_defs
open Ecs

let create position force =
  let e = new explosion in
  e#position#set position;
  e#box#set Rect.{ width = 0; height = 0 };
  e#destroy#set (fun () -> Entity.delete e);
  e#tag#set (TExplosion force);
  Explosion_system.register (e :> explodable)
;;
