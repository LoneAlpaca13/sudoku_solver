let s = read_line ()
let n = String.length s

let rec aux i =
  if i >= n-1 then ()
  else (
    print_string (read_line ());
    print_string "\n";
    aux (i+1)
  )

let () = 
  print_string s;
  print_string "\n";
  aux 0;
  let t = read_line () in
  if t.[2]='S' then
    (print_string "Multiple solutions found\n ");;
