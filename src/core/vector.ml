type t =
  { x : float
  ; y : float
  }

let add a b = { x = a.x +. b.x; y = a.y +. b.y }
let sub a b = { x = a.x -. b.x; y = a.y -. b.y }
let mult k a = { x = k *. a.x; y = k *. a.y }
let dot a b = (a.x *. b.x) +. (a.y *. b.y)
let norm a = sqrt (dot a a)
let normalize a = mult (1. /. norm a) a
let pp fmt a = Format.fprintf fmt "(%f, %f)" a.x a.y
let p = fun a -> pp Format.std_formatter a; print_newline ()
let e i = print_int (i + Random.int 2); print_newline ()
let zero = { x = 0.; y = 0. }
let is_zero v = v.x = 0. && v.y = 0.
