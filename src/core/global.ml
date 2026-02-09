open Component_defs

type t =
  { window : Gfx.window
  ; ctx : Gfx.context
  ; mouse_x : int
  ; mouse_y : int
  ; camera_x : int
  ; camera_y : int
  ; camera_zoom : float
  ; player : Component_defs.player option
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
