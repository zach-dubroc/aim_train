using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Verse }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }

Reset_Respawn_Build_3 := class(creative_device):

    var player_pos :vector3 = vector3{}
    var player_rot :rotation = rotation{}
    var reset_distance :float = 2145.0
    @editable rt: trigger_device = trigger_device{}

    @editable
    br: explosive_device = explosive_device{}

    @editable
    LoadDLCinematic: cinematic_sequence_device = cinematic_sequence_device{}

    @editable
    UnloadDLCinematic: cinematic_sequence_device = cinematic_sequence_device{}

    OnBegin<override>()<suspends>:void=
            rt.TriggeredEvent.Subscribe(BuildReset)

    BuildReset(MaybeAgent:? agent):void=
        if(Agent:= MaybeAgent?):
            br.Explode(Agent)
            spawn:
                DelaySequence(Agent)
    
    DelaySequence(Agent:agent)<suspends>:void=
        UnloadDLCinematic.Play()
        Sleep(1.0)
        LoadDLCinematic.Play()
        br.Reset()
        TeleportPlayerBackToStart(Agent)
 
    TeleportPlayerBackToStart(Agent:agent):void=
        if (Character := Agent.GetFortCharacter[]):
            CharacterTranslation := Character.GetTransform().Translation
            CharacterRotation := Character.GetTransform().Rotation 
            set player_pos = CharacterTranslation
            set player_rot = CharacterRotation
            # - or + depends on side of field
            restart_pos := vector3{X:=player_pos.X+reset_distance, Y:=player_pos.Y+(reset_distance*2), Z:=player_pos.Z+25.0}
            if (Character.TeleportTo[restart_pos, CharacterRotation]){}