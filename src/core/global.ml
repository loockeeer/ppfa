open Component_defs

type camera_t =
  { zoom : float
  ; pos : Vector.t
  }

type t =
  { window : Gfx.window
  ; ctx : Gfx.context
  ; mouse_x : int
  ; mouse_y : int
  ; camera : camera_t
  ; player : Component_defs.player option
  ; textures : (string, Texture.t) Hashtbl.t
  }

let state = ref None

let get () : t =
  match !state with
  | None -> failwith "Uninitialized global state"
  | Some s -> s
;;

let set s = state := Some s
let get_player () = Option.get (get ()).player

let update f =
  let g = get () in
  set (f g)
;;

let get_texture name = Hashtbl.find (get ()).textures name
