let s = read_line ()
let n = String.length s
(* Recursively reads and prints each remaining line of the previous solution.*)
let rec print_original_solution i =
  if i >= n-1 then ()
  else (
    print_string (read_line ());
    print_string "\n";
    print_original_solution (i+1)
  )

(*Checks if there is atleast one solution to the the input and if one exists then reads the 2nd output file of z3 and prints if there are multiple solutions*)
let () = 
  print_string s;
  print_string "\n";
  if s.[0]<>'N' then
    print_original_solution 0;
    let t = read_line () in
    if t.[2]='S' then
      (print_string "Multiple solutions found\n ");;
