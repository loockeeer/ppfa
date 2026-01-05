(* Les types des textures qu'on veut dessiner à l'écran *)
type texture =
    Color of Gfx.color
  | Image of Gfx.surface

let white = Color (Gfx.color 255 255 255 255)
let black = Color (Gfx.color 0 0 0 255)

type config = {
  (* Informations des touches *)
  key_left: string;
  key_up : string;
  key_down : string;
  key_right : string;

  (* Informations de fenêtre *)
  window : Gfx.window;
  window_surface : Gfx.surface;
  ctx : Gfx.context;
}


(* On crée une fenêtre *)

let draw_rect config texture x y w h =
    match texture with
    | Color c -> 
            begin
            Gfx.set_color config.ctx c;
            Gfx.fill_rect config.ctx config.window_surface x y w h
            end
    | _ -> failwith "todo";;

let update cfg dt =
    draw_rect cfg black 100 100 200 200;
    None;;

let run keys =
    let win = Gfx.create "game_canvas:800x600:" in
    let cfg = {
        key_left = keys.(0);
        key_right = keys.(1);
        key_up = keys.(2);
        key_down = keys.(3);

        window = win;
        window_surface = Gfx.get_surface win;
        ctx = Gfx.get_context win;
    } in
    Gfx.main_loop (update cfg) (fun () -> ())
