#lang peg

comment <- '//' [^\n]* ;
_ < (comment / [ \t\n])* ;
__ < (comment / [ \t\n]+) ;
name <-- [a-zA-z][a-zA-Z0-9_]* _ ;

OPEN < '(' _ ;
CLOSE < ')' _ ;
OPENBRACE < '{' _ ;
CLOSEBRACE < '}' _ ;
FUNCTION < 'function' __ ;
COLON < ':' _ ;
SEMICOLON < ';' _ ;
ASSIGN < '=' _ ;
NAND_ < '!' _ ;
NAND <-- NAND_ ;
COMMA < ',' _ ;
VAR < 'var' __ ;
IF < 'if' __ ;
WHILE < 'while' __ ;

program <-- (_ func)* !.;
func <-- FUNCTION name (OPEN CLOSE / OPEN arglist CLOSE) funcbody;

arglist <- arginputs? COLON argoutputs? ;
arginputs <- args ;
argoutputs <- args ;
args <-- name (COMMA name)* ;

funcbody <- OPENBRACE stmt* CLOSEBRACE ;

stmt <- decl_stmt / if_stmt / while_stmt / assign_stmt ;
assign_stmt <-- args ASSIGN expr SEMICOLON ;
decl_stmt <-- VAR assign_stmt ;
if_stmt <-- IF expr OPENBRACE stmt* CLOSEBRACE ;
while_stmt <-- WHILE expr OPENBRACE stmt* CLOSEBRACE ;

expr <-- expr_nonand (NAND expr_nonand)? ;
expr_nonand <- const_expr / funcall_expr / var_expr ;
const_expr <-- '0' / '1' ;
var_expr <-- name ;
funcall_expr <-- name OPEN exprs? CLOSE ;
exprs <- expr (COMMA expr)* ;




