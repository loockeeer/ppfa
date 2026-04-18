(* Level 1 *)

let layer_content =
    "                               \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                              \
     x                 x            \
     xxxxxxxxxxxx                   \
     xxxxxxxxxx                     \
     xxxxxxxx             xxxxxxxx  \
     xxxxxx                         \
     xxxxx  @         x             \
     xxxx                           \
     xxx                   f        \
     xx              xxxxxxxxxxxxx  \
     x                              \
     x                              \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxx                   \
     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"[@@ocamlformat "disable"]

let level =
  Level.
    { layers =
        [ Level.
            { contents = layer_content
            ; offsets =
                (let tbl = Hashtbl.create 16 in
                 Hashtbl.add tbl (Level.Named '@') Vector.{ x = 0.; y = 0. };
                 tbl)
            ; width = 31
            ; stride = Rect.{ width = 20; height = 20 }
            }
        ]
    ; camera = (1., Vector.{ x = 0.; y = 0. })
    }
;;