
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Playspaces }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

game_manage := class(creative_device):
    @editable teleport :teleporter_device = teleporter_device{}
    @editable start_trigger :trigger_device = trigger_device{}
    @editable path_prop :creative_prop = creative_prop{}
    OnBegin<override>()<suspends>:void=
        #trigger.TriggeredEvent.Subscribe(Start)
        #disable on begin/enable on end
        teleport.EnterEvent.Subscribe(Start)
        
    Start(Agent : agent):void=
        spawn:
            RaisePath()
        
    RaisePath()<suspends>:void=
        Transform := path_prop.GetTransform()
        Position := Transform.Translation
        Rotation := Transform.Rotation
        NewPosition := vector3{X:=Position.X, Y:=Position.Y, Z:=(Position.Z + 215.0)}
        if (Position.Z = -9856.0):
            path_prop.MoveTo(NewPosition, Rotation, 0.5)
            
        #c/f
        #-9648.0 
        #-9856.0