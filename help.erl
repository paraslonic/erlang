-module(help).
-compile(export_all).

sleep(Time) ->
        receive
        after Time ->
                      true
        end.

send_after(Pid, M, Time) ->
        sleep(Time),
        Pid ! M.
