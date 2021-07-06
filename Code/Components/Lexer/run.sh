flex -o scanner.c scanner.l
g++ SymbolInfo.cpp ScopeTable.cpp SymbolTable.cpp scanner.c -lfl -o scanner.out
./scanner.out sample_input1.txt