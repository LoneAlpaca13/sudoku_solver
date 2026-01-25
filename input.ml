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

let rec basic_clause inp n=
  let rec aux i=
    
  if count=n then ()
  else
     aux 
