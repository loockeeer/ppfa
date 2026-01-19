open Component_defs

(* A module to initialize and retrieve the global state *)
type t =
  { window : Gfx.window
  ; ctx : Gfx.context
  ; last_update : float
  ; mouse_x : int
  ; mouse_y : int
  ; explode : bool
  }

val get : unit -> t
val set : t -> unit
