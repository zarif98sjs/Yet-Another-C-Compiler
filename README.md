# **`A Compiler in the making`**

A compiler is a computer program that translates computer code written in one programming language (the source language) into another language (the target language). Here we will build some parts of a compiler for the subset of C language.

# Part 1 : **`Creating a Symbol Table`**

The first part needed to make a `Compiler` is a `Symbol Table`. A Symbol Table is a data structure maintained by compilers in order to store information about the occurrence of various entities such as identifiers, objects, function names etc. Information of different entities may include type, value, scope etc. 

At the starting phase of constructing a compiler, we will construct
a Symbol Table which maintains a list of `Hash Tables(Scope Tables)` where each hash table contains information of symbols encountered in a scope of the source program . Each Scope Table will have `Symbol Info` (which will store the information) in it's buckets.

Here is an overview 

![](images/symboltable.png)

Now straight to code . I am showing the declarations here . The full implementation can be found in the code directory.

## `SymbolInfo`

```c++

#ifndef SYMBOLINFO_H
#define SYMBOLINFO_H

#include<bits/stdc++.h>
using namespace std;

struct SymbolInfo
{
    string key;
    string val;
    string var_type;
    vector<string>param_v;
    bool isFunctionDeclaration;
    bool isFunction;

    SymbolInfo* nxt;

    int bucket;
    int bucket_pos;

    SymbolInfo();

    SymbolInfo(string key,string val);
    SymbolInfo(string key,string val,string var_type,vector<string>param_v,bool isFunctionDeclaration,bool isFunction);

    SymbolInfo(string key,string val,string var_type,vector<string>param_v,bool isFunctionDeclaration,bool isFunction,SymbolInfo* nxt);


    void setVarType(string var_type);
};

#endif // SYMBOLINFO_H

```

## `ScopeTable`

```c++

#ifndef SCOPETABLE_H
#define SCOPETABLE_H

#include<bits/stdc++.h>
#include "SymbolInfo.h"
using namespace std;

struct ScopeTable
{
    string id;
    int counter;

    ScopeTable* parentScope;

    int M; /* initial hast table size */

    vector<SymbolInfo*>ht;

    function<int(string)> hashValue;

    template<typename T>
    ScopeTable(int table_size,T func)
    {
        id = "1";
        counter = 1;
        parentScope = NULL;

        M = table_size;
        hashValue = func;

        ht = vector<SymbolInfo*>(M);
    }

    ~ScopeTable(); /// destructor

    /// id
    string get_id();
    void set_id(string id);

    /// counter
    int get_counter();
    void set_counter(int counter);
    void increase_counter();

    /// hash
    int hash(string key);

    /// mehtods
    SymbolInfo* search(string key);
    SymbolInfo* insert(SymbolInfo si);
    bool erase(string key);

    /// prints
    void print();
    void printChainLengths();

};

#endif // SCOPETABLE_H

```

## `SymbolTable`

```c++

#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

/* Which of the favors of your Lord will you deny ? */

#include<bits/stdc++.h>
#include "ScopeTable.h"
using namespace std;

template <class T>
string to_str(T x)
{
    stringstream ss;
    ss<<x;
    return ss.str();
}


class SymbolTable
{
    ScopeTable* cur;
    int bucket_size;
    function<int(string)> func;

public:

    template<typename T>
    SymbolTable(int bucket_size,T func) /// constructor
    {
        this->bucket_size = bucket_size;
        this->func = func;

        cur = new ScopeTable(bucket_size,func);
    }

    ~SymbolTable();

    void enter_scope(); /// enter scope  = push : create and push a new ScopeTable
    void exit_scope(); /// exit scope  = pop : remove the current ScopeTable

    bool insert_symbol(SymbolInfo si);
    bool remove_symbol(string key);
    SymbolInfo* lookup(string key);

    void print_current_scope();
    void print_all_scope();

    string getCurScopeTableId();

};

#endif // SYMBOLTABLE_H

```

# Part 2 : `Lexical Analysis`

Lexical analysis is the process of scanning the source program as a sequence of characters and converting them into sequences of tokens. A program that performs this task is called a lexical analyzer or a lexer or a scanner.

Here we will use the tool `flex` to do the lexical analysis. Regex is written to do the lexical analysis with flex.



# Part 3 : `Parser(Syntax Analysis) & Semantic Analysis`

The parser obtains a string of tokens from the lexical analyzer and verifies that the string of token names can be generated by the **grammar** for the source language. The parser should also report any syntax errors in an intelligible fashion and recover from commonly occurring errors to continue processing the remainder of the program. 

The grammar we will use here is the following :

```c++
start : program
	{
		//write your code in this block in all the similar blocks below
	}
	;

program : program unit 
	| unit
	;
	
unit : var_declaration
     | func_declaration
     | func_definition
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		| type_specifier ID LPAREN RPAREN SEMICOLON
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
		| type_specifier ID LPAREN RPAREN compound_statement
 		;				


parameter_list  : parameter_list COMMA type_specifier ID
		| parameter_list COMMA type_specifier
 		| type_specifier ID
		| type_specifier
 		;

 		
compound_statement : LCURL statements RCURL
 		    | LCURL RCURL
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
 		 ;
 		 
type_specifier	: INT
 		| FLOAT
 		| VOID
 		;
 		
declaration_list : declaration_list COMMA ID
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  | ID
 		  | ID LTHIRD CONST_INT RTHIRD
 		  ;
 		  
statements : statement
	   | statements statement
	   ;
	   
statement : var_declaration
	  | expression_statement
	  | compound_statement
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  | IF LPAREN expression RPAREN statement
	  | IF LPAREN expression RPAREN statement ELSE statement
	  | WHILE LPAREN expression RPAREN statement
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  | RETURN expression SEMICOLON
	  ;
	  
expression_statement 	: SEMICOLON			
			| expression SEMICOLON 
			;
	  
variable : ID 		
	 | ID LTHIRD expression RTHIRD 
	 ;
	 
 expression : logic_expression	
	   | variable ASSIGNOP logic_expression 	
	   ;
			
logic_expression : rel_expression 	
		 | rel_expression LOGICOP rel_expression 	
		 ;
			
rel_expression	: simple_expression 
		| simple_expression RELOP simple_expression	
		;
				
simple_expression : term 
		  | simple_expression ADDOP term 
		  ;
					
term :	unary_expression
     |  term MULOP unary_expression
     ;

unary_expression : ADDOP unary_expression  
		 | NOT unary_expression 
		 | factor 
		 ;
	
factor	: variable 
	| ID LPAREN argument_list RPAREN
	| LPAREN expression RPAREN
	| CONST_INT 
	| CONST_FLOAT
	| variable INCOP 
	| variable DECOP
	;
	
argument_list : arguments
			  |
			  ;
	
arguments : arguments COMMA logic_expression
	      | logic_expression
	      ;
```

To make parser for this grammar , we will use the tool bison.  This greatly reduces our work .