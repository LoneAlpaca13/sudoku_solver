open List
let first_line = read_line ()

(*Takes a list of cell values and prints them in a grid format
wherein the convert_to_value function converts the cell value(string of char or int depending on n) to a integer based on the grid size n.*)
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

(*Reads the first line of z3 output file to check if solution exists
  If solution exists splits the input string from z3 and filters it to only have the lietrals that are true,
 which are then converted to grid values by function call to print_as_grid*)
let checker first_line =
  if first_line.[2] = 'U' then 
    print_endline "No sudoku found"
  else(
  let second_line = read_line () in
  let num_cells =
  String.split_on_char ' ' second_line
  |> List.filter (fun x -> x <> "" && x.[0] <> '-' && x <> "v")
  in
  let n =
  let count= List.length num_cells
  in
  match count with
  | 1 -> 1
  | 81 -> 9
  | 16 -> 4
  | 256 -> 16
  | _ -> -1
  in
  print_as_grid num_cells n 1;
  )

let () =
checker first_line;;

      
