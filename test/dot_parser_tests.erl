%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(dot_parser_tests).

%% dot_parser_tests: tests for module dot_parser.

-include_lib("eunit/include/eunit.hrl").


%% API tests.

parse_wikipedia_digraph_test () ->
    ?assertMatch({ok,{digraph,_,false,<<"graphname">>,
             [{'->',_,
                    {nodeid,_,<<"a">>,<<>>,<<>>},
                    {nodeid,_,<<"b">>,<<>>,<<>>},
                    [[{'=',_,<<"c">>,<<"l">>}]]},
              {'->',_,
                    {nodeid,_,<<"b">>,<<>>,<<>>},
                    {nodeid,_,<<"c">>,<<>>,<<>>},
                    [[{'=',_,<<"c">>,<<"l">>}]]},
              {'->',_,
                    {nodeid,_,<<"b">>,<<>>,<<>>},
                    {nodeid,_,<<"d">>,<<>>,<<>>},
                    [[{'=',_,<<"color">>,<<"blue">>}]]}]}},
                 dot:from_string("
digraph graphname {
     a -> b -> c [c=l];
     b -> d [color=blue];
 } ")).

reparse_wikipedia_digraph_test () ->
    {ok, AST} = dot:from_string("digraph graphname {
        a -> b -> c [c=l];
        b -> d [color=blue];
    } "),
    {ok, Str} = dot:to_string(AST),
    Got = lists:flatten(io_lib:format("~s", [Str])),
    ?assertMatch(Got,
        "digraph graphname {\n"
        "\ta -> b [c=l];\n"
        "\tb -> c [c=l];\n"
        "\tb -> d [color=blue];\n"
        "}\n").

%% Internals

%% End of Module.
