open Ecs
open Component_defs
open System_defs

let create x y txt =
  let e = new player () in
  e#texture#set txt;
  e#position#set Vector.{ x = float x; y = float y };
  e#mass#set Cst.player_mass;
  e#tag#set Player;
  e#velocity#set Vector.zero;
  e#forces#set (Vector.mult Cst.player_mass Cst.g);
  e#box#set Rect.{ width = Cst.player_width; height = Cst.player_height };
  Global.update (fun g -> { g with player = Some e });
  Camera_system.(register (e :> t));
  Physics_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e
;;

let move player v = player#position#set (Vector.add player#position#get v)
