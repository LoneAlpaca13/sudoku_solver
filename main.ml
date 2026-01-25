let s = read_line()
let count = String.length s

open List
let inp = [s]
let rec read_lines n count inp=
  if count=n then inp
  else
    let line = read_line() in
    let lp = line::inp in
    read_lines n (count+1) lp

let inp = read_lines count 1 inp
let y = List.rev inp

let to_val c = 
  match c with '0'..'9' -> int_of_char c - 48 | 'A'..'F' -> int_of_char c - 55 | 'a'..'f' -> int_of_char c - 87 | _ -> -1

let x = List.fold_left (^) "" y

let rec basic_clause st n x=
    if n=x then ()
    else(
      if st.[n]<>'.' then (
        print_int((n)*count+to_val st.[n]);
      print_string " 0\n";
        basic_clause st (n+1) x 
      )
      else(
        basic_clause st (n+1) x
      )
    )

let n = count
let square = n * n
let cube = square * n

let root = match n with
  | 4 -> 2
  | 9 -> 3
  | 16 -> 4
  | _ -> failwith "Unsupported n"

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

let rec gen_cell z n =
  if z = n then
    print_range z n 1
  else (
    print_range z n 1;
    gen_cell (z - n) n
  )

let rec gen_row z n =
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
    gen_row (z - n*n) n
  )

let rec gen_col z n =
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
    gen_col (z - n) n
  )

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
    
let rec no_tworow_values z n =
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
    no_tworow_values (z - n*n) n
  )

let rec no_twocol_values z n =
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
    no_twocol_values (z-n) n
  )

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

let print_whole_block z n=
  let rec aux z n count =
    if count = n then ()
    else (
      print_block (z - count) n root;
      aux z n (count + 1)
    )
  in
  aux z n 0

let print_super_block z n k =
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

let () =
basic_clause x 0 (count*count);
gen_cell cube n;
gen_row cube n;
gen_col cube n;
no_tworow_values cube n;
no_twocol_values cube n;
print_super_block cube n root
;;

