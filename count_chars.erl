-module(count_chars).
-export([file/1]).

% 
% try to open file, if ok - do scan_file function, otherwise - report back error
%
file(Fname) ->
    case file:open(Fname, [read, raw, binary]) of
 {ok, Fd} ->
     scan_file(Fd, 0, file:read(Fd, 1024));
 {error, Reason} ->
     {error, Reason}
    end.


% 
% if ok. Binary - continue with incremented counter and nest data block
% if file ended - close file and echo result to screen
% if error - report error
%
scan_file(Fd, Occurs, {ok, Binary}) ->
    scan_file(Fd, Occurs + count_x(Binary), file:read(Fd, 1024));
scan_file(Fd, Occurs, eof) ->
    file:close(Fd),
    Occurs;
scan_file(Fd, _Occurs, {error, Reason}) ->
    file:close(Fd),
    {error, Reason}.

% 
% To calc count - call new func with 2 args
%
count_x(Bin) ->
    count_x(binary_to_list(Bin), 0).

% 
% 1. If list(string as list) is like "x, ...." - increment Ack and call for tail
% 2. Any other case but not eof - just continue with tail
% 3. If empty - exho calculated Ack ("x" count)
%
% Not understand
count_x([$x|Tail], Ack) ->
    count_x(Tail, Ack+1);
count_x([_|Tail], Ack) ->
    count_x(Tail, Ack);
count_x([], Ack) ->
    Ack.

