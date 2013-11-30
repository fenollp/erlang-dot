%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-

Nonterminals
Graph GraphTy StmtList Stmt NodeStmt EdgeStmt AttrStmt Equality Subgraph
AttrList AList NodeId EdgeRHS EdgeOp
.

Terminals
'strict' 'graph' 'digraph' 'node' 'edge' 'subgraph'
';' ',' ':' '=' '{' '[' ']' '}'
id
'--' '->'
.

Rootsymbol Graph.

Graph ->          GraphTy    '{' StmtList '}'   : {'$1',loc('$1'),false,    <<>>,'$3'}.
Graph -> 'strict' GraphTy    '{' StmtList '}'   : {'$2',loc('$2'),true,     <<>>,'$4'}.
Graph ->          GraphTy id '{' StmtList '}'   : {'$1',loc('$1'),false,id('$2'),'$4'}.
Graph -> 'strict' GraphTy id '{' StmtList '}'   : {'$2',loc('$2'),true, id('$3'),'$5'}.
GraphTy -> 'graph'      : '$1'.
GraphTy -> 'digraph'    : '$1'.

StmtList -> Stmt                 : ['$1'].
StmtList -> Stmt     StmtList    : ['$1'|'$2'].
StmtList -> Stmt ';'             : ['$1'].
StmtList -> Stmt ';' StmtList    : ['$1'|'$3'].

Stmt -> NodeStmt    : '$1'.
Stmt -> EdgeStmt    : '$1'.
Stmt -> AttrStmt    : '$1'.
Stmt -> Equality    : '$1'.
Stmt -> Subgraph    : '$1'.

Equality -> id '=' id    : {'=',loc('$2'),id('$1'),id('$3')}.

AttrStmt -> 'graph' AttrList    : {'$1',loc('$1'),'$2'}.
AttrStmt -> 'node'  AttrList    : {'$1',loc('$1'),'$2'}.
AttrStmt -> 'edge'  AttrList    : {'$1',loc('$1'),'$2'}.

AttrList -> '['       ']'             : [].
AttrList -> '[' AList ']'             : ['$2'].
AttrList -> '['       ']' AttrList    : '$3'.
AttrList -> '[' AList ']' AttrList    : ['$2'|'$4'].

AList -> Equality              : ['$1'].
AList -> Equality     AList    : ['$1'|'$2'].
AList -> Equality ','          : ['$1'].
AList -> Equality ',' AList    : ['$1'|'$3'].

EdgeStmt -> NodeId   EdgeRHS             : {edge,loc('$2'),'$1','$2',[]}.
EdgeStmt -> NodeId   EdgeRHS AttrList    : {edge,loc('$2'),'$1','$2','$3'}.
EdgeStmt -> Subgraph EdgeRHS             : {edge,loc('$2'),'$1','$2',[]}.
EdgeStmt -> Subgraph EdgeRHS AttrList    : {edge,loc('$2'),'$1','$2','$3'}.

EdgeRHS -> EdgeOp NodeId              : {element(1,'$1'),loc('$1'),'$2',[]}.
EdgeRHS -> EdgeOp NodeId EdgeRHS      : {element(1,'$1'),loc('$1'),'$2','$3'}.
EdgeRHS -> EdgeOp Subgraph            : {element(1,'$1'),loc('$1'),'$2',[]}.
EdgeRHS -> EdgeOp Subgraph EdgeRHS    : {element(1,'$1'),loc('$1'),'$2','$3'}.
EdgeOp -> '--'    : '$1'.
EdgeOp -> '->'    : '$1'.

NodeStmt -> NodeId             : {node,loc('$1'),'$1',[]}.
NodeStmt -> NodeId AttrList    : {node,loc('$1'),'$1','$2'}.

NodeId -> id                  : {nodeid,loc('$1'),id('$1'),    <<>>,     <<>>}.
NodeId -> id ':' id           : {nodeid,loc('$1'),id('$1'),id('$3'),     <<>>}.
NodeId -> id ':' id ':' id    : {nodeid,loc('$1'),id('$1'),id('$3'),id('$5')}.

Subgraph ->               '{' StmtList '}'    : {'subgraph',loc('$1'),    <<>>,'$2'}.
Subgraph ->            id '{' StmtList '}'    : {'subgraph',loc('$2'),id('$1'),'$3'}.
Subgraph -> 'subgraph' id '{' StmtList '}'    : {'subgraph',loc('$3'),id('$2'),'$4'}.

%% Number of shift/reduce conflicts
Expect 2.

Erlang code.

id (Id) ->
    element(3, Id).

loc (T) when is_tuple(T) ->
    element(2, T);
loc (R) ->
    R.

%% End of Parser.
