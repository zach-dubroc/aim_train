
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
#saving laptime as rank
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
        for (PM : pms):
            PM.DamagedEvent.Subscribe(OnPropDamage)
        for (obj : TagGenerator):
            if (Prop := creative_prop[obj]):
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
            Print("targets: {targs.Length}")
            if (idx < targs.Length):
                if(Transform := targs[idx].GetTransform()){
                    Rotation := Transform.Rotation
                    Position := Transform.Translation
                    set propPosition = Position
                    set propRotation = Rotation
                }
                Print("72targ_idx: {idx}")

                if (targs[idx].Hide()){}
                if(Player:=player[Agent]):
                    HandleCheckPoint(Player)
                    if (cps[idx].TeleportTo[PlayerPosition, PlayerRotation]){}
                if (idx + 1 < targs.Length):
                    if (targs[idx+1].Show()){}
                set idx += 1
            
                if(set targ_idx[GetSession()] = idx){}
                Print("81targ_idx: {idx}")
            spawn:
                DamageLock()
                
    DamageLock()<suspends>:void=
        Sleep(0.2)
        if(damage_lock=true){
            set damage_lock = false
        }

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
        

# error pattern:
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 6
# LogVerse: : 81targ_idx: 7
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 7
# LogVerse: : 81targ_idx: 8
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 8
# LogVerse: : 81targ_idx: 9
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 9
# LogVerse: : 81targ_idx: 10
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 10
# LogVerse: : 81targ_idx: 11
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 11
# LogVerse: : 81targ_idx: 12
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 12
# LogVerse: : 81targ_idx: 13
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 13
# LogVerse: : 81targ_idx: 14
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 14
# LogVerse: : 81targ_idx: 15
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 15
# LogVerse: : 81targ_idx: 16
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 16
# LogVerse: : 81targ_idx: 17
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 17
# LogVerse: : 81targ_idx: 18
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 18
# LogVerse: : 81targ_idx: 19
# LogVerse: : targets: 20
# LogVerse: : 72targ_idx: 19
# LogVerse: : 81targ_idx: 20
# LogVerse: : lap
