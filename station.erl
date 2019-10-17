-module(station).
-export([start/0, init/0, loop/1]).

start() ->
	io:format("started~n"),
	spawn(?MODULE, init, []).

init() ->
	io:format("inited~n"),
	N = 0,
	loop(N).

loop(N) ->
	io:format("loop~n"),
	receive
		{qu, pid} -> 
			io:format("qud~n"),
			pid ! qu,
			loop(N);
		{add, X} ->
			loop(N+X);
		{report} ->
			io:format("N = ~w. ~n", [N]),
			loop(N);
		{stop} ->
			true;
		_ -> io:format("what?~n")
	end.


