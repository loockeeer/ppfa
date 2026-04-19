(* Level final *)

(* ajouter en background "félicitations, tu as sauvé tous les chapeaux" *)

let layer_content = "\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x               @                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x              f                       x\
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\
x     b        h          f            x\
x        f   b         h               x\
x   h          f      b                x\
x          b        h        f         x\
x     f           h      b             x\
x        h     f        b              x\
x   b         f           h            x\
x        h         b      f            x\
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"[@@ocamlformat "disable"]

let level =
  Level.
    { layers =
        [ Level.
            { contents = layer_content
            ; offsets =
                (let tbl = Hashtbl.create 16 in
                 Hashtbl.add tbl (Level.Named '@') Vector.{ x = 0.; y = 0. };
                 tbl)
            ; width = 40
            ; stride = Rect.{ width = 20; height = 20 }
            }
        ]
    ; camera = (1., Vector.{ x = 0.; y = 0. })
    }
;;
