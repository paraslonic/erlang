-module(volf).
-compile(export_all).

-record(vstate, {place, food}).

init() ->  % startfood, childingage, 
	S=#vstate{food=5},
	VPID=spawn(volf, loop, [S]),
	Childingage=10000,
	erlang:send_after(Childingage, VPID, givebirth),
	erlang:send_after(10, VPID, {trymove, rand:uniform(4)}),
	erlang:send_after(60000, VPID, stop),
	monitor!{add, VPID},
	VPID.

loop(S) when is_record(S, vstate) ->
	receive
		givebirth ->
			VPID=init(),
			VPID!{locate, S#vstate.place},
			loop(S);
		{trymove, DIR} ->
			io:format("trymove ~p~n",[self()]),
			case S#vstate.place of
				undefined ->
					loop(S);
				_ ->
					io:format("volf move from ~p~n",[S#vstate.place]),
					S#vstate.place ! {move, volf, self(), DIR},
					erlang:send_after(200, self(), {trymove, rand:uniform(4)}),
					loop(S)
			end;
		{locate, CPID} ->
			NewS= S#vstate{place=CPID},
			io:format("located to ~p ~n", [NewS#vstate.place]),
			loop(NewS);

		stop ->
			true
	end.
