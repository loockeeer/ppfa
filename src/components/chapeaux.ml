open Ecs
open Component_defs
open System_defs

let create x y txt tag =
  let e = new chapeau () in
  e#texture#set txt;
  e#position#set Vector.{ x = float x; y = float y };
  e#velocity#set Vector.zero;
  (* à ajuster *)
  e#mass#set Cst.player_mass;
  (* à ajuster *)
  e#forces#set (Vector.mult Cst.player_mass Cst.g);
  (* à ajuster *)
  e#tag#set tag;
  e#box#set
    (match tag with
     | Hat Hdf -> Rect.{ width = Cst.hdf_width; height = Cst.hdf_height }
     | Hat Fez -> Rect.{ width = Cst.fez_width; height = Cst.fez_height }
     | _ -> failwith "not a valid hat flag");
  Collision_system.(register (e :> t))
;;
