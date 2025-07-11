using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }
fg_target_manage2 := class(creative_device):
    @editable fg_target :creative_prop = creative_prop{}
    @editable pm :prop_manipulator_device = prop_manipulator_device{} 
    @editable var min_pos :vector3 = vector3{}
    @editable var max_pos :vector3 = vector3{}
    var dock :logic = false
    var delay :float = 0.5 
    var prop_pos :vector3 = vector3{}
    var prop_rot :rotation = rotation{}
    OnBegin<override>()<suspends>:void=
        pm.DamagedEvent.Subscribe(damn)
    damn(A :agent):void=
        t := fg_target.GetTransform()
        rot := t.Rotation
        pos := t.Translation
        set prop_pos = pos
        set prop_rot = rot
        # pm.HideProps()
        spawn:
            d()
    d()<suspends>:void=
        rx := GetRandomFloat(min_pos.X, max_pos.X)
        rz := GetRandomFloat(min_pos.Z, max_pos.Z)
        new_pos := vector3{X:=rx,Y:=prop_pos.Y,Z:=rz}
        new_rot := prop_rot.ApplyRoll(PiFloat/2.0 * 0.5)
        fg_target.MoveTo(new_pos,new_rot, delay)
        # pm.ShowProps()
        Sleep(delay)