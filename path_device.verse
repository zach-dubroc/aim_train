
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }


path_device := class(creative_device):
    @editable s_teleport :teleporter_device = teleporter_device{}
    @editable p_teleport :teleporter_device = teleporter_device{}
    @editable r_teleport :teleporter_device = teleporter_device{}
    @editable r2_teleport :teleporter_device = teleporter_device{}
    var t_enable :logic = false
   


   
    teleport_toggle(targ:int):void=
        if (targ < 19 and t_enable = false):
            Print("t_toggle disable called on: {targ}, false") 
            s_teleport.Disable() #send
            r_teleport.Disable() #send
            set t_enable = true
        if(targ = 19 and t_enable = true):
            #then flip back for reset if course finished
            Print("t_toggle enable called on: {targ}, true")
            s_teleport.Enable() 
            r_teleport.Enable()
            set t_enable = false
            # if (set targ_idx[GetSession()] = 0){}

