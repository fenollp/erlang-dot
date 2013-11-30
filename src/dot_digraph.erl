%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(dot_digraph).

%% dot_digraph: DOT <-> Erlang directed graph.

-export([load/1]).
-export([export/1]).

-include("include/dot.hrl").

-type out(Ty) :: {ok, Ty} | {error, term()}.

%% API

-spec load (dot()) -> out(digraph()).
load (AST) ->
    {digraph,_,_Direct,_Name,Assocs} = AST,
    G = digraph:new([]),
    lists:foreach(
      fun ({'->',_,{nodeid,_,A,_,_},{nodeid,_,B,_,_},_}) ->
              A = digraph:add_vertex(G, A),
              B = digraph:add_vertex(G, B),
              ['$e'|_] = digraph:add_edge(G, A, B)
      end, Assocs),
    {ok, G}.

-spec export (digraph()) -> out(dot()).
export (G) ->
    {ok,
     {digraph,1,false,<<>>,
      [ begin
            {E, A, B, _Label} = digraph:edge(G, E),
            {'->',1
            ,{nodeid,1,A,<<>>,<<>>}
            ,{nodeid,1,B,<<>>,<<>>},[]}
        end || E <- lists:sort(digraph:edges(G)) ]}}.

%% Internals

%% End of Module.
