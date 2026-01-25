l1 = input()
l2 = input()

clauses = l2.split(' ')[1:-1] 
clauses = map(int, clauses)
clauses = filter(lambda x: x > 0, clauses)

count = 0
for c in clauses:
    digit = (c - 1) % 16 + 1
    print(digit, end=' ')
    count += 1
    if count == 16: print() ; count = 0
