-module(station).
-export([start/4, init/4, loop/4]).

start(N, NAME, X1, X2) ->
	io:format("started~n"),
	spawn(?MODULE, init, [N, NAME, X1, X2]).

init(N, NAME, X1, X2) ->
	io:format("inited~n"),
	loop(N, NAME, X1, X2).

loop(N, NAME, X1, X2) ->
	receive
		{add, X} ->
			loop(N+X, NAME, X1, X2);
		{stop} ->
			true;
		{is_iam_here, Pid, X} ->
			case(X >= X1 andalso X =< X2) of
				true -> spotter ! {train_at_station, NAME, Pid};
				_Else -> false
			end,
			loop(N, NAME, X1, X2);

		_ -> io:format("what?~n")
	end.


