
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /Verse.org/Random }


stopwatch := class(creative_device):
    @editable rm :race_manager_device = race_manager_device{}
    #todo:
    #rm only needs to display the formatted timer for lap times
    OnBegin<override>()<suspends>:void=
        {}
   

    Start():void=
        rm.Begin()

    Stop():void=
        #todo
        #need lap stats here
        #need to figure out how I can keep race to one player at a time
        rm.End()