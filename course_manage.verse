using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Playspaces}
using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
    
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# path floor/celing
# LogVerse: : -254.000000
# LogVerse: : 1646.000000

course_manage := class(creative_device):
    @editable st :teleporter_device = teleporter_device{}
    @editable rt :teleporter_device = teleporter_device{}
    @editable path_prop :creative_prop = creative_prop{}
    @editable tm :target_manage = target_manage{}
    @editable sw :stopwatch = stopwatch{}
    @editable path_mng :path_device = path_device{}
    # z axis change for path
    OnBegin<override>()<suspends>:void=
        rt.EnterEvent.Subscribe(Stop)
        st.EnterEvent.Subscribe(Start)
        
    Start(Agent : agent):void=
        InitPlayers()
        sw.Start()
        tm.Start()
        tm.StartCheckPoints()
        var y :int = 0
        if(x := targ_idx[GetSession()]):
            Print("{x}")
            set y = x
        spawn:
            path_mng.teleport_toggle(y)

    Stop(Agent : agent):void=
        var y :int = 0
        if(x := targ_idx[GetSession()]):
            set y = x
        if (set targ_idx[GetSession()] = 0){}
        sw.Stop()
        #Print("{y}") 
        spawn:
            path_mng.teleport_toggle(y)
                
                
    InitPlayers():void=
        AllPlayers :[]player = GetPlayspace().GetPlayers()
        if (p1 :player = AllPlayers[0]):
            if(p1_actual : fort_character = p1.GetFortCharacter[]):
                p1_actual.Damage(10.00)
        for (Player : AllPlayers, Character := Player.GetFortCharacter[]):
            Character.EliminatedEvent().Subscribe(HandleElim)

    HandleElim(result :elimination_result):void=
        #if player dies and is the player thats on the track, reset the race
        Eliminator := result.EliminatingCharacter
        if(character := Eliminator?, EliminatingAgent := character.GetAgent[]):
            Print("elim, TODO: give character +1 kill")
        Print("self-elim, reset the race")
        
        sw.Stop()
        spawn:
            path_mng.teleport_toggle(20) 
            # 20 value triggers path reset


