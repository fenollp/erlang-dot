%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-
-module(dot).

%% dot: erlang-dot library's entry point.

-export([from_string/1]).
-export([  to_string/1]).
-export([from_file/1]).
-export([  to_file/2]).

-include("include/dot.hrl").

-type out(Ty) :: {ok, Ty} | {error, term()}.
-type out(  ) ::  ok      | {error, term()}.

%% API

-spec from_string (string()) -> out(dot()).
from_string (String) ->
    case scan(String) of
        {ok, Tokens, _Loc} ->
            case parse(Tokens) of
                {ok, AST} ->
                    {ok, AST};
                Reason ->
                    {error, Reason}
            end;
        {error, SyntaxError, _Loc} ->
            {Line, _Lexer, Descr} = SyntaxError,
            [Msg, L] = dot_lexer:format_error(Descr),
            {error, {syntax_error, Line, Msg, L}}
    end.

-spec to_string (dot()) -> out(string()).
to_string (AST) ->
    {ok, tostring(AST)}.

-spec from_file (file:name()) -> out(dot()).
from_file (Filename) -> %TODO: parse while reading file: best for huge files.
    {ok, Dev} = file:open(Filename, [read,unicode]),
    String = assemble_lines(Dev, []),
    ?MODULE:from_string(String).

-spec to_file (file:name(), dot()) -> out().
to_file (Filename, AST) ->
    {ok, String} = ?MODULE:to_string(AST),
    file:write_file(Filename, String).

%% Internals

assemble_lines (Dev, Acc) ->
    case file:read_line(Dev) of
        {ok, Line} ->
            assemble_lines(Dev, [Line|Acc]);
        eof ->
            ok = file:close(Dev),
            lists:reverse(Acc)
    end.

scan (Str) ->
    dot_lexer:string(Str).
parse (Tokens) ->
    dot_parser:parse(Tokens).

tostring ({GraphTy,_,Direct,Name,Edges}) ->
    [ case GraphTy of
          'digraph' -> "digraph ";
          'graph'   -> "graph "
      end
    , case Direct of true -> "direct "; false -> "" end
    , Name, " {\n"
    ,[case Op of
          '--' -> [$\t, A, " -- ", B, assocs(Opts), ";\n"];
          '->' -> [$\t, A, " -> ", B, assocs(Opts), ";\n"]
      end || {Op,_,{nodeid,_,A,_,_},{nodeid,_,B,_,_},Opts} <- Edges]
    , "}\n"
    ];
tostring ({'=',_,Lhs,Rhs}) ->
    [Lhs, "=", Rhs];
tostring (A) when is_list(A) ->
    [tostring(X) || X <- A].

assocs ([]) ->
    [];
assocs (Opts) ->
    [" [", string:join([tostring(Opt) || Opt <- Opts], ", "), $]].

%% End of Module.
