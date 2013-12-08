%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(dot_parser_tests).

%% dot_parser_tests: tests for module dot_parser.

-include_lib("eunit/include/eunit.hrl").


%% API tests.

parse_wikipedia_digraph_test () ->
    ?assertEqual({ok,{dot,digraph,false,<<"graphname">>,
             [{'->',
                    {nodeid,<<"a">>,<<>>,<<>>},
                    {nodeid,<<"b">>,<<>>,<<>>},
                    [{'=',<<"c">>,<<"l">>}]},
              {'->',
                    {nodeid,<<"b">>,<<>>,<<>>},
                    {nodeid,<<"c">>,<<>>,<<>>},
                    [{'=',<<"c">>,<<"l">>}]},
              {'->',
                    {nodeid,<<"b">>,<<>>,<<>>},
                    {nodeid,<<"d">>,<<>>,<<>>},
                    [{'=',<<"color">>,<<"blue">>}]}]}},
                 dot:from_string("
digraph graphname {
     a -> b -> c [c=l];
     b -> d [color=blue];
 } ")).

reparse_wikipedia_digraph_test () ->
    Digraph = "digraph graphname {\n"
        "\ta -> b [c=l];\n"
        "\tb -> c [c=l];\n"
        "\tb -> d [color=blue];\n"
        "}\n",
    {ok, AST} = dot:from_string(Digraph),
    {ok, Str} = dot:to_string(AST),
    Got = lists:flatten(io_lib:format("~s", [Str])),
    ?assertEqual(Got, Digraph).

%% Internals

%% End of Module.
