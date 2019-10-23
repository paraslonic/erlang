-module(router).
-export([start/0, loop/1, print_list/1, map/2, train_spot/0]).


start() ->
	register(spotter, spawn(router, train_spot, [])),
	A = station:start(5, a, 1, 3),
	B = station:start(5, b, 11, 13),
	Stations = [A, B, C, D],
	register(router, spawn(router, loop, [Stations])).

train_spot() ->
	receive
		{spot,Pid, X} ->
			io:format("~p ~p ~n", [Pid, X]),
			S = hd(Stations),
		       	Result = S!{is_iam_here, Pid, X},
			io:format("~p			train_spot().			


		stop -> true;
		_ -> io:format("what?"), train_spot()
		
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
