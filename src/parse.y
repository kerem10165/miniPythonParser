%{     /* PARSER */

#include "parser.hpp"
#include "scanner.h"

#define yylex driver.scanner_->yylex
%}

%code requires
{
  #include <iostream>
  #include "driver.h"
  #include "location.hh"
  #include "position.hh"
}

%code provides
{
  namespace parse
  {
    // Forward declaration of the Driver class
    class Driver;

    inline void
    yyerror (const char* msg)
    {
      std::cerr << msg << std::endl;
    }
  }
}



%require "2.4"
%language "C++"
%locations
%defines
%debug
%define api.namespace {parse}
%define api.parser.class {Parser}
%parse-param {Driver &driver}
%lex-param {Driver &driver}
%define parse.error verbose

%union
{
 /* YYLTYPE */
}

/* Tokens */

%token EOF_ 0
%token ONE_LINE_COMMENT
%token IMPORT
%token IF ELSE WHILE FOR BREAK 
%token AND OR NOT 
%token PRINT
%token DEF
%token RETURN
%token TRUE FALSE
%token NUM
%token IDENTIFIER
%token EQ NEQ GT LT GTE LTE
%token ASSIGN
%token PLUS MINUS MUL DIV 
%token LPARAN RPARAN
%token LBRACE RBRACE
%token QUOTES
%token COLON SEMICOLON
%token COMMA
%token OB CB
%token ERROR
%token IN

%start program

%left OR
%left AND
%left EQ NEQ GT LT GTE LTE
%left PLUS MINUS
%left MUL DIV
%right NOT
%left LPARAN
%nonassoc XIF
%nonassoc ELSE

%%

program:
    | program statement
    ;

statement:
    assignment_statement
    | if_statement
    | while_statement
    | for_statement
    | break_statement
    | print_statement
    | function_definition
    | return_statement
    | import_statement
    | function_call
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression
    | IDENTIFIER ASSIGN expression SEMICOLON
    ;

if_statement:
    IF expression COLON statement %prec XIF
    | IF expression COLON statement ELSE statement
    ;

while_statement:
    WHILE expression COLON statement
    ;

for_statement:
    FOR IDENTIFIER IN expression COLON statement
    ;

break_statement:
    BREAK SEMICOLON
    ;

print_statement:
    PRINT expression
    | PRINT LPARAN expression COMMA argument_list RPARAN
    ;

argument_list:
    expression
    | argument_list COMMA expression
    ;

function_definition:
    DEF IDENTIFIER LPARAN parameter_list RPARAN COLON statement
    ;

return_statement:
    RETURN expression
    | RETURN expression SEMICOLON
    ;

import_statement:
    IMPORT IDENTIFIER
    | IMPORT IDENTIFIER SEMICOLON
    ;

parameter_list:
    | IDENTIFIER
    | parameter_list COMMA IDENTIFIER
    ;

expression:
    logical_or_expression
    ;

function_call:
    IDENTIFIER LPARAN argument_list_opt RPARAN
    ;
    
argument_list_opt:
    /* empty */
    | argument_list
    ;

logical_or_expression:
    logical_or_expression OR logical_and_expression
    | logical_and_expression
    ;

logical_and_expression:
    logical_and_expression AND equality_expression
    | equality_expression
    ;

equality_expression:
    equality_expression EQ relational_expression
    | equality_expression NEQ relational_expression
    | relational_expression
    ;

relational_expression:
    relational_expression GT additive_expression
    | relational_expression LT additive_expression
    | relational_expression GTE additive_expression
    | relational_expression LTE additive_expression
    | additive_expression
    ;

additive_expression:
    additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    | multiplicative_expression
    ;

multiplicative_expression:
    multiplicative_expression MUL unary_expression
    | multiplicative_expression DIV unary_expression
    | unary_expression
    ;

unary_expression:
    PLUS unary_expression
    | MINUS unary_expression
    | NOT unary_expression
    | primary_expression
    ;


primary_expression:
    literal
    | IDENTIFIER
    | LPARAN expression RPARAN
    | function_call %prec LPARAN
    ;

literal:
    NUM
    | TRUE
    | FALSE
    | QUOTES
    ;

%%

namespace parse
{
    void Parser::error(const location& l, const std::string& m)
    {
        std::cerr << l << ": " << m << std::endl;
        driver.error_ = (driver.error_ == 127 ? 127 : driver.error_ + 1);
    }
}
