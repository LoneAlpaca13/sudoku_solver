let s = read_line()
let count = String.length s

open List
let inp = [s]
let rec read_lines n count inp=
  if count=n then inp
  else
    let line = read_line() in
    read_lines n (count+1) (line::inp)

let inp = read_lines count 1 inp
let y = List.rev inp

let to_val c = 
  match c with '0' -> 16 | '1'..'9' -> int_of_char c - 48 | 'A'..'F' -> int_of_char c - 55 | 'a'..'f' -> int_of_char c - 87 | _ -> -1

let x = List.fold_left (^) "" y

(*Prints all the clauses which are generated from the input file(only prints the clauses that denote the presence of some value in the input grid).*)
let rec input_clause st n x=
    if n=x then ()
    else(
      if st.[n]<>'.' then (
        print_int((n)*count+to_val st.[n]);
      print_string " 0\n";
        input_clause st (n+1) x 
      )
      else(
        input_clause st (n+1) x
      )
    )

let n = count
let square = n * n
let cube = square * n

let root = match n with
  | 1 -> 1
  | 4 -> 2
  | 9 -> 3
  | 16 -> 4
  | _ -> -1

(*Prints numbers starting from z till there are total of n entries each less than the previous by a difference of k*)
let print_range z n k =
  let rec aux count =
    if count = n then ()        
    else (
      Printf.printf "%d " (z - count*k);  
      aux (count + 1)   
    )
  in
  aux 0;
  Printf.printf "0\n"

(*Class print_range which prints the condition for each cell in the sudoku grid have atleast one value*)
let rec gen_cell_atleast_one z n =
  if z = n then
    print_range z n 1
  else (
    print_range z n 1;
    gen_cell_atleast_one (z - n) n
  )

(*Class print_range which prints the condition for each row in the sudoku grid have atleast one value*)
let rec gen_row_atleast_one z n =
  let rec aux y count =
    if count = n then ()        
    else (
      print_range (y-count) n n;  
      aux y (count + 1)
    )
  in
  if z = n*n then
    aux z 0
  else (
    aux z 0;
    gen_row_atleast_one (z - n*n) n
  )

(*Class print_range which prints the condition for each column in the sudoku grid have atleast one value*)
let rec gen_col_atleast_one z n =
  let rec aux y count =
    if count = n then ()        
    else (
      print_range (y-count) n (n*n);  
      aux y (count + 1)
    )
  in
  if z = n*n*n-n*n+n then
    aux z 0
  else (
    aux z 0;
    gen_col_atleast_one (z - n) n
  )

(*Takes inputs z,n,k and returns the negation of combinations of any two elements which lie in the sequence (z,z-n,z-2n,... z-(k-1)*n)*)
let rec comb z n k =
  let rec aux z n count =
    if count = k then ()
    else(
      Printf.printf "%d %d 0\n" (-z) (-(z - (count)*n));
      aux z n (count + 1)
    )
  in
  if k = 1 then ()
  else(
    aux z n 1;
    comb (z-n) n (k-1)
  )

(*Calls comb func which in turn prints all the possible combination required to satisfy the at most one constraint in each cell*)
let rec at_max_one_in_cell z n =
  match z with
  | 0 -> ()
  | _ ->
      comb z 1 n;
      at_max_one_in_cell (z - n) n

(*Calls comb func which in turn prints all the possible combination required to satisfy the at most one constraint in each row*)
let rec no_two_row_values_same z n =
  let rec aux z n k count =
    if count = n then ()
    else(
      comb (z-count) n n;
      aux  z n k (count + 1)
    )
  in
  if z = n*n then(
    aux z n n 0
  )
  else(
    aux z n n 0;
    no_two_row_values_same (z - n*n) n
  )

(*Calls comb func which in turn prints all the possible combination required to satisfy the at most one constraint in each column*)
let rec no_two_col_values_same z n =
  let rec aux z n k count =
    if count = n then ()
    else(
      comb (z-count) (n*n) n;
      aux  z n k (count + 1)
    )
  in
  if z = n*n*n-n*n+n then(
    aux z n n 0
  )
  else(
    aux z n n 0;
    no_two_col_values_same (z-n) n
  )

(*Prints the clause corresponding to a single block-row inside a sub-grid.
  It groups k variables from k different rows that belong to the same block
  and prints them as one clause.*)
let print_block z n k =
  let rec print_group start count =
    if count = k then ()
    else (
      Printf.printf "%d " (start - count * n);
      print_group start (count + 1)
    )
  in
  let rec groups i =
    if i = k then ()
    else (
      print_group (z - i * n * n) 0;
      groups (i + 1)
    )
  in
  groups 0;
  Printf.printf "0\n"

(*Iterates over all cell positions inside a single sub-grid and calls
  print_block to generate the block constraints for that sub-grid.*)
let print_whole_block z n=
  let rec aux z n count =
    if count = n then ()
    else (
      print_block (z - count) n root;
      aux z n (count + 1)
    )
  in
  aux z n 0

(*Iterates over the final element of all sub-grids in the sudoku and calls the print_whole_block
  to print constraints for each block.*)
let iterate_block z n k =
  let rec inner start count =
    if count = k then ()
    else (
      print_whole_block (start - count * k * n) n;
      inner start (count + 1)
    )
  in
  let rec outer layer =
    if layer = k then ()  
    else (
      inner (z - layer * k * n * n) 0;
      outer (layer + 1)
    )
  in
  outer 0

(*Calculates the no of clauses
  The clause count for the the basic soduku encoding have been hard coded and the no of clauses counted from input have been calculated*)
let rec cal_clause_count st n x h=
    if n=x then(
      match n with
      | 1 -> 1
      | 81 -> (9072+h)
      | 256 -> (93184+h)
      | _ -> 0
    )
    else(
      if st.[n]<>'.' then (
        cal_clause_count st (n+1) x (h+1)
      )
      else(
        cal_clause_count st (n+1) x h
      )
    )

(*Prints the first line of the cnf output*)
let first_line () =
  print_string "p cnf ";
  print_int (count*count*count);
  print_string " ";
  print_int (cal_clause_count x 0 (count*count) 0);
  print_string "\n"
  
let () =
first_line ();
input_clause x 0 (count*count);
iterate_block cube n root;
no_two_row_values_same cube n;
no_two_col_values_same cube n;
gen_cell_atleast_one cube n;
gen_row_atleast_one cube n;
gen_col_atleast_one cube n;
at_max_one_in_cell cube n;
;;

