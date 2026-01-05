(* Les types des textures qu'on veut dessiner à l'écran *)
type texture =
  | Color of Gfx.color
  | Image of Gfx.surface

module Colors = struct
  let white = Color (Gfx.color 255 255 255 255)
  and black = Color (Gfx.color 0   0   0   255)
  and red   = Color (Gfx.color 255 0   0   255)
  and green = Color (Gfx.color 0   255 0   255)
  and blue  = Color (Gfx.color 0   0   255 255)
end [@@ocamlformat "disable"]

type config =
  { (* Informations des touches *)
    key_left : string
  ; key_up : string
  ; key_down : string
  ; key_right : string
  ; (* Informations de fenêtre *)
    window : Gfx.window
  ; window_surface : Gfx.surface
  ; ctx : Gfx.context
  ; (* Game status *)
    textures : texture array
  ; mutable current : int
  ; mutable last_dt : float
  }

(* On crée une fenêtre *)

let draw_rect config texture x y w h =
  match texture with
  | Color c ->
    Gfx.set_color config.ctx c;
    Gfx.fill_rect config.ctx config.window_surface x y w h
  | _ -> failwith "todo"
;;

let update cfg dt =
  if dt -. cfg.last_dt >= 1000. then begin
      cfg.current <- cfg.current + 1;
      cfg.last_dt <- dt;
  end;
  draw_rect cfg cfg.textures.(cfg.current mod Array.length cfg.textures) 100 100 200 200;
  None
;;

let run keys =
  let win = Gfx.create "game_canvas:800x600:" in
  let cfg =
    { key_left = keys.(0)
    ; key_right = keys.(1)
    ; key_up = keys.(2)
    ; key_down = keys.(3)
    ; window = win
    ; window_surface = Gfx.get_surface win
    ; ctx = Gfx.get_context win
    ; textures = [| Colors.red; Colors.green; Colors.blue |]
    ; current = 0
    ; last_dt = 0.
    }
  in
  Gfx.main_loop (update cfg) (fun () -> ())
;;
