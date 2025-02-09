
using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Teams }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }


#todo 
# make round start on trigger event
# end when all targets destroyed
# +5 second penalty if player falls off of path or teleport back 5 yards? or both?

rotate_tag := class(tag):
item_rotator := class(creative_device):

    var PlayerMap :[player]int = map{}

    @editable stop_watch :timer_device = timer_device{}
    @editable var Speed :float = 0.05
    @editable var MinPosition :vector3 = vector3{}
    @editable var MaxPosition :vector3 = vector3{}
    @editable var pms : []prop_manipulator_device = array{}
    @editable var targs : []creative_prop = array{}
    var idx :int = 0
    
    OnBegin<override>()<suspends>:void=

        InitPlayers()
        
        #hide targets initially
        for(targ :int = 0 .. targs.Length-1):
            if (targ > 0):
                if(targs[targ].Hide()){}
            
        TagGenerator := FindCreativeObjectsWithTag(rotate_tag{})
        for (obj : TagGenerator):
            if (Prop := creative_prop[obj]):
                for (i :int = 0..pms.Length-1):
                    if(pms[i].DamagedEvent.Subscribe(OnPropDamage)) {}
                spawn:
                    MoveTargets(Prop)

    MoveTargets<private>(Prop: creative_prop)<suspends>:void=
        loop:
            Transform := Prop.GetTransform()
            Rotation := Transform.Rotation
            Position := Transform.Translation
            RandX := GetRandomFloat(MinPosition.X, MaxPosition.X)
            RandY := GetRandomFloat(MinPosition.Y, MaxPosition.Y)
            RandZ := GetRandomFloat(MinPosition.Z, MaxPosition.Z)
            NewRotation := Rotation.ApplyRoll(PiFloat/2.0 * Speed)
            NewYaw := Rotation.ApplyYaw(PiFloat/2.0 * Speed)
            NewPosition := vector3{X:=Position.X, Y:=Position.Y, Z:=RandZ}
            MoveResult := Prop.MoveTo(NewPosition, NewRotation, 0.8)
            Sleep(0.01)
            #maxZ: -9418.539967
            #minZ: -9666.539967

    OnPropDamage(Agent: agent):void=
        if(targs[idx].Hide()) {}
        Print("{idx}")
        if(targs[idx+1].Show()){}
        set idx += 1        
    InitPlayers():void=
        # store players
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            if (FortCharacter := Player.GetFortCharacter[]):
                FortCharacter.DamagedEvent().Subscribe(OnPropDamaged)

                
    OnPropDamaged(DM : damage_result):void=
        Print("reaching the player damage result")