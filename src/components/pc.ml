open Ecs
open Component_defs
open System_defs

type tag += Pc

let create x y layer txt =
  let e = new pc () in
  e#texture#set txt;
  e#position#set Vector.{ x; y };
  e#layer#set layer;
  e#box#set Rect.{ width = Cst.pc_width; height = Cst.pc_height } ;
  Camera_system.register (e :> drawable);
  Global.update (fun gl -> { gl with pc = Some e })

;;
