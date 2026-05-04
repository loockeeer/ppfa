type t =
  | Image of Gfx.surface
  | Color of Gfx.color

let black = Color (Gfx.color 0 0 0 255)
let white = Color (Gfx.color 255 255 255 255)
let red = Color (Gfx.color 255 0 0 255)
let green = Color (Gfx.color 0 255 0 255)
let blue = Color (Gfx.color 0 0 255 255)
let transparent = Color (Gfx.color 0 0 0 0)

let draw ctx dst pos box src =
  let x = int_of_float pos.Vector.x in
  let y = int_of_float pos.Vector.y in
  let Rect.{ width; height } = box in
  match src with
  | Image img -> Gfx.blit_scale ctx dst img x y width height
  | Color c ->
    Gfx.set_color ctx c;
    Gfx.fill_rect ctx dst x y width height
;;

let slice ctx width height texture =
  match texture with
  | Color c -> [| Color c |]
  | Image img ->
    let txt_width, txt_height = Gfx.surface_size img in
    let ret = ref [] in
    for y = 0 to (txt_height / height) - 1 do
      for x = 0 to (txt_width / width) - 1 do
        let new_surf = Gfx.create_surface ctx width height in
        Gfx.blit_full
          ctx
          new_surf
          img
          (x * width)
          (y * height)
          width
          height
          0
          0
          width
          height;
        ret := Image new_surf :: !ret
      done
    done;
    List.rev !ret |> Array.of_list
;;

let sym ctx surf =
  match surf with
  | Color c -> Color c
  | Image surf ->
    Gfx.set_transform ctx 0. true false;
    let width, height = Gfx.surface_size surf in
    let new_surf = Gfx.create_surface ctx width height in
    Gfx.blit ctx new_surf surf 0 0;
    Gfx.reset_transform ctx;
    Image new_surf
;;
