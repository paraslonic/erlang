-module(router).
-export([start/0, loop/1, print_list/1, map/2, train_spot/1]).


start() ->
	A = station:start(a, 1, 3),
	B = station:start(b, 11, 13),
	Stations = [A, B],
	register(spotter, spawn(router, train_spot, [Stations])),
	register(router, spawn(router, loop, [Stations])).

train_spot(Stations) ->
	receive
		{spot,Pid, X} ->
			%io:format("~p ~p ~n", [Pid, X]),
			map(fun(S) -> S ! {is_iam_here, Pid, X} end, Stations),
	  		train_spot(Stations);
		{train_at_station, Station, Train} ->
			io:format("train ~p is at ~p~n",[Train, Station]),
			train_spot(Stations);
		
		{train_arrived, Station, Train} ->
			io:format("train ~p arrived at ~p~n",[Train, Station]),
			Train ! {stop, 5000},
			train_spot(Stations);

		stop -> true;
		_ -> io:format("what?"), train_spot(Stations)
		
	end.
loop(Stations) ->
	receive
		{report} ->
			map(fun(X) -> X ! {report} end, Stations),
			%print_list(Stations),
			loop(Stations);
		stop -> true;
		_ -> io:format("what?~n")
	end.


print_list(L) ->
	case L of 
		[] ->	io:format("~n");
		[H|T] -> 
			io:format("~w : ", [H]),
			print_list(T)
	end.


map(F,[]) ->
	[];
map(F,[X|Xs]) ->
	[F(X) | map(F,Xs)].
