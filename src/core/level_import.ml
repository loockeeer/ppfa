type tiled_level =
  | Terrain of int
  | Custom of char

let convert_csv_to_string csv_data =
  csv_data
  |> Str.split (Str.regexp "[ \t\n,]+")
  |> List.map (fun s ->
    match int_of_string_opt s with
    | None when String.length s >= 1 -> Some (Custom s.[0])
    | None -> None
    | Some x -> Some (Terrain x))
  |> Array.of_list
;;
