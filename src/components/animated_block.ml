open Ecs
open Component_defs
open System_defs

let create layer position rect txt tick_speed =
  let e = new animated_block () in
  e#textures#set txt;
  e#texture#set txt.(0);
  e#tick_speed#set tick_speed;
  e#position#set position;
  e#box#set rect;
  e#mass#set Float.infinity;
  e#velocity#set Vector.zero;
  e#tag#set Solid;
  e#layer#set layer;
  Camera_system.(register (e :> t));
  Collision_system.(register (e :> t));
  Animation_system.(register (e :> t));
  e
;;

let create_fader () =
  let g = Global.get () in
  let ww, wh = Gfx.get_context_logical_size g.ctx in
  let fader =
    create
      (Cst.layer_count - 1)
      Vector.{ x = float (-ww); y = float (-wh) }
      Rect.{ width = 2 * ww; height = 2 * wh }
      [| Texture.transparent |]
      Cst.fader_tick_speed
  in
  fader#paused#set true;
  Global.update (fun g -> { g with fader = Some fader })
;;
