# Sudoku CNF Generator & Z3 Runner

Small OCaml utilities to convert Sudoku puzzles to DIMACS CNF, run Z3, and convert/check solutions.

## Overview

This repository contains tools to:
- convert an input Sudoku grid into a DIMACS CNF formula (`sudoku2cnf.ml`),
- run Z3 on the formula and parse its output into a grid (`soltogrid.ml`),
- check existence of other solutions (`check_sol.ml`, `check_multiple_sol.ml`).

## Requirements

- ocamlc 5.4.0
- Z3 (with `-dimacs` support)
- GNU Make

Tested sizes: 9x9, 16x16.

## Input format

Provide an `input.txt` with exactly `n` lines each of length `n` (no separators). Use:
- `.` for empty cells
- digits `1`..`9` for values
- letters `A`..`F` for values 10..15 & `0` for value 0 when using 16x16

Example (partial 9x9):

5...78912\
6.21.5348\
1..3425.7\
.13..4.2.\
... (9 lines total)

## Variable (Literal) Encoding

Each Boolean variable in the DIMACS CNF corresponds to assigning a value to a specific cell in the Sudoku grid.

The encoding is linear and cell-based:

- Variables `1..n` represent the possible values of the **first cell** (row 1, column 1)
- Variables `n+1..2n` represent the possible values of the **second cell** (row 1, column 2)
- In general, for cell index `i` (0-based), its value literals are:

  literal = i * n + value

where `value` ranges from `1` to `n`.

### Example (9×9 Sudoku)

For the first row:

- Cell (1,1): literals `1..9`
- Cell (1,2): literals `10..18`
- Cell (1,3): literals `19..27`

and so on.

This encoding allows each constraint (cell, row, column, and sub-grid) to be expressed using arithmetic over literal indices without explicitly storing grid coordinates.

## Build

Build the OCaml utilities:

```
make all
```

This produces `sudoku2cnf`, `soltogrid`, `check_sol`, and `check_multiple_sol` executables.

## Usage (full pipeline)

Run the full pipeline that converts `input.txt`, solves with Z3, and writes a human-readable output:

```
make run
```

This target produces `output.txt` containing the original solution and whether multiple solutions were found.

Detailed individual steps (if you prefer to run manually):

- Generate DIMACS CNF from `input.txt`:

```
make dimacs.cnf
```

- Solve the DIMACS CNF using Z3:

```
make z3_output.txt
```

- Convert Z3 output to grid format:

```
make first_sol.txt
```

- Check for additional solutions and produce final output:

```
make output.txt
```
## Pipeline and Tool Responsibilities

The solution process is split into multiple small utilities, each responsible for one stage of the pipeline.

### `sudoku2cnf.ml`
Converts the Sudoku grid from `input.txt` into a DIMACS CNF formula using the literal encoding described above.
The generated CNF encodes:
- cell constraints (each cell has exactly one value),
- row constraints,
- column constraints,
- sub-grid (block) constraints,
along with clauses derived from the given input clues.

### `soltogrid.ml`
Parses Z3’s DIMACS model output and converts the satisfying assignment back into a human-readable Sudoku grid using the inverse of the literal encoding.

### `check_sol.ml`
If Z3 finds a solution, this tool generates a new DIMACS CNF by:
- reusing the original encoding, and
- adding a clause that negates the previously found solution.

This forces Z3 to search for a different solution, enabling detection of multiple solutions.

### `check_multiple_sol.ml`
Reads the original solution (if present) and the result of the second Z3 run.
It prints:
- the first solution, and
- an additional line indicating whether multiple solutions exist.


## Makefile targets

- `all` — compile all tools
- `run` — run the full pipeline and generate `output.txt`
- `dimacs.cnf`, `z3_output.txt`, `first_sol.txt`, `mult_sol.cnf`, `z3_new_input.txt` — intermediate targets used by the pipeline
- `clean` — remove compiled OCaml artifacts and executables
- `clean_intermediate` — remove generated CNF/Z3/intermediate files

## Files

- `sudoku2cnf.ml` — converts `input.txt` grid to DIMACS CNF
- `soltogrid.ml` — parses Z3's model and prints a readable grid
- `check_sol.ml` — prepares a new CNF to request different solutions from Z3
- `check_multiple_sol.ml` — collates the original solution and additional Z3 output to indicate multiplicity
- `Makefile` — automates build and the solve/check pipeline
- `input.txt` — example/input puzzle file (user-provided)

## Notes & Troubleshooting

- Ensure `z3` is on your PATH and supports the `-dimacs` option.
- Input line length determines supported grid sizes; invalid sizes may produce errors.
- If you want just the solver step, run the specific `make` targets above instead of `make run`.
