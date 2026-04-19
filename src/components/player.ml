open Ecs
open Component_defs
open System_defs

let create layer position txt =
  let e = new player () in
  e#textures#set txt;
  e#texture#set txt.(0);
  e#tick_speed#set 50.;
  e#position#set position;
  e#mass#set Cst.player_mass;
  e#tag#set (Player None);
  e#velocity#set Vector.zero;
  e#forces#set (Vector.mult Cst.player_mass Cst.g);
  e#box#set Rect.{ width = Cst.player_width; height = Cst.player_height };
  e#resolve#set (fun n -> function
    | Solid { disable_top; disable_bot } when n.y > 0. && not disable_top ->
      e#on_ground#set Ground_solid
    | Hat Hdf -> e#on_ground#set Ground_hdf
    | Hat _ -> e#on_ground#set Ground_solid
    | _ -> ());
  e#looking#set None;
  e#layer#set layer;
  Global.update (fun g -> { g with player = Some e });
  Camera_system.(register (e :> t));
  Physics_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Animation_system.(register (e :> t));
  e
;;

let move player dir dt =
  (match dir with
   | Left ->
     player#position#set
       (Vector.add player#position#get Vector.{ x = -.dt *. Cst.player_speed; y = 0. })
   | Right ->
     player#position#set
       (Vector.add player#position#get Vector.{ x = dt *. Cst.player_speed; y = 0. }));
  player#looking#set (Some dir)
;;

let jump player =
  let delta_vy =
    -.(match player#on_ground#get with
       | Not_grounded -> 0.
       | Ground_solid -> Cst.player_jump_speed
       | Ground_hdf -> Cst.hdf_jump_speed)
  in
  let v = player#velocity#get in
  player#velocity#set Vector.{ x = v.x; y = v.y +. delta_vy };
  player#on_ground#set Not_grounded
;;

let grab player hat =
  Hat.unregister hat;
  (Global.get_player ())#tag#set (Component_defs.Player (Some hat))
;;

let throw player hat =
  Hat.register hat;
  (Global.get_player ())#tag#set (Component_defs.Player None);
  hat#position#set (Vector.add Cst.hat_worn_offset player#position#get);
  match hat#tag#get with
  | Hat (Beret y) ->
    hat#velocity#set
      Vector.
        { x =
            (match player#looking#get with
             | None -> 0.
             | Some Left -> -.Cst.beret_velocity
             | Some Right -> Cst.beret_velocity)
        ; y = 0.
        };
    hat#position#set Vector.{ x = hat#position#get.x; y }
  | _ ->
    hat#velocity#set
      Vector.
        { x =
            (match player#looking#get with
             | None -> 0.
             | Some Left -> -.Cst.hat_spawn_velocity_mag
             | Some Right -> Cst.hat_spawn_velocity_mag)
        ; y = player#velocity#get.y
        }
;;
