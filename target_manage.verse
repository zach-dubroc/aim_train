
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
# if player dies spawn back in locker_room

var targ_idx : weak_map(session, int) = map{}
rotate_tag := class(tag):
target_manage := class(creative_device):

    var idx :int = 0
    var damage_lock :logic = false
    @editable var Speed :float = 0.05
    @editable var MinPosition :vector3 = vector3{}
    @editable var MaxPosition :vector3 = vector3{}
    var PlayerPosition :vector3 = vector3{}
    var PlayerRotation :rotation = rotation{}
    var propPosition :vector3 = vector3{}
    var propRotation :rotation = rotation{}
    @editable var pms : []prop_manipulator_device = array{}
    @editable var targs : []creative_prop = array{}
    @editable var cps : []race_checkpoint_device = array{} 

    OnBegin<override>()<suspends>:void=
        TagGenerator := FindCreativeObjectsWithTag(rotate_tag{})
        for (obj : TagGenerator):
            if (Prop := creative_prop[obj]):
                for (i :int = 0..pms.Length-1):
                    if(pms[i].DamagedEvent.Subscribe(OnPropDamage)) {}
                spawn:
                    MoveTargets(Prop)
 
    StartCheckPoints():void=
            for (i :int = 0..pms.Length-1):
                if(Transform := targs[i].GetTransform()):
                    Rotation := Transform.Rotation
                    Position := Transform.Translation
                    set propPosition = Position
                    set propRotation = Rotation
                if(cps[i].TeleportTo[propPosition, propRotation]){}

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
            # diff = 100
    OnPropDamage(Agent: agent):void=
        
        if(damage_lock = false):
            set damage_lock = true
            if (idx < targs.Length):
                if(Transform := targs[idx].GetTransform()){
                    Rotation := Transform.Rotation
                    Position := Transform.Translation
                    set propPosition = Position
                    set propRotation = Rotation
                
                }
                if (targs[idx].Hide()){}
                if(Player:=player[Agent]):
                    HandleCheckPoint(Player)
                    if (cps[idx].TeleportTo[PlayerPosition, PlayerRotation]){}
                if (idx + 1 < targs.Length):
                    if (targs[idx+1].Show()){}
                set idx += 1
            
                if(set targ_idx[GetSession()] = idx){}
            spawn:
                DamageLock(damage_lock)
    DamageLock(d: logic)<suspends>:void=
        Sleep(0.5)
        set damage_lock = false

    Start():void=
        if(targs[0].Show()){}
        for(targ :int = 0 .. targs.Length-1):
            if (targ > 0):
              if(targs[targ].Hide()){}
        if (set targ_idx[GetSession()] = 0){}
        set idx = 0
       

    HandleCheckPoint(Agent: agent):void=
        if(FortCharacter := Agent.GetFortCharacter[])
        then:
            CharacterTranslation := FortCharacter.GetTransform().Translation
            CharacterRotation := FortCharacter.GetTransform().Rotation
            set PlayerPosition = CharacterTranslation
            set PlayerRotation = CharacterRotation
        


