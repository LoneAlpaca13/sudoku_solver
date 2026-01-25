# --- Tools ---
OCAML = ocaml
Z3 = z3

# --- Programs ---
MAIN = main.ml
Z3TOGRID = z3togrid.ml
CHECKSOL = check_sol.ml
CHECKMULT = check_multiple_sol.ml

# --- Input / Output files ---
INPUT = input.txt

OUTPUT = output.txt
OUTPUT1 = output1.txt
OUTPUT2 = output2.txt
OUTPUT3 = output3.txt
OUTPUT4 = output4.txt
OUTPUT5 = output5.txt

all: $(OUTPUT5)

$(OUTPUT): $(MAIN) $(INPUT)
	@echo "Running main.ml..."
	$(OCAML) $(MAIN) < $(INPUT) > $(OUTPUT)

$(OUTPUT1): $(OUTPUT)
	@echo "Running Z3 on output.txt..."
	$(Z3) -dimacs $(OUTPUT) > $(OUTPUT1)

$(OUTPUT2): $(Z3TOGRID) $(OUTPUT1)
	@echo "Converting Z3 output to grid..."
	$(OCAML) $(Z3TOGRID) < $(OUTPUT1) > $(OUTPUT2)

$(OUTPUT3): $(CHECKSOL) $(OUTPUT) $(OUTPUT1)
	@echo "Checking solution..."
	cat $(OUTPUT) $(OUTPUT1) | $(OCAML) $(CHECKSOL) > $(OUTPUT3)

$(OUTPUT4): $(OUTPUT3)
	@echo "Running Z3 on new solution..."
	$(Z3) -dimacs $(OUTPUT3) > $(OUTPUT4)

$(OUTPUT5): $(CHECKMULT) $(OUTPUT2) $(OUTPUT4)
	@echo "Checking multiple solutions..."
	cat $(OUTPUT2) $(OUTPUT4) | $(OCAML) $(CHECKMULT) > $(OUTPUT5)

