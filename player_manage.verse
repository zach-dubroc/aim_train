
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Playspaces}

using { /Fortnite.com/Game}
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


player_manage := class(creative_device):

    OnBegin<override>()<suspends>:void=
        var idx :int = 1
        Print("{idx}")
        AllPlayers :[]player = GetPlayspace().GetPlayers()
        for (Player : AllPlayers, Character := Player.GetFortCharacter[]):
            #listen for eliminations
            Character.EliminatedEvent().Subscribe(HandleElim)        
   


    HandleElim(Result :elimination_result):void=
        Eliminator := Result.EliminatingCharacter
        if(character := Eliminator?, EliminatingAgent := character.GetAgent[]):
            Print("elim")
            # todo: track elims (not persistent)
        Print("self-elim")
        # todo: reset course, maybe course_manage.stop()
        # send player back to locker-room
