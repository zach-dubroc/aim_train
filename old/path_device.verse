
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }


path_device := class(creative_device):
    @editable s_teleport :teleporter_device = teleporter_device{}
    @editable p_teleport :teleporter_device = teleporter_device{}
    @editable r_teleport :teleporter_device = teleporter_device{}
    @editable r2_teleport :teleporter_device = teleporter_device{}
    @editable path_prop :creative_prop = creative_prop{}
    @editable sw :stopwatch = stopwatch{}

   
    OnBegin<override>()<suspends>:void=
        {}
    teleport_toggle(targ:int)<suspends>:void=
        #runs everytime a player joins so need to re-factor calls course_manage

        Print("tele toggle")
        if (targ < 20): 
            s_teleport.Disable() #send
            p_teleport.Disable() #receive
            r_teleport.Enable() #send
        if(targ = 20):
            #flip back for reset
            s_teleport.Enable() #send 
            p_teleport.Enable() #recieve
            r_teleport.Disable() #send
            if (set targ_idx[GetSession()] = 0){}