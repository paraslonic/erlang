-module(mir).
-compile(export_all).

init() ->
	register(monitor, spawn(mir, monitorloop, [])),
	C1=cell:init(),
	C2=cell:init(),
	C3=cell:init(),
	C1!{link, C2, 2},
	C2!{link, C3, 2},
	C3!{link, C1, 2},
	C1!{link, C3, 1},
	C2!{link, C1, 1},
	C3!{link, C2, 1},
	W=volf:init(),
	W!{locate, C2},
	{C1,C2,C3, W}.


monitorloop() ->
	receive
		{'DOWN', _Ref, process, Pid, Reason} ->
			 io:format("~p exited with ~p ~n",[Pid, Reason]),
			monitorloop();
		{add, PID} -> erlang:monitor(process, PID), monitorloop()
	end.


%{C1, C2, C3, W} = mir:init()
