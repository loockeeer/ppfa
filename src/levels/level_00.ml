(* Level 0 *)


(* ajouter texte bg "appuyer sur e à côté du porte chapeau pour passer au niveau suivant"*)

let layer_content = "\
x                                       \
x                                       \
x                                       \
x                                       \
x               @                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                   p                   \
x                                       \
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       "[@@ocamlformat "disable"]

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