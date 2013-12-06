%% Copyright © 2013 Pierre Fenoll ‹pierrefenoll@gmail.com›
%% See LICENSE for licensing information.
%% -*- coding: utf-8 -*-

-record(dot, { type :: 'graph' | 'digraph'
             , strict :: boolean()
             , name :: binary() | string()
             , parts :: term()
             }).

-type dot() :: #dot{}.

%% End of Header.
