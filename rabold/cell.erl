-module(cell).
-compile(export_all).

-record(state, {n,v=[],z=[]}).

init() ->
	S=#state{n=#{1=>0, 2=>0}},
	CPID=spawn(cell, loop, [S]),
	monitor ! {add, CPID},
	CPID.

print_state(S) ->
	io:format("volves: ~p~n",[S#state.v]).


loop(S) when is_record(S,state) ->
	receive
		{add, volf, VPID} ->
			V=S#state.v,
			NewS=S#state{v=[VPID|V]},
			io:format("added volf, current volves: ~p~n",[NewS#state.v]),
			VPID!{locate, self()},
			loop(NewS);
		{add, zay, ZPID} ->
			Z=S#state.z,
			NewS=S#state{z=[ZPID|Z]},
			ZPID!{locate, self()},
			io:format("added zay, current: ~p~n",[NewS#state.z]),
			loop(NewS);
		{move, ZVER, PID, DIR} -> 
			case maps:find(DIR, S#state.n) of
				{ok, C}->
					case ZVER of
						zay->
							C!{add, zay, PID},
							NewS=S#state{v=lists:delete(PID,S#state.z)};
						volf->	
							C!{add, volf, PID},
							NewS=S#state{v=lists:delete(PID,S#state.v)}
					end,
					loop(NewS);
				_ -> loop(S)
			end;
		{link, CPID, DIR} -> 
			NewS=S#state{n=maps:put(DIR, CPID, S#state.n)},
			loop(NewS);
		{print, n, Key} ->
			io:format("neighbour ~p~n",[maps:get(Key, S#state.n)]);
		
		stop ->
			true
	end.



