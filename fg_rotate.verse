using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Teams }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Random }

fg_rotate :=class(creative_device):
    @editable
    fg_props :[]creative_prop = array{} 
    var speed :float = 0.5 
    OnBegin<override>()<suspends>:void=
        for (Prop : fg_props):
            spawn:
                rotate_props(Prop)
        

    rotate_props(Prop :creative_prop)<suspends>:void=
        loop:
            Transform := Prop.GetTransform()
            NewRotation := Transform.Rotation.ApplyYaw(PiFloat/2.0 * speed)
            NewTransform := transform{
                Translation := Transform.Translation,
                Rotation := NewRotation,
                Scale := Transform.Scale
            }
            # if (Prop.TeleportTo[NewTransform]):
            Prop.MoveTo(Transform.Translation, NewRotation, 3.5)
            Sleep(0.0)