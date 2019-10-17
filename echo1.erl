-module(echo1).
-export([go/0, init/0, loop/1]).


go() ->
	spawn(echo1, init, []).

init() ->
	loop(0).

loop(N) ->
	receive
		{add, X} ->
			loop(N+X);
		{report} ->
			io:format("N = ~p ~n", [N]),
			loop(N);
		stop ->
			true
	end.
