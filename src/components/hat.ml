open Ecs
open Component_defs
open System_defs

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
  e#mass#set Cst.hat_mass;
  (* à ajuster *)
  e#forces#set
    (match tag with
     | Beret _ -> Vector.zero
     | _ -> Vector.mult Cst.hat_mass Cst.g);
  (* à ajuster *)
  e#tag#set (Hat tag);
  e#layer#set layer;
  e#is_thrown#set false;
  e#box#set
    (match tag with
     | Hdf -> Rect.{ width = Cst.hdf_width; height = Cst.hdf_height }
     | Fez -> Rect.{ width = Cst.fez_width; height = Cst.fez_height }
     | Beret _ -> Rect.{ width = Cst.beret_width; height = Cst.beret_height });
  (match tag with
   | Fez ->
           e#forces#set (Vector.mult (0.5 *. Cst.hat_mass) Cst.g);
     e#resolve#set (fun _ other ->
       match other with
       | Solid _ ->
         if e#is_thrown#get && Vector.norm e#velocity#get >= Cst.fez_explode_velocity
         then (
           Explosion.create
             (Rect.get_center e#box#get e#position#get)
             (Cst.fez_explode_radius |> float);
           unregister e)
       | _ -> ())
   | Beret (y, _) ->
     e#resolve#set (fun _ other ->
       if e#is_thrown#get
       then (
         let c = if e#velocity#get.x > 0. then 1. else -1. in
         e#velocity#set { x = c *. Cst.beret_velocity; y = 0. };
         e#position#set { (e#position#get) with y };
         e#tag#set (Hat (Beret (y, c))))
       else (
         match other with
         | Player _ ->
           e#velocity#set { (e#velocity#get) with y = 0. };
           e#position#set { (e#position#get) with y }
         | _ -> ()))
   | _ -> ());
  register e
;;
