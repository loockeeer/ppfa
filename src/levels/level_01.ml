(* Level 1 *)

(* Ajouter texte bg 
"- appuyer sur e à côté d'un chapeau permet de le récupérer, 
 - re-appuyer permet de le lancer 
- le haut de forme permet de sauter plus haut" *)

(* bon c'est un peu long donc voir comment faire ça proprement *)

let layer_content = "\
x                                      x\
x                                      x\
x                                      x\
x                                      x\
x                                 p    x\
x                                      x\
x                          xxxxxxxxxxxxx\
x                          x           x\
x               @          x           x\
x                          x           x\
x                          x           x\
x      h   f               x           x\
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
