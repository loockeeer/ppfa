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
    | Hat(hat_type) -> e#on_ground#set (Ground hat_type); e#velocity#set ({e#velocity#get with y = 0.}); 
      (match hat_type with 
      |Beret(_, c) -> 
        if n.y <> 0. then  
          e#velocity#set {x = Cst.beret_velocity *. c; y = 0.}
      | _ -> ())
    | _ -> ());
  e#looking#set None;
  e#dir#set None;
  e#layer#set layer;
  Global.update (fun g -> { g with player = Some e });
  Camera_system.(register (e :> t));
  Physics_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Animation_system.(register (e :> t));
  e
;;

let dir_to_float dir = 
  match dir with 
  |Some(Left) -> -1.
  |Some(Right) -> 1.
  |None -> 0.

let smove player dir dt =
 (match player#dir#get with 
 |Some(Left) ->
  (match dir with 
  |Left -> ()
  |Right -> player#dir#set None)
|Some(Right) ->
  (match dir with 
  |Left -> player#dir#set None
  |Right -> ())
 |None -> 
  (match dir with 
  |Left -> player#dir#set (Some Left)
  |Right -> player#dir#set (Some Right)));
  player#velocity#set (Vector.{ x = (dir_to_float player#dir#get) *. Cst.player_speed; y = player#velocity#get.y });
  player#looking#set (Some dir)
;;

let emove player dir dt = 
 (match player#dir#get with 
 |Some(Left) ->
  (match dir with 
  |Left -> player#dir#set None
  |Right -> ())
|Some(Right) ->
  (match dir with 
  |Left -> ()
  |Right -> player#dir#set None)
 |None -> 
  (match dir with 
  |Left -> player#dir#set (Some Right)
  |Right -> player#dir#set (Some Left)));
  player#velocity#set (Vector.{ x = (dir_to_float player#dir#get) *. Cst.player_speed; y = player#velocity#get.y });
;;

let jump player =
  let delta_vy =
    -.(match player#on_ground#get with
       | Not_grounded -> 0.
       | Ground (Hdf) -> Cst.hdf_jump_speed
       | _ -> Cst.player_jump_speed)
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
  hat#is_thrown#set true;
  (Global.get_player ())#tag#set (Component_defs.Player None);
  hat#position#set (Vector.add Cst.hat_worn_offset player#position#get);
  match hat#tag#get with
  | Hat (Beret (y, _)) ->
    (match player#looking#get with
      | None -> 
      hat#velocity#set { x = 0.; y = 0.}
      | Some Right -> 
      hat#velocity#set { x = -.Cst.beret_velocity; y = 0.}; 
      hat#position#set Vector.{ x = hat#position#get.x -. Cst.hat_worn_offset.y; y };
      hat#tag#set (Hat (Beret(y, -1.)))
      | Some Left -> 
      hat#velocity#set { x = Cst.beret_velocity; y = 0.}; 
      hat#position#set Vector.{ x = hat#position#get.x +.  Cst.hat_worn_offset.y; y };);
      hat#tag#set (Hat (Beret(y, 1.)))
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
