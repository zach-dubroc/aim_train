
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


stopwatch := class(creative_device):

    @editable stop_watch :timer_device = timer_device{}

    OnBegin<override>()<suspends>:void=

        Start()

    Start():void=
        Print("time start")
#this should start a stopwatch
#runs until user end(et_device in game_manage)
#->users time will go into the leaderboard
#->if user lowers their times, old time should be replaced/hidden/deleted?