open Component_defs

(* A module to initialize and retrieve the global state *)
type t =
  { window : Gfx.window
  ; ctx : Gfx.context
  ; last_update: float
  }

val get : unit -> t
val set : t -> unit
