
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /Verse.org/Random }


stopwatch := class(creative_device):
    @editable rm :race_manager_device = race_manager_device{}

    @editable b :billboard_device = billboard_device{}
    @editable HD : hud_message_device = hud_message_device{}
    S2M<localizes><public>(Message : string)<computes>:message = "{Message}"
    var elap_time :float = 0.0
    var time_diff :float = 0.0

    OnBegin<override>()<suspends>:void={
    }

    Start():void=
        rm.Begin()
        

    Stop():void=
        rm.End()
        # need the laptime saved/leaderboard updated here