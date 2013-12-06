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
      fun
          ({node,{nodeid,N,_,_},Opts}) ->
              Label = [{Key,Value} || {'=',Key,Value} <- Opts],
              digraph:add_vertex(G, N, Label);
          ({'->',{nodeid,A,_,_},{nodeid,B,_,_},_}) ->
              ['$e'|_] = digraph:add_edge(G, A, B)
      end,
      lists:sort(fun erlang:'<'/2, Assocs)),
    {ok, G}.

-spec export (digraph()) -> out(dot()).
export (G) ->
    {ok,
     {digraph,false,<<>>,
      [ begin
            {V, Label} = digraph:vertex(G, V),
            {node,{nodeid,V,<<>>,<<>>},
             [{'=', case Key of
                        K when is_atom(K) ->
                            atom_to_list(K);
                        _ ->
                            Key
                    end, Value} || {Key,Value} <- Label]
            }
        end || V <- digraph:vertices(G) ]
      ++
      [ begin
            {E, A, B, _Label} = digraph:edge(G, E),
            {'->'
            ,{nodeid,A,<<>>,<<>>}
            ,{nodeid,B,<<>>,<<>>},[]}
        end || E <- digraph:edges(G) ]}}.

%% Internals

%% End of Module.
