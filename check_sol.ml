open List
let st = read_line ()

let p =
  String.split_on_char ' ' st
  |> List.filter (fun x -> x <> "") 

let lst_1 = tl (tl p)
let numb = int_of_string(hd lst_1)

let new_line () = 
  print_string "p cnf ";
  print_int (numb);
  print_string " ";
  let lt = hd (tl lst_1) in
  print_int (1+int_of_string(lt));
  print_string "\n";

  let rec aux count =
    if count = int_of_string(lt) then ()
    else (
    print_string (read_line ());
    print_string "\n";
    aux (count+1)
    )
  in
  aux 0

let check_another () =
  let s = read_line () in
  if s.[2]='S' then
    let t = read_line () in
    let count = String.length t in
    let substr = String.sub t 2 (count-2) in

  let num_cells =
  String.split_on_char ' ' substr
  |> List.filter (fun x -> x <> "") in

  let rec aux su =
    if su = [] then (print_string "0\n")
    else(
        print_int (-1* (int_of_string(hd su)));
        print_string " ";
        aux (tl su)
    );
    in
    aux num_cells

let () = 
    new_line ();
check_another ();;