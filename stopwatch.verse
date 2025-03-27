
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /Verse.org/Random }


stopwatch := class(creative_device):

    
    @editable stop_watch :timer_device = timer_device{}
    @editable b :billboard_device = billboard_device{}
    @editable HD : hud_message_device = hud_message_device{}
    S2M<localizes><public>(Message : string)<computes>:message = "{Message}"


    OnBegin<override>()<suspends>:void={
    }

    Start():void=
        spawn:
            StartStopWatch()

    Stop():void=
        stop_watch.Complete()
        # this should save lap time scoreboard
        # need to pull elapsed time from GetSimulationElapsedTime()
        # then can use the timer to store actual time, but like.. how? 

    StartStopWatch() <suspends> : void =
        var Hours : int = 0
        var Minutes : int = 0
        var Seconds : int = 0
        var Milliseconds : int = 0
        loop:
            Sleep(0.1)
            if(Minutes >= 3):
                HD.SetText(S2M("03:00:00+"))
                break
            set Milliseconds += 1
            if (Milliseconds >= 10):  
                # 100 milliseconds == 1 second, 10 because sleeping for 0.01 or faster isn't functional
                set Milliseconds = 0
                set Seconds += 1
                if (Seconds >= 60):
                    set Seconds = 0
                    set Minutes += 1
                    if (Minutes >= 60):
                        set Minutes = 0
                        set Hours += 1
            var HudMessage : string = ""
            # set HudMessage = "{Hours}"
            if (Minutes < 10):
                set HudMessage += "0{Minutes}"
            else:
                set HudMessage += ":{Minutes}"
            if (Seconds < 10):
                set HudMessage += ":0{Seconds}"
            else:
                set HudMessage += ":{Seconds}"
            if (Milliseconds < 10):
                set HudMessage += ":{Milliseconds}{GetRandomInt(0,9)}{GetRandomInt(0,9)}"
            else:
                set HudMessage += ":{Milliseconds}"
            HD.SetText(S2M(HudMessage))



