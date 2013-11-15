grammar gcl;

options{
    language = Java;
    output=CommonTree;
}

@header{
    package gclSpecification;
}

@lexer::header{
    package gclSpecification;
}

program:
    module+;
  
module:
    'module' IDENTIFIER 
        definitionPart
    'private'
        block
    '.';

block:
    definitionPart
    'begin'
        statementPart
    'end';
    
definitionPart:
    (definition ';')*;

definition:
    constantDefinition | variableDefinition | (procedureDefinition) | typedef ;//| procedureDeclaration;

constantDefinition:
    'const' constantName '=' constant;

variableDefinition:
   type variableList;
   
type:
    (typeSymbol (arrayType | rangeType)? ) | tupleType;

typeSymbol:
    'integer' | 'boolean' | IDENTIFIER;

tupleType:
    '[' typeSymbol (',' typeSymbol)* ']';

arrayType:
    'array' ('[' IDENTIFIER ']')+;
    
rangeType:
    'range' '[' constant '..' constant ']';

variableList:
    IDENTIFIER (',' IDENTIFIER)*;
    
typedef:
    'typedef' type IDENTIFIER;

procedureDefinition:
    procedureDeclaration block;
    
procedureDeclaration:
    'proc' IDENTIFIER parameterPart;  //TODO change proc to procedure

    
parameterPart:
    '(' (parameterDefinition (';' parameterDefinition)*)? ')';

parameterDefinition:
    ('val'|'ref') variableDefinition;

statementPart:
    (statement ';')*;

statement:
    emptyStatement | readStatement | writeStatement | assignStatement | returnStatement | callStatement | ifStatement | doStatement | forStatement;
    
emptyStatement:
    'skip';
    
readStatement:
    'read' variableAccessList;
    
variableAccessList:
    variableAccess (',' variableAccess)*;
    
writeStatement:
    'write' writeItem (',' writeItem);
    
writeItem:
    //(STRINGLITERAL | expression)(','((STRINGLITERAL | expression))*);
    (STRINGLITERAL | expression);

expressionList:
    expression (',' expression)*;
    
assignStatement:
    variableAccessList ':=' expressionList;
    
ifStatement:
    'if' guardedCommandList 'fi';
    
guardedCommandList:
    guardedCommand ('[]' guardedCommand)*;

guardedCommand:
    expression '->' statementPart;

doStatement:
    'do' guardedCommandList 'od';
    
forStatement:
    'forall' variableAccess '->' statementPart 'llarof';

returnStatement:
    'return' expression;
    
callStatement:
    IDENTIFIER ('.' IDENTIFIER)? argumentList;
    
argumentList:
    '(' (expressionList)? ')';
    
expression:
    relationExpression (booleanOperator relationExpression)*;
    
booleanOperator:
    '&' | '|';
    
relationExpression:
    simpleExpression (relationOperator simpleExpression)?;

relationOperator:
    '<' | '=' | '>' | '<=' | '>=' | '#';
    
simpleExpression:
    (('+' | '-') term (addingOperator term)*)|(term (addingOperator term)*); //TODO check
    //(('+' | '-')? term (addingOperator term)*);//|(term (addingOperator term)*); //TODO check
    
term:
    factor (multiplyOperator factor)*;
    
factor:
    variableAccess | INTEGER | booleanConstant | ('['expressionList']') | ('~' factor);
    
addingOperator:
    '+' | '-';

multiplyOperator:
    '*' | '/' | '\\'; 

constantName:
    IDENTIFIER;

variableAccess:
    IDENTIFIER variableMore;
    
variableMore:
    (('['expression']') | indexOrComp | ('.' nextItem indexOrComp));
    
nextItem:
    INTEGER | IDENTIFIER;

indexOrComp:
    (('.' INTEGER) | ('['']')*);

constant:
    expression;
    
booleanConstant:
    'true' | 'false'; 

fragment LETTER:
    ('a'..'z')|('A'..'Z');
    
fragment DIGIT:
    '0'..'9';
    
IDENTIFIER: 
  LETTER+;

INTEGER: 
  DIGIT+;

STRINGLITERAL:
    '\'' ~('\n'|'\r')* '\'';

WS :
    (' ' | '\t' | '\n' | '\r' | '\f')+ {$channel = HIDDEN;};
    
LINE_COMMENT:
    '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;};