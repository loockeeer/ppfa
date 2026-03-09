open Ecs
open Component_defs
open System_defs

(* [create] creates a [fader], registers it to the [Animation_system] and
 * [Camera_system] systems, and puts it in the [Global] state for further use.
 * A [fader] is similar to an [animated_block], only without physics nor
 * collisions.
 *)
let create () =
  let g = Global.get () in
  let ww, wh = Gfx.get_context_logical_size g.ctx in
  let fader = new fader () in
  (* Initially, the fader is transparent and not ticking *)
  fader#textures#set [| Texture.transparent |];
  fader#texture#set Texture.transparent;
  fader#paused#set true;
  (* Make the fader span a large area to avoid aliasing issues *)
  fader#position#set Vector.{ x = float (-ww); y = float (-wh) };
  fader#box#set Rect.{ width = 2 * ww; height = 2 * wh };
  fader#tick_speed#set Cst.fader_tick_speed;
  (* Draw the fader on top of everything *)
  fader#layer#set (Cst.layer_count - 1);
  Animation_system.register (fader :> animated);
  Camera_system.register (fader :> drawable);
  Global.update (fun g -> { g with fader = Some fader })
;;
