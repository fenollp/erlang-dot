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
    {digraph,_Direct,_Name,Assocs} = AST,
    G = digraph:new([]),
    lists:foreach(
      fun ({'->',{nodeid,A,_,_},{nodeid,B,_,_},_}) ->
              A = digraph:add_vertex(G, A),
              B = digraph:add_vertex(G, B),
              ['$e'|_] = digraph:add_edge(G, A, B)
      end, Assocs),
    {ok, G}.

-spec export (digraph()) -> out(dot()).
export (G) ->
    {ok,
     {digraph,false,<<>>,
      [ begin
            {E, A, B, _Label} = digraph:edge(G, E),
            {'->'
            ,{nodeid,A,<<>>,<<>>}
            ,{nodeid,B,<<>>,<<>>},[]}
        end || E <- lists:sort(digraph:edges(G)) ]}}.

%% Internals

%% End of Module.
