%{                                                            /* -*- C++ -*- */

#include "parser.hpp"
#include "scanner.h"
#include "driver.h"
#include <iostream>
#include <memory>

extern std::unique_ptr<std::string> identiferVal;

/*  Defines some macros to update locations */


#define STEP()                                      \
  do {                                              \
    yylloc->step ();                      \
  } while (0)

#define COL(Col)				                            \
  yylloc->columns (Col)

#define LINE(Line)				                          \
  do{						                                    \
    yylloc->lines (Line);		              \
 } while (0)

#define YY_USER_ACTION				                      \
  COL(yyleng);


typedef parse::Parser::token token;
typedef parse::Parser::token_type token_type;

#define yyterminate() return token::TOK_EOF

%}

%option debug
%option c++
%option noyywrap
%option never-interactive
%option yylineno
%option nounput
%option batch
%option prefix="parse"


%%

[ \n]           { }
"#".*           { 
                  // identiferVal = std::make_unique<std::string>(yytext , yyleng);
                  // identiferVal->insert(0 , "Comment : ");
                  // return token::ONE_LINE_COMMENT; 
                }
"import"        { return token::IMPORT; }
"if"            { return token::IF; }
"else"          { return token::ELSE; }
"while"         { return token::WHILE; }
"for"           { return token::FOR; }
"in"            { return token::IN; }
"break"         { return token::BREAK; }
"and"           { return token::AND; }
"or"            { return token::OR; }
"not"           { return token::NOT; }
"print"         { return token::PRINT; }
"def"           { return token::DEF; }
"return"        { return token::RETURN; }
"True"          { return token::TRUE; }
"False"         { return token::FALSE; }
[0-9]+          { 
                  identiferVal = std::make_unique<std::string>(yytext , yyleng);
                  return token::NUM; 
                }
[a-zA-Z_][a-zA-Z0-9_]*  { 
                          identiferVal = std::make_unique<std::string>(yytext , yyleng);
                          return token::IDENTIFIER;
                        }
"=="            { return token::EQ; }
"!="            { return token::NEQ; }
">"             { return token::GT; }
"<"             { return token::LT; }
">="            { return token::GTE; }
"<="            { return token::LTE; }
"="             { return token::ASSIGN; }
"+"             { return token::PLUS; }
"-"             { return token::MINUS; }
"*"             { return token::MUL; }
"/"             { return token::DIV; }
"("             { return token::LPARAN; }
")"             { return token::RPARAN; }
"{"             { return token::LBRACE; }
"}"             { return token::RBRACE; }
[\"].*[\"]      {
                  identiferVal = std::make_unique<std::string>(yytext , yyleng); 
                  return token::QUOTES; 
                }
":"             { return token::COLON; }
";"             { return token::SEMICOLON; }
","             { return token::COMMA; }
"["             { return token::OB; }
"]"             { return token::CB; }
.               { return token::ERROR; }

<<EOF>> { return token::EOF_; }

%%


/*

   CUSTOM C++ CODE

*/

namespace parse
{

    Scanner::Scanner()
    : parseFlexLexer()
    {
    }

    Scanner::~Scanner()
    {
    }

    void Scanner::set_debug(bool b)
    {
        yy_flex_debug = b;
    }
}

#ifdef yylex
# undef yylex
#endif

int parseFlexLexer::yylex()
{
  std::cerr << "call parsepitFlexLexer::yylex()!" << std::endl;
  return 0;
}
