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
		{puk, Pid} -> 
			io:format("PUUUUK!~n"),
			Pid ! qu,
			loop(N);
		{add, X} ->
			loop(N+X);
		{ups, P} ->
			P ! vay,
			loop(N);
		{report} ->
			io:format("N = ~w. ~n", [N]),
			loop(N);
		{stop} ->
			true;
		_ -> io:format("what?~n"), loop(N)
	end.


