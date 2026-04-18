(* Niveau d'introduction *)

let layer_content_0_0 = "\
x                                       \
x                                       \
x                                       \
x                                       \
x               @                       \
x                                       \
x                                       \
x                                       \
x                                       \
x                                       \
x       f        b    h                 \
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

let level_0 =
  Level.
    { layers =
        [ Level.
            { contents = layer_content_0_0
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


(* Level 1 *)

let layer_content_0_1 =
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

let level_1 =
  Level.
    { layers =
        [ Level.
            { contents = layer_content_0_1
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

(* Level 2 *)

(* let level_2 = failwith "todo" *)

(* Level 3 *)
(* let level_3 = failwith "todo" *)

(* Level 4 *)
(* let level_4 = failwith "todo" *)
