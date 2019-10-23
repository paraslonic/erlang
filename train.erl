-module(train).
-export([start/3, loop/3]).
-import(help, [sleep/1, send_after/3]).

start(X, Dir, Xmax) ->
	spawn(train, loop, [X, Dir, Xmax]).


loop(X, Dir, Xmax) ->
	if
		X > Xmax -> loop(X-1, -Dir, Xmax);
		X < 0 -> loop(0, -Dir, Xmax);
		true -> true
	end,
	receive
		{stop, Time} ->
			sleep(Time);
		stop ->
			true
		
	after 1000 ->
		%io:format("~p : ~p : ~p ~n", [X, Dir, Xmax]),
		spotter ! {spot, self(), X},
		loop(X+Dir, Dir, Xmax)
	end.
