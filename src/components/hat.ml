open Ecs
open Component_defs
open System_defs

type tag += Hat of hat_type

let register h =
  Camera_system.register (h :> drawable);
  Physics_system.register (h :> physics);
  Move_system.register (h :> physics);
  Collision_system.register (h :> collidable);
  Global.update (fun gl -> { gl with wild_hats = h :: gl.wild_hats })
;;

let unregister h =
  Camera_system.unregister (h :> drawable);
  Physics_system.unregister (h :> physics);
  Move_system.unregister (h :> physics);
  Collision_system.unregister (h :> collidable);
  Global.update (fun gl -> { gl with wild_hats = List.filter (( <> ) h) gl.wild_hats })
;;

let create x y layer txt tag =
  let e = new hat () in
  e#texture#set txt;
  e#position#set Vector.{ x; y };
  e#velocity#set Vector.zero;
  (* à ajuster *)
  e#mass#set Cst.player_mass;
  (* à ajuster *)
  e#forces#set (Vector.mult Cst.player_mass Cst.g);
  (* à ajuster *)
  e#tag#set (Hat tag);
  e#layer#set layer;
  e#box#set
    (match[@warning "-11"] tag with
     | Hdf -> Rect.{ width = Cst.hdf_width; height = Cst.hdf_height }
     | Fez -> Rect.{ width = Cst.fez_width; height = Cst.fez_height }
     | _ -> failwith "not a valid hat flag");
  register e;
  e
;;
