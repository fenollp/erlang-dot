%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-

%% This is a Leex file. Set coloration to Erlang to keep your eyes from burning.

Definitions.

A = [Aa]
B = [Bb]

Rules.
%% Note: rule order matters.

{S}{T}{R}{I}{C}{T}      : {token,{'strict',TokenLine}}.
{G}{R}{A}{P}{H}         : {token,{'graph',TokenLine}}.
{D}{I}{G}{R}{A}{P}{H}   : {token,{'digraph',TokenLine}}.

{N}{O}{D}{E}   : {token,{'node',TokenLine}}.
{E}{D}{G}{E}   : {token,{'edge',TokenLine}}.

{S}{U}{B}{G}{R}{A}{P}{H}    : {token,{'subgraph',TokenLine}}.

\;          : {token,{';',TokenLine}}.
\,          : {token,{',',TokenLine}}.
\:          : {token,{':',TokenLine}}.
\=          : {token,{'=',TokenLine}}.

\{          : {token,{'{',TokenLine}}.
\[          : {token,{'[',TokenLine}}.
\]          : {token,{']',TokenLine}}.
\}          : {token,{'}',TokenLine}}.

Erlang code.

%% End of Lexer.
