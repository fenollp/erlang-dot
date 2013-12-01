%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(dot_digraph_tests).

%% dot_digraph_tests: tests for module dot_digraph.

-include_lib("eunit/include/eunit.hrl").


%% API tests.

load_export_test () ->
    {ok,A} = dot:from_string("digraph { a -> b -> c; b -> d; }"),
    {ok,G} = dot_digraph:load(A),
    ?assertEqual({ok,{digraph,false,<<>>,
             [{'->',
                    {nodeid,<<"a">>,<<>>,<<>>},
                    {nodeid,<<"b">>,<<>>,<<>>},
                    []},
              {'->',
                    {nodeid,<<"b">>,<<>>,<<>>},
                    {nodeid,<<"c">>,<<>>,<<>>},
                    []},
              {'->',
                    {nodeid,<<"b">>,<<>>,<<>>},
                    {nodeid,<<"d">>,<<>>,<<>>},
                    []}]}},
        dot_digraph:export(G)).

%% Internals

%% End of Module.
