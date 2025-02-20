
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
# restart rounds/portals with targ_idx 
# +5 second penalty if player falls off of path or teleport back 5 yards? or both?
var targ_idx : weak_map(session, int) = map{}

rotate_tag := class(tag):
target_manage := class(creative_device):

    var idx :int = 0
    var damage_lock :logic = false
    @editable stop_watch :timer_device = timer_device{}
    @editable var Speed :float = 0.05
    @editable var MinPosition :vector3 = vector3{}
    @editable var MaxPosition :vector3 = vector3{}
    @editable var pms : []prop_manipulator_device = array{}
    @editable var targs : []creative_prop = array{}



    OnBegin<override>()<suspends>:void=

        if (x := targ_idx[GetSession()]):
            Print("current: {x}")
        else:
            if (set targ_idx[GetSession()] = 0):
                Print("init x to 0")

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
            #minZ: -9666.539967
            #maxZ: -9418.539967
            #added 100

    OnPropDamage(Agent: agent):void=

        if(damage_lock = false):
            set damage_lock = true
            if (idx < targs.Length):
                if (targs[idx].Hide()){}
           
                
                if (idx + 1 < targs.Length):
                    if (targs[idx+1].Show()){}
                    
                set idx += 1
                if(set targ_idx[GetSession()] = idx){}
                if(y := targ_idx[GetSession()]){
                    Print("set {y}")
                }

            spawn:
                DamageLock(damage_lock)

    DamageLock(d: logic)<suspends>:void=
        Sleep(0.5)
        set damage_lock = false
 

            
                






