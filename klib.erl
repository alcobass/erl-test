-module(klib).
%% My very own lib of nice to have functions.


-export([with_file/3]).
%-export([i32/1, getint32/1]).
%-export([bits/1, bits/2, hex/1, hex/2]).
%-export([with_socket/2,  sock_status/1]).



%% internal exports
%-export([with_socket0/2, sock_handler/3]).


%% A general purpose with_file function

with_file(File, Fun, Initial) ->
    case file:open(File, [read, raw, binary]) of
    {ok, Fd} ->
        Res = feed(Fd, file:read(Fd, 1024), Fun, Initial),
        file:close(Fd),
        Res;
    {error, Reason} ->
        {error, Reason}
    end.
 
feed(Fd, {ok, Bin}, Fun, Farg) ->
    case Fun(Bin, Farg) of
    {done, Res} ->
        Res;
    {more, Ack} ->
        feed(Fd, file:read(Fd, 1024), Fun, Ack)
    end;
feed(_Fd, eof, _Fun, Ack) ->
    Ack;
feed(_Fd, {error, Reason}, _Fun, _Ack) ->
    {error, Reason}.
