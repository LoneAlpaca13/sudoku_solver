open List
let first_line = read_line ()
let second_line = read_line ()
let num_cells =
  String.split_on_char ' ' second_line
  |> List.tl
  |> List.filter (fun x -> x <> "" && x.[0] <> '-')

let n =
  let count= List.length num_cells
  in
  match count with
  | 1 -> 1
  | 81 -> 9
  | 16 -> 4
  | 256 -> 16
  | _ -> -1

let rec print_as_grid cells n count = 
  let convert_to_value c n =
  if n <> 16 then(
    if c mod n=0 then print_int n
    else print_int (c mod n)
  )
  else(
    if c mod n < 10 then 
      print_int (c mod n)
    else
      print_char(char_of_int (c mod n - 10 + int_of_char 'A'))
  )
  in
  match cells with
  | [] -> ()
  | hd :: tl ->
      convert_to_value (int_of_string(hd)) n;
      if count mod n = 0 then(
        print_newline ();
        print_as_grid tl n (count + 1)
      )
      else
        print_as_grid tl n (count + 1)

let checker first_line =
  if first_line.[2] = 'U' then 
    print_endline "Sudoku Unsolvable"
  else(
    print_as_grid num_cells n 1;
  )

let () =
checker first_line;;

      
