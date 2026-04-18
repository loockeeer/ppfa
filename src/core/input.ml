type register_type =
  | KeyDown
  | KeyHold
  | KeyUp

let key_table = Hashtbl.create 16
let has_key s = Hashtbl.mem key_table s
let set_key s = Hashtbl.replace key_table s ()
let unset_key s = Hashtbl.remove key_table s

let action_table : (register_type * string, float * float -> unit) Hashtbl.t =
  Hashtbl.create 16
;;

let register key action = Hashtbl.replace action_table key action
let paused = ref false
let pause () = paused := not !paused

let handle_input ticks_info =
  let () =
    match Gfx.poll_event () with
    | KeyDown s ->
      if not !paused
      then (
        Hashtbl.iter
          (fun key action ->
             match key with
             | KeyDown, x when x = s && not (has_key s) -> action ticks_info
             | _ -> ())
          action_table;
        set_key s)
    | KeyUp s ->
      if not !paused
      then (
        unset_key s;
        Hashtbl.iter
          (fun key action ->
             match key with
             | KeyUp, x when x = s -> action ticks_info
             | _ -> ())
          action_table)
    | Quit -> exit 0
    | MouseMove (x, y) -> Global.update (fun g -> { g with mouse_x = x; mouse_y = y })
    | _ -> ()
  in
  Hashtbl.iter
    (fun key action ->
       match key with
       | KeyHold, x when has_key x -> action ticks_info
       | _ -> ())
    action_table
;;

let register_map km =
  register
    (KeyHold, Cst.(km.move_left))
    (fun (_, dt) ->
       let open Global in
       Player.move (get_player ()) Vector.{ x = -.(dt *. Cst.player_speed); y = 0. });
  register
    (KeyHold, Cst.(km.move_right))
    (fun (_, dt) ->
       let open Global in
       Player.move (get_player ()) Vector.{ x = dt *. Cst.player_speed; y = 0. });
  register (KeyDown, Cst.(km.jump)) (fun _ -> Player.jump (Global.get_player ()));
  register
    (KeyDown, Cst.(km.hat_interact))
    (fun _ ->
       match (Global.get_player ())#tag#get with
       | Component_defs.Player (Some hat) ->
         (* Throwing logic here *)
         Player.throw (Global.get_player ()) hat
       | _ ->
         (* Pickup logic here *)
         let nearest source others =
           List.fold_left
             (fun acc current ->
                let new_norm =
                  Vector.(
                    norm
                      (sub
                         (Rect.get_center source#box#get source#position#get)
                         (Rect.get_center current#box#get current#position#get)))
                in
                match acc with
                | Some (x, v) -> if new_norm < v then Some (current, new_norm) else acc
                | None -> Some (current, new_norm))
             None
             others
         in
         (match nearest (Global.get_player ()) (Global.get ()).wild_hats with
          | Some (nearest_hat, norm) ->
            if norm <= Cst.max_hat_pickup_norm
            then Player.grab (Global.get_player ()) nearest_hat
          | None -> ()))
;;
