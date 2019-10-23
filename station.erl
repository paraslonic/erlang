-module(station).
-export([start/4, init/4, loop/4]).

start(N, NAME, X1, X2) ->
	io:format("started~n"),
	spawn(?MODULE, init, [N, NAME, X1, X2]).

init(N, NAME, X1, X2) ->
	io:format("inited~n"),
	loop(N, NAME, X1, X2).

loop(N, NAME, X1, X2) ->
	io:format("loop~n"),
	receive
		{qu, pid} -> 
			io:format("qud~n"),
			pid ! qu,
			loop(N, NAME, X1, X2);
		{add, X} ->
			loop(N+X, NAME, X1, X2);
		{report} ->
			io:format("~w : ~w : ~w : ~w. ~n", [N, NAME, X1, X2]),
			loop(N, NAME, X1, X2);
		{stop} ->
			true;
		{is_iam_here, Pid, X} ->
			if(X >= X1, X <= X2) -> Pid ! true;
			Pid ! false.
		{may_i_stop, Pid, X} ->
			if(X == round((X1+X2)/2)) -> Pid ! true;
			Pid ! false.


		_ -> io:format("what?~n")
	end.


