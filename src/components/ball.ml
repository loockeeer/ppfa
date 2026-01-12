open Ecs
open Component_defs
open System_defs

let random_v b =
  let a = Random.float (Float.pi /. 2.0) -. (Float.pi /. 4.0) in
  let v = Vector.{ x = cos a; y = sin a } in
  let v = Vector.mult 5.0 (Vector.normalize v) in
  if b then v else Vector.{ v with x = -.v.x }
;;

let ball ctx font =
  let e = new ball () in
  let y_orig = float Cst.ball_v_offset in
  e#texture#set Cst.ball_color;
  e#position#set Vector.{ x = float Cst.ball_left_x; y = y_orig };
  e#box#set Rect.{ width = Cst.ball_size; height = Cst.ball_size };
  e#velocity#set (random_v true);
    
  e#resolve#set (fun n t -> 
  match t#tag#get with
  | Wall.HWall _ 
  | Player.Player ->
          e#velocity#set ({ x = e#velocity#get.x *. n.x; y = e#velocity#get.y *. n.y})
  | Wall.VWall (id, _) ->
          let global = Global.get () in
          global.waiting <- id;
          e#velocity#set Vector.zero;
          if id = 1 then
              e#position#set Vector.{x = float Cst.ball_left_x; y = y_orig }
          else
              e#position#set Vector.{x = float Cst.ball_right_x; y = y_orig }
  | _ -> ());

  Draw_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  e
;;

let restart () =
  let global = Global.get () in
  if global.waiting <> 0
  then (
    let v = random_v (global.waiting = 1) in
    global.waiting <- 0;
    global.ball#velocity#set v)
;;
