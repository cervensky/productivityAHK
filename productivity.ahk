IsTimerStart := 0

; define default Alarm values 
AlarmHours := 0
AlarmMinutes := 49
AlarmSeconds := 5

; calculate all Alarm values into seconds
CalcAlarmSeconds()
{
	global AlarmSeconds
	global AlarmMinutes
	global AlarmHours
	return AlarmSeconds + (AlarmMinutes * 60) + (AlarmHours * 3600)
}

; display time left until Alarm goes off in mm:ss format
DisplayAlarmMS()
{
	; time when alarm was started in seconds
	global StartTimeSeconds
	
	; time since system boot in seconds
	CurrentTime := Floor(A_TickCount/1000)

	; time when alarm should go off in seconds
	AlarmSeconds := CalcAlarmSeconds()

	; calculate the elapsed seconds by subtracting time when alarm was started
	; from the current time
	; also, if user doesn't start timer first, StartTimeSeconds won't have a value
	; and an error will occur
	Try SecondsElapsed := Floor(CurrentTime - StartTimeSeconds)
	Catch 
	{
		MsgBox "Error, please start timer first (F6)."
		Exit
	}
	
	TotalSecondsLeft := AlarmSeconds - SecondsElapsed

	; calculate minutes by dividing by 60
	; and calculate seconds by using remainder of same division (modulo)
	MinutesLeft := Floor(TotalSecondsLeft/60)
	SecondsLeft := Floor(Mod(TotalSecondsLeft, 60))

	; base string of time
	TimeFormat := "00:00"

	; replace the base minute digits by the actual minutes
	TimeFormat := RegExReplace(TimeFormat, "^00", MinutesLeft, , 1)

	; replace the base second digits by the actual seconds
	; if seconds have only one digit (less than 10 seconds), replace only the last digit
	; else replace both digits
	if StrLen(SecondsLeft) = 1
		TimeFormat := RegExReplace(TimeFormat, "0$", SecondsLeft, , 1)
	else
		TimeFormat := RegExReplace(TimeFormat, "00$", SecondsLeft, , 1)

	return TimeFormat
}

; Display time until Alarm goes off
F5::
{
	MsgBox "Alarm going off in:`n`n`t" DisplayAlarmMS()
}

; Start Timer
F6::
{
	global StartTimeSeconds
	StartTimeSeconds := Floor(A_TickCount/1000)
	MsgBox "Timer has been started"
}

; Reload Script
F7::
{
	Reload
}