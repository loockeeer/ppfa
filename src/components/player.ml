open Ecs
open Component_defs
open System_defs

let create x y txt =
  let e = new player () in
  e#texture#set txt;
  e#position#set Vector.{ x = float x; y = float y };
  e#box#set Rect.{ width = Cst.player_width; height = Cst.player_height };
  Global.update (fun g -> { g with player = Some e } );
  Camera_system.(register (e :> t));
  e
;;
