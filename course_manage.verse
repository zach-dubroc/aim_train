
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Playspaces}
using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

course_manage := class(creative_device):
    @editable s_prop :creative_prop = creative_prop{}
    @editable st :teleporter_device = teleporter_device{}
    @editable rt :teleporter_device = teleporter_device{}
    @editable path_prop :creative_prop = creative_prop{}
    @editable tm :target_manage = target_manage{}
    @editable sw :stopwatch = stopwatch{}
    @editable path_mng :path_device = path_device{}
    var gm_start :logic = false

    OnBegin<override>()<suspends>:void=
        # Sleep(0.5)
        rt.EnterEvent.Subscribe(Stop)
        st.EnterEvent.Subscribe(Start)
        set gm_start = true

    Start(Agent : agent):void=
        if (gm_start = true):
            sw.Start()
            s_prop.Hide()
            InitPlayers()
            tm.Start()
            tm.StartCheckPoints()
            var y :int = 0
            if(x := targ_idx[GetSession()]):
                set y = x
            Print("cm36 start targ_idx: {y}")
            path_mng.teleport_toggle(y)

    Stop(Agent : agent):void=
        var y :int = 0
        if(x := targ_idx[GetSession()]):
            set y = x
            path_mng.teleport_toggle(y)
            Print("cm44 stop targ_idx: {y}")
        if (set targ_idx[GetSession()] = 0){}
            
    InitPlayers():void=
        AllPlayers :[]player = GetPlayspace().GetPlayers()
        for (Player : AllPlayers, Character := Player.GetFortCharacter[]):
            Character.EliminatedEvent().Subscribe(HandleElim)

    HandleElim(result :elimination_result):void=
        Eliminator := result.EliminatingCharacter
        if(character := Eliminator?, EliminatingAgent := character.GetAgent[]):
            Print("elim, TODO: give character +1 kill")
        path_mng.teleport_toggle(19)




