-module(mir).
-compile(export_all).

init() ->
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
	W!{try_move, 1},
	{C1,C2,C3, W}.

%{C1, C2, C3, W} = mir:init()
