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
  ; key_exit : string
  ; keys_status : (string, bool) Hashtbl.t
  ; (* Informations de fenêtre *)
    window : Gfx.window
  ; window_surface : Gfx.surface
  ; ctx : Gfx.context
  ; (* Game status *)
    textures : texture array
  ; mutable current : int
  ; mutable last_dt : float (* Rectangle position *)
  ; mutable x : int
  ; mutable y : int
  }

let rec trace_keys cfg =
  try
    match Gfx.poll_event () with
    | KeyUp s -> Hashtbl.add cfg.keys_status s false
    | KeyDown s -> Hashtbl.add cfg.keys_status s true
    | NoEvent -> raise Exit
    | _ ->
      ();
      trace_keys cfg
  with
  | _ -> ()
;;

(* On crée une fenêtre *)

let draw_rect config texture x y w h =
  match texture with
  | Color c ->
    Gfx.set_color config.ctx c;
    Gfx.fill_rect config.ctx config.window_surface x y w h
  | Image surf -> Gfx.blit_scale config.ctx config.window_surface surf x y w h
;;

let update_rect_pos cfg dt =
  if Hashtbl.find cfg.keys_status cfg.key_up then cfg.y <- cfg.y - 10;
  if Hashtbl.find cfg.keys_status cfg.key_down then cfg.y <- cfg.y + 10;
  if Hashtbl.find cfg.keys_status cfg.key_left then cfg.x <- cfg.x - 10;
  if Hashtbl.find cfg.keys_status cfg.key_right then cfg.x <- cfg.x + 10
;;

let update_rect_color cfg dt =
  if dt -. cfg.last_dt >= 1000.
  then (
    cfg.current <- cfg.current + 1;
    cfg.last_dt <- dt)
;;

let update cfg dt =
  (* Backend updates *)
  trace_keys cfg;
  if Hashtbl.find cfg.keys_status cfg.key_exit
  then Some ()
  else (
    update_rect_pos cfg dt;
    update_rect_color cfg dt;
    (* Frontend updates *)
    let w, h = Gfx.get_window_size cfg.window in
    draw_rect cfg Colors.white 0 0 w h;
    draw_rect
      cfg
      cfg.textures.(cfg.current mod Array.length cfg.textures)
      cfg.x
      cfg.y
      200
      200;
    None)
;;

let run_custom win keys images =
  let t = Hashtbl.create (Array.length keys) in
  Array.iter (fun key -> Hashtbl.add t key false) keys;
  let cfg =
    { key_left = keys.(0)
    ; key_right = keys.(1)
    ; key_up = keys.(2)
    ; key_down = keys.(3)
    ; key_exit = keys.(4)
    ; keys_status = t
    ; window = win
    ; window_surface = Gfx.get_surface win
    ; ctx = Gfx.get_context win
    ; textures = Array.of_list (List.map (fun x -> Image x) images)
    ; current = 0
    ; last_dt = 0.
    ; x = 100
    ; y = 100
    }
  in
  Gfx.main_loop (update cfg) (fun () -> ())
;;

let run keys =
  let win = Gfx.create "game_canvas:800x600:" in
  let ts = Gfx.load_file "resources/files/tile_set.txt" in
  Gfx.main_loop
    (fun _ -> Gfx.get_resource_opt ts)
    (fun txt1 ->
       let res_list =
         String.split_on_char '\n' txt1
         |> List.filter_map (fun p ->
           if p = ""
           then None
           else Some (Gfx.load_image (Gfx.get_context win) ("resources/images/" ^ p)))
       in
       Gfx.main_loop
         (fun _ ->
            let result = List.map Gfx.get_resource_opt res_list in
            if List.for_all (( <> ) None) result
            then Some (List.map Option.get result)
            else None)
         (run_custom win keys))
;;
