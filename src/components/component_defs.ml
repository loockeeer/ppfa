open Ecs

class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end

class box () =
  let r = Component.init Rect.{ width = 0; height = 0 } in
  object
    method box = r
  end

class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

class textures () =
  let r : < get : Texture.t array ; set : Texture.t array -> unit > =
    Component.init [||]
  in
  object
    method textures = r
  end

class ticks () =
  let r = Component.init 0 in
  object
    method ticks = r
  end

class last_ticked () =
  let r = Component.init 0. in
  object
    method last_ticked = r
  end

class tick_speed () =
  let r = Component.init 0. in
  object
    method tick_speed = r
  end

class mass () =
  let r = Component.init 0. in
  object
    method mass = r
  end

class forces () =
  let r = Component.init Vector.zero in
  object
    method forces = r
  end

class on_ground () =
  let r = Component.init true in
  object
    method on_ground = r
  end

type hat_type =
  | Hdf
  | Fez

type tag =
  | No_tag
  | Hat of hat_type
  | Solid
  | Player

class tagged () =
  let r = Component.init No_tag in
  object
    method tag = r
  end

class resolver () =
  let r = Component.init (fun (_ : Vector.t) (_ : tag) -> ()) in
  object
    method resolve = r
  end

class type drawable = object
  inherit Entity.t
  inherit position
  inherit box
  inherit texture
end

class type animated = object
  inherit drawable
  inherit textures
  inherit ticks
  inherit last_ticked
  inherit tick_speed
end

class type collidable = object
  inherit Entity.t
  inherit tagged
  inherit position
  inherit box
  inherit velocity
  inherit mass
  inherit resolver
end

class type physics = object
  inherit Entity.t
  inherit tagged
  inherit forces
  inherit position
  inherit velocity
  inherit mass
end

class block () =
  object
    inherit Entity.t ()
    inherit tagged ()
    inherit position ()
    inherit box ()
    inherit texture ()
    inherit mass ()
    inherit velocity ()
    inherit resolver ()
  end

class player () =
  object
    inherit Entity.t ()
    inherit tagged ()
    inherit position ()
    inherit texture ()
    inherit box ()
    inherit mass ()
    inherit velocity ()
    inherit forces ()
    inherit resolver ()
    inherit on_ground ()
    inherit textures ()
    inherit ticks ()
    inherit last_ticked ()
    inherit tick_speed ()
  end

class chapeau () =
  object
    inherit Entity.t ()
    inherit tagged ()
    inherit texture ()
    inherit position ()
    inherit box ()
    inherit mass ()
    inherit forces ()
    inherit velocity ()
    inherit resolver ()
  end
