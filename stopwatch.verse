
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }
using { /Fortnite.com/Game }

stopwatch := class(creative_device):
    @editable rm : race_manager_device = race_manager_device{}
    @editable path_mng :path_device = path_device{}
    @editable s_prop :creative_prop = creative_prop{}
    @editable e_prop :creative_prop = creative_prop{}
    @editable barrier :barrier_device = barrier_device{}
    @editable stat :player_reference_device = player_reference_device{}
    @editable timer :timer_device = timer_device{}
    @editable time_sign :billboard_device = billboard_device{}
    @editable hud_timer : hud_message_device = hud_message_device{}
 
    var elim_subs :[]cancelable = array{}
    OnBegin<override>()<suspends>:void=
        rm.RaceCompletedEvent.Subscribe(raceEnd)
        rm.RaceBeganEvent.Subscribe(raceStart)

    raceEnd(Agent:agent):void=
        path_mng.teleport_toggle(19)
        s_prop.Show() 
        e_prop.Show() 
        barrier.RemoveFromIgnoreList(Agent)
        if(sub:cancelable= elim_subs[0]):
            sub.Cancel()
    Start():void=
        rm.Begin()
    Stop(Elim :elimination_result):void=
        rm.End()
        path_mng.teleport_toggle(19)
        s_prop.Show()
        if(sub:cancelable= elim_subs[0]):
            sub.Cancel()
            if (Agent:=Elim.EliminatedCharacter.GetAgent[]):
                hud_timer.Hide()
    raceStart(Agent: agent):void=
        e_prop.Hide()
        barrier.AddToIgnoreList(Agent)
        timer.Start(Agent)
        hud_timer.Show(Agent)
        spawn:
            start_timer(Agent)
        if(Char := Agent.GetFortCharacter[]):
            var elim_subscribe :cancelable = Char.EliminatedEvent().Subscribe(Stop)
            if (new_arr := elim_subs.Insert[0, array{}]):
                set elim_subs = new_arr
    PadNumber(Number : int, Length : int) : string =
        var Result : string = ToString(Number)
        var CurrentLength : int = Result.Length
        loop:
            if (CurrentLength >= Length):
                break
            set Result = "0" + Result
            set CurrentLength += 1
        Result
    FormatTime(Seconds : float)<suspends> : string =
        if (TotalMilliseconds := Floor[Seconds * 1000.0]):
            if (Minutes := Floor[Seconds / 60.0]):
                RemainingSeconds := Seconds - (Minutes * 60.0)
                if (WholeSeconds := Floor[RemainingSeconds]):
                    Milliseconds := TotalMilliseconds - (Minutes * 60000) - (WholeSeconds * 1000)
                    MinutesStr := PadNumber(Minutes, 2)
                    SecondsStr := PadNumber(WholeSeconds, 2)
                    MillisecondsStr := PadNumber(Milliseconds, 3)
                    return "00:{SecondsStr}:{MillisecondsStr}"
        return "00:00:000"
    StringToMessage<localizes>(input_string :string) :message = "{input_string}"
    start_timer(Agent:agent)<suspends>:void=
        loop:
            Time := timer.GetActiveDuration(Agent)
            f_time := FormatTime(Time)
            time_sign.SetText(StringToMessage("{f_time}"))
            hud_timer.SetText(StringToMessage("{f_time}"))
            Sleep(0.01)
