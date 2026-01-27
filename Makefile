all : 
	ocamlc sudoku2cnf.ml -o sudoku2cnf
	ocamlc soltogrid.ml -o soltogrid
	ocamlc check_sol.ml -o check_sol
	ocamlc check_multiple_sol.ml -o check_multiple_sol

run: output.txt

dimacs.cnf: sudoku2cnf.ml input.txt
	ocamlc sudoku2cnf.ml -o sudoku2cnf
	./sudoku2cnf < input.txt > dimacs.cnf

z3_output.txt: dimacs.cnf
	z3 -dimacs dimacs.cnf > z3_output.txt

first_sol.txt: soltogrid.ml z3_output.txt
	ocamlc soltogrid.ml -o soltogrid
	./soltogrid < z3_output.txt > first_sol.txt

mult_sol.cnf: check_sol.ml dimacs.cnf z3_output.txt
	ocamlc check_sol.ml -o check_sol
	cat dimacs.cnf z3_output.txt | ./check_sol > mult_sol.cnf

z3_new_input.txt: mult_sol.cnf
	z3 -dimacs mult_sol.cnf > z3_new_input.txt

output.txt : check_multiple_sol.ml first_sol.txt z3_new_input.txt
	ocamlc check_multiple_sol.ml -o check_multiple_sol
	cat first_sol.txt z3_new_input.txt | ./check_multiple_sol > output.txt
clean:
	rm -f *.cmi *.cmo *.cmx 
	rm -f sudoku2cnf soltogrid check_sol check_multiple_sol

clean_intermediate:
	rm -f dimacs.cnf z3_output.txt first_sol.txt mult_sol.cnf z3_new_input.txt