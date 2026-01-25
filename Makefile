run: solution.txt

dimacs.txt: main.ml input.txt
	ocamlc main.ml -o main
	./main < input.txt > dimacs.txt

output1.txt: dimacs.txt
	z3 -dimacs dimacs.txt > output1.txt

output2.txt: z3togrid.ml output1.txt
	ocamlc z3togrid.ml -o z3togrid
	./z3togrid < output1.txt > output2.txt

output3.txt: check_sol.ml dimacs.txt output1.txt
	ocamlc check_sol.ml -o check_sol
	cat dimacs.txt output1.txt | ./check_sol > output3.txt

output4.txt: output3.txt
	z3 -dimacs output3.txt > output4.txt

solution.txt : check_multiple_sol.ml output2.txt output4.txt
	ocamlc check_multiple_sol.ml -o check_multiple_sol
	cat output2.txt output4.txt | ./check_multiple_sol > solution.txt