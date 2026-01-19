open Ecs
open Component_defs
open System_defs

let create (x, y, v, txt, width, height, mass, tag) =
  let e = new block () in
  e#texture#set txt;
  e#position#set Vector.{ x = float x; y = float y };
  e#velocity#set v;
  e#box#set Rect.{ width; height };
  e#mass#set mass;
  e#tag#set tag;
  if Float.is_finite mass then e#forces#set (Vector.mult mass Cst.g);
  Collision_system.(register (e :> t));
  Move_system.(register (e :> t));
  Draw_system.(register (e :> t));
  Physics_system.(register (e :> t));
  e
;;

let create_random () =
  let x = Cst.window_width / 2 in
  let y = Cst.window_height / 2 in
  let vx = Random.float 1. in
  let vy = Random.float 1. in
  let txt = Texture.black in
  let width = 20 in
  let height = 20 in
  let mass = 1.0 +. Random.float 99.0 in
  create (x, y, Vector.{ x = vx; y = vy }, txt, width, height, mass, Ball)
;;

let walls () =
  List.map
    create
    Cst.
      [ hwall1_x, hwall1_y, Vector.zero, Texture.blue, hwall_width, hwall_height, infinity,Wall
      ; hwall2_x, hwall2_y, Vector.zero, Texture.blue, hwall_width, hwall_height, infinity,Wall
      ; ( vwall1_x
        , vwall1_y
        , Vector.zero
        , Texture.green
        , vwall_width
        , vwall_height
        , infinity, Wall )
      ; ( vwall2_x
        , vwall2_y
        , Vector.zero
        , Texture.green
        , vwall_width
        , vwall_height
        , infinity,Wall )
      ; (block_x,
      block_y,
      Vector.zero,
      Texture.red,
      block_width,
      block_height,
      500.,Ball)
      ]
;;
