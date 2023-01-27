IsTimerStart := 0

; define default Alarm values 
AlarmHours := 0
AlarmMinutes := 50
AlarmSeconds := 0

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
	; reference time when alarm was started
	global StartTime

	; calculate the elapsed seconds by subtracting time when alarm was started
	; from the current time and then dividing by 1000 (milliseconds -> seconds)
	; and remove decimals by rounding
	SecondsElapsed := Floor((A_TickCount - StartTime)/1000)
	

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
	global StartTime
	StartTime := Floor(A_TickCount/1000)
	MsgBox "Timer has been started"
}

; Reload Script
F7::
{
	Reload
}