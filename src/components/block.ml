open Ecs
open Component_defs
open System_defs

let create layer position rect txt =
  let e = new block () in
  e#texture#set txt;
  e#position#set position;
  e#box#set rect;
  e#mass#set Float.infinity;
  e#velocity#set Vector.zero;
  e#tag#set Solid;
  e#layer#set layer;
  Camera_system.(register (e :> t));
  Collision_system.(register (e :> t));
  e
;;
