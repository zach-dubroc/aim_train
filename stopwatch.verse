
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/UI }

time_text<localizes>(t: string)  :message = "{t}"
stopwatch := class(creative_device):

    
    @editable stop_watch :timer_device = timer_device{}
    @editable b :billboard_device = billboard_device{}
    var time :float = 0.0
    var ms :string = ""


    # Message<localizes> : message = "DON'T MISS A BALL, AND MAKE SURE YA DON'T FALL"
    # TimeText<localizes>(c_time : float) : message = "{c_time}"
    
    OnBegin<override>()<suspends>:void=
        {}
        # Start()

    Start():void=
        stop_watch.Start()
        spawn:
            lap_start()
    Stop():void=
        stop_watch.Complete()

    update_b():void=
        
        b.SetText(time_text(ms))
        

    lap_start()<suspends>:void=
        loop:
            set time = stop_watch.GetActiveDuration()
            set ms = "time: {FromSecondsToTimerFormat(time)}"

            update_b()
            Sleep(0.01)

            if(time > 100.0):
                break
            

#this should start a stopwatch
#runs until user end(et_device in game_manage)
#->users time will go into the leaderboard
#->if user lowers their times, old time should be replaced/hidden/deleted?

# potentially the converter into stopwatch format 00:00.00
# if player takes longer than like 3 mins then their score == "03:00.00+"

    FromSecondsToTimerFormat<public>(Time : float, ?Decimals : int = 3):string=
        DecimalPanner := Pow(10.0, Decimals * 1.0)   
    
        if:
            TruncatedFormat := (Round[Time * DecimalPanner] * 1.0) / DecimalPanner
            TotSecs := Floor[TruncatedFormat]
            Dec := Round[(TruncatedFormat - (TotSecs * 1.0)) * DecimalPanner]
        then:
            var String_Dec : string = "{Dec}"
            DecLength := String_Dec.Length
            for(i := 0..(Decimals - DecLength - 1)):
                set String_Dec = "0" + String_Dec
    
            var String_Secs : string = "00"
            var String_Mins : string = "00"
    
            if(Secs := Mod[TotSecs, 60]):
                if(Secs > 9):
                    set String_Secs = ToString(Secs)  
                else:
                    set String_Secs = "0" + ToString(Secs)
    
            if(Mins := Floor[Time / 60.0]):
                if(Mins > 9):
                    set String_Mins = ToString(Mins)  
                else:
                    set String_Mins = "0" + ToString(Mins)
    
            return String_Mins + " : " + String_Secs + " : " + String_Dec
    
        ""