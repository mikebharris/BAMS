01 ViewScreen background-color BackgroundColour foreground-color ForegroundColour.
    03 blank screen.
    03 line 1 column 1 from ScreenHeader reverse-video.
    03 line 2 column 1 value "AuthCode:".
    03 line 2 column 15 from AuthCode of CurrentAttendee.
    03 line 4 column 1 value "Name:".
    03 line 4 column 15 from AttendeeName of CurrentAttendee.
    03 line 6 column 1 value "Email:".
    03 line 6 column 15 from Email of CurrentAttendee.
    03 line 8 column 1 value "Telephone:".
    03 line 8 column 15 from Telephone of CurrentAttendee.
    03 line 10 column 1 value "Arrival day:".
    03 line 10 column 15 from ArrivalDay of CurrentAttendee.
    03 line 12 column 1 value "Status:".
    03 line 12 column 15 from AttendanceStatus of CurrentAttendee.
    03 line 14 column 1 value "Kids:".
    03 line 14 column 15 from NumberOfKids of CurrentAttendee.
    03 line 16 column 1 value "Pay amount:".
    03 pic 999 line 16 column 15 from AmountToPay of CurrentAttendee.
    03 line 18 column 1 value "Paid?:".
    03 line 18 column 15 from PaymentStatus of CurrentAttendee.
    03 line 20 column 1 value "Diet issues:".
    03 line 20 column 15 from Diet of CurrentAttendee.
    03 line 22 column 1 value "Backup File:".
    03 line 22 column 15 from BackupFileName.
    03 line 24 column 1
        value "Commands: F1 Home, F3 Add, F4 Edit                                            " reverse-video.
    03 line 24 column 78 to Command.
