-module(station).
-export([start/3, init/3, loop/5, adduniq/2]).

start(NAME, X1, X2) ->
	io:format("started~n"),
	spawn(?MODULE, init, [NAME, X1, X2]).

init(NAME, X1, X2) ->
	io:format("inited~n"),
	loop(NAME, X1, X2, [],[]).

loop(NAME, X1, X2, Tvis, Tstop) ->
	receive
		{stop} ->
			true;
		{is_iam_here, Pid, X} ->
			if
				X == X1 ->
					spotter ! {train_arrived, NAME, Pid},
					loop(NAME, X1, X2, Tvis--[Pid], adduniq(Pid, Tstop));
				X > X1 andalso X < X2 ->
					spotter ! {train_at_station, NAME, Pid},
					loop(NAME, X1, X2, adduniq(Pid, Tvis), Tstop--[Pid]);
				true ->	 
					loop(NAME, X1, X2, Tvis--[Pid], Tstop--[Pid])
			end;

		_ -> io:format("what?~n")
	end.

adduniq(X,[]) -> [X];

adduniq(X, L) ->
	case lists:member(X,L) of
		true -> [X|L];
		false -> L
	end.
