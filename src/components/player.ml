open Ecs
open Component_defs
open System_defs

let create x y txt =
  let e = new player () in
  e#textures#set txt;
  e#texture#set txt.(0);
  e#tick_speed#set 50.;
  e#position#set Vector.{ x = float x; y = float y };
  e#mass#set Cst.player_mass;
  e#tag#set Player;
  e#velocity#set Vector.zero;
  e#forces#set (Vector.mult Cst.player_mass Cst.g);
  e#box#set Rect.{ width = Cst.player_width; height = Cst.player_height };
  e#resolve#set (fun n -> function
    | Solid -> if n.y > 0. then e#on_ground#set true
    | _ -> ());
  Global.update (fun g -> { g with player = Some e });
  Camera_system.(register (e :> t));
  Physics_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Animation_system.(register (e :> t));
  e
;;

let move player v = player#position#set (Vector.add player#position#get v)

let jump player =
  if player#on_ground#get
  then (
    let v = player#velocity#get in
    player#velocity#set Vector.{ x = v.x; y = v.y -. Cst.player_jump_speed };
    player#on_ground#set false)
;;
