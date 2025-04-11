
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Playspaces }
    
# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

game_manage := class(creative_device):
    @editable s_teleport :teleporter_device = teleporter_device{}
    @editable p_teleport :teleporter_device = teleporter_device{}
    @editable r_teleport :teleporter_device = teleporter_device{}
    @editable et :trigger_device = trigger_device{}
    @editable path_prop :creative_prop = creative_prop{}
    @editable tm :target_manage = target_manage{}
    @editable sw :stopwatch = stopwatch{}
    OnBegin<override>()<suspends>:void=
        et.TriggeredEvent.Subscribe(Stop)
        s_teleport.EnterEvent.Subscribe(Start)
        r_teleport.EnterEvent.Subscribe(Start)
        
    Start(Agent : agent):void=
        sw.Start()
        tm.Start()
        var y :int = 0
        if(x := targ_idx[GetSession()]):
            set y = x
        spawn:
            PathMove(y)

    Stop(Agent : ?agent):void=
        var y :int = 0
        if(x := targ_idx[GetSession()]):
            set y = x
            sw.Stop()
        spawn:
            PathMove(y)

    PathMove(targ:int)<suspends>:void=
        Transform := path_prop.GetTransform()
        Position := Transform.Translation
        Rotation := Transform.Rotation
        if (targ < 20):
            NewPosition := vector3{X:=Position.X, Y:=Position.Y, Z:=(Position.Z + 1900.0)}      
            path_prop.MoveTo(NewPosition, Rotation, 0.8)
            p_teleport.Disable()
            s_teleport.Disable()
            r_teleport.Disable()

            et.Enable()
        if(targ = 20):
            NewPosition := vector3{X:=Position.X, Y:=Position.Y, Z:=(Position.Z - 1900.0)}      
            path_prop.MoveTo(NewPosition, Rotation, 0.1)
            p_teleport.Enable()
            s_teleport.Enable()
            r_teleport.Enable()

            et.Disable()
            if (set targ_idx[GetSession()] = 0){}

            # 2150 too high


        #-9648.0 ceiling
        #-9856.0


    

