#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname factorial -mnesia debug verbose
main(_) ->
    try
        C = count_chars:file1("count_chars.erl"),
        %C = 1,
        io:format("count=~w", [C])
    catch
        _:_ ->
            usage()
    end.

usage() ->
    io:format("usage: factorial integer\n"),
    halt(1).

