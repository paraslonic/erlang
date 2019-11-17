-module(cell).
-compile(export_all).

-record(state, {n,v=[],z=[]}).

init() ->
	S=#state{n=#{1=>0, 2=>0}},
	spawn(cell, loop, [S]).

print_state(S) ->
	io:format("volves: ~p~n",[S#state.v]).




loop(S) when is_record(S,state) ->
	receive
		{add, volf, VPID} ->
			V=S#state.v,
			NewS=S#state{v=[VPID|V]},
			io:format("~p~n",[NewS#state.v]),
			loop(NewS);
		{add, zay, ZPID} ->
			Z=S#state.z,
			NewS=S#state{z=[ZPID|Z]},
			io:format("~p~n",[NewS#state.z]),
			loop(NewS);
		{move, volf, VPID, DIR} -> 
			case maps:find(DIR, S#state.n) of
				{ok, C}->
					C!{add, volf, VPID},
					NewS=S#state{v=lists:delete(VPID,S#state.v)},
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



