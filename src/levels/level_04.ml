(* Level 4 *)

let layer_content = "\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                    p x\
x                                      x\
x                                  xxxxx\
x                                  x   x\
x                                  x   x\
x                                  x   x\
x  h  b                            x   x\
xxxxxxxxxxx                  xxxxxxxxxxx\
x             xx                       x\
x             xxxxx                    x\
x                    xxxx              x\
x                    xxxxxx    xxxxxxxxx\
xxxxxxxxx                      x       x\
x       x                      x       x\
x       x          @           x       x\
x  h    x                  f   x       x\
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\
x                                      x\                                      x\
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
