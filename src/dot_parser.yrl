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

Graph ->          GraphTy    '{' StmtList '}'   : {element(1,'$1'),false,    <<>>,flat('$3')}.
Graph -> 'strict' GraphTy    '{' StmtList '}'   : {element(1,'$2'),true,     <<>>,flat('$4')}.
Graph ->          GraphTy id '{' StmtList '}'   : {element(1,'$1'),false,id('$2'),flat('$4')}.
Graph -> 'strict' GraphTy id '{' StmtList '}'   : {element(1,'$2'),true, id('$3'),flat('$5')}.
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

Equality -> id '=' id    : {'=',id('$1'),id('$3')}.

AttrStmt -> 'graph' AttrList    : {'$1','$2'}.
AttrStmt -> 'node'  AttrList    : {'$1','$2'}.
AttrStmt -> 'edge'  AttrList    : {'$1','$2'}.

AttrList -> '['       ']'             : [].
AttrList -> '[' AList ']'             : ['$2'].
AttrList -> '['       ']' AttrList    : '$3'.
AttrList -> '[' AList ']' AttrList    : ['$2'|'$4'].

AList -> Equality              : ['$1'].
AList -> Equality     AList    : ['$1'|'$2'].
AList -> Equality ','          : ['$1'].
AList -> Equality ',' AList    : ['$1'|'$3'].

EdgeStmt -> NodeId   EdgeRHS             : rw_edge({edge,'$1','$2',[]}).
EdgeStmt -> NodeId   EdgeRHS AttrList    : rw_edge({edge,'$1','$2','$3'}).
EdgeStmt -> Subgraph EdgeRHS             :         {edge,'$1','$2',[]}.
EdgeStmt -> Subgraph EdgeRHS AttrList    :         {edge,'$1','$2','$3'}.

EdgeRHS -> EdgeOp NodeId              : {element(1,'$1'),'$2',[]}.
EdgeRHS -> EdgeOp NodeId EdgeRHS      : {element(1,'$1'),'$2','$3'}.
EdgeRHS -> EdgeOp Subgraph            : {element(1,'$1'),'$2',[]}.
EdgeRHS -> EdgeOp Subgraph EdgeRHS    : {element(1,'$1'),'$2','$3'}.
EdgeOp -> '--'    : '$1'.
EdgeOp -> '->'    : '$1'.

NodeStmt -> NodeId             : {node,'$1',[]}.
NodeStmt -> NodeId AttrList    : {node,'$1','$2'}.

NodeId -> id                  : {nodeid,id('$1'),    <<>>,    <<>>}.
NodeId -> id ':' id           : {nodeid,id('$1'),id('$3'),    <<>>}.
NodeId -> id ':' id ':' id    : {nodeid,id('$1'),id('$3'),id('$5')}.

Subgraph ->               '{' StmtList '}'    : {'subgraph',    <<>>,'$2'}.
Subgraph ->            id '{' StmtList '}'    : {'subgraph',id('$1'),'$3'}.
Subgraph -> 'subgraph' id '{' StmtList '}'    : {'subgraph',id('$2'),'$4'}.

%% Number of shift/reduce conflicts
Expect 2.

Erlang code.

id (Id) ->
    element(3, Id).

flat (L) ->
    lists:append(L).

rw_edge (Edge) ->
    case Edge of
        {edge,NodeA,{EdgeOp,NodeB,Rest},Opts} ->
            [{EdgeOp,NodeA,NodeB,Opts} | rw_edge({edge,NodeB,Rest,Opts})];
        _ -> []
    end.


%% End of Parser.
