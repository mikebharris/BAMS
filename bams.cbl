identification division.
program-id. BAMS.

environment division.
configuration section.
    special-names.
        crt status is Operation.
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".

data division.
working-storage section.
    copy Attendee.

    01 AddAttendeeFlag pic 9 value 0.
        88 AddAttendeeFlagOn value 1 when set to false is 0.

    01 AttendeesFileName pic x(20) value spaces.

    01 BarnCampStats.
        02 PeopleOnSite pic 999 value zero.
        02 PeopleSignedUp pic 999 value zero.
        02 PeopleToArrive pic 999 value zero.
        02 PeopleToArriveToday pic 999 value zero.
        02 KidsOnSite pic 99 value zero.
        02 KidsToArrive pic 99 value zero.
        02 KidsToArriveToday pic 99 value zero.
        02 NumberOfCancellations pic 99 value zero.
        02 TotalEstimatedAttendees pic 999 value zero.
        02 TotalEstimatedKids pic 99 value zero.

    copy Operation.

    01 Command pic x.

    01 CommandLineArgumentCount pic 9 value zero.

    01 CurrentDayOfWeek pic 9 value zero.
    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic x(3) occurs 7 times.

screen section.
    01 HomeScreen background-color 0 foreground-color 2 highlight.
        03 blank screen background-color 0 foreground-color 5.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video.
        03 line 5 column 34 value "Welcome to BAMS" underline.
        03 line 7 column 36 value "Today is ".
        03 line 7 column plus 1 from DayOfTheWeek(CurrentDayOfWeek).
        03 line 10 column 5 value "People on site: ".
        03 pic zzz9 line 10 column plus 3 from PeopleOnSite.
        03 line 11 column 5 value "People to arrive: ".
        03 pic zzz9 line 11 column plus 1 from PeopleToArrive.
        03 line 12 column 5 value "                " underline.
        03 line 13 column 5 value "Total attendees: ".
        03 pic zzz9 line 13 column plus 2 from TotalEstimatedAttendees.
        03 line 16 column 5 value "To arrive today: ".
        03 pic zzz9 line 16 column plus 2 from PeopleToArriveToday.
        03 line 10 column 50 value "Kids on-site: ".
        03 pic z9 line 10 column plus 5 from KidsOnSite.
        03 line 11 column 50 value "Kids to arrive: ".
        03 pic z9 line 11 column plus 3 from KidsToArrive.
        03 line 12 column 50 value "           " underline.
        03 line 13 column 50 value "Total kids:".
        03 pic z9 line 13 column plus 8 from TotalEstimatedKids.
        03 line 16 column 45 value "Kids to arrive today: ".
        03 pic z9 line 16 column plus 2 from KidsToArriveToday.
        03 line 24 column 1 value "Commands: F2 View, F3 Add, F10 Exit                                           " reverse-video highlight.
        03 line 24 column 78 to Command.

    01 ViewAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 3 column 1 value "AuthCode:".
        03 line 3 column 15 from AuthCode.
        03 line 5 column 1 value "Name:".
        03 line 5 column 15 from Name.
        03 line 7 column 1 value "Email:".
        03 line 7 column 15 from Email.
        03 line 9 column 1 value "Telephone:".
        03 line 9 column 15 from Telephone.
        03 line 11 column 1 value "Arrival day:".
        03 line 11 column 15 from ArrivalDay.
        03 line 13 column 1 value "Status:".
        03 line 13 column 15 from AttendanceStatus.
        03 line 15 column 1 value "Kids:".
        03 line 15 column 15 from NumberOfKids.
        03 line 17 column 1 value "Pay amount:".
        03 pic 999 line 17 column 15 from AmountToPay.
        03 line 19 column 1 value "Paid?:".
        03 line 19 column 15 from PaymentStatus.
        03 line 21 column 1 value "Diet issues:".
        03 line 21 column 15 from Diet.
        03 line 24 column 1 value "Commands: F1 Home, F4 Edit, F10 Exit                                         " reverse-video highlight.
        03 line 24 column 78 to Command.

    01 SearchByAuthCodeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 4 column 1 value "Enter AuthCode and press enter or F2 to look-up:".
        03 line 4 column plus 2 to AuthCode required.
        03 line 24 column 1 value "Commands: F1 Home, F2 Look-up, F10 Exit                                        " reverse-video highlight.

    01 ListAttendeesScreen background-color 0 foreground-color 2.
        03 blank screen.

    01 EditAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 3 column 1 value "AuthCode:".
        03 line 3 column 15 from AuthCode.
        03 line 5 column 1 value "Name:".
        03 line 5 column 15 using Name required.
        03 line 7 column 1 value "Email:".
        03 line 7 column 15 using Email.
        03 line 9 column 1 value "Telephone:".
        03 line 9 column 15 using Telephone.
        03 line 11 column 1 value "Arrival day:".
        03 line 11 column 15 from ArrivalDay.
        03 line 11 column plus 2 value "(Wed/Thu/Fri/Sat)".
        03 line 13 column 1 value "Status:".
        03 line 13 column 15 from AttendanceStatus.
        03 line 13 column plus 2 value "(A = arrived, C = coming, X = cancelled)".
        03 line 15 column 1 value "Kids:".
        03 pic 9 line 15 column 15 using NumberOfKids required.
        03 line 17 column 1 value "Pay amount:".
        03 pic 999 line 17 column 15 using AmountToPay required full.
        03 line 19 column 1 value "Paid?:".
        03 line 19 column 15 from PaymentStatus.
        03 line 21 column 1 value "Diet issues:".
        03 line 21 column 15 using Diet.
        03 line 24 column 1 value "Commands: F1 Home; Toggle: F5 Arrival, F6 Status, F7 Paid; F8 Save, F10 Exit  " reverse-video highlight.
        03 line 24 column 78 to Command.

procedure division.
Initialisation section.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 1 then
        accept AttendeesFileName from argument-value
    else
        move "attendees.dat" to AttendeesFileName
    end-if
    call "Attendees"
    call "SetAttendeesFileName" using AttendeesFileName

    set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'
    set environment 'COB_SCREEN_ESC' to 'Y'
.

Main section.
    perform until OperationIsExit
        call "AttendeeStats" using by reference PeopleSignedUp, PeopleOnSite, PeopleToArrive, KidsOnSite, KidsToArrive
        add PeopleToArrive to PeopleOnSite giving TotalEstimatedAttendees
        add KidsToArrive to KidsOnSite giving TotalEstimatedKids
        accept CurrentDayOfWeek from day-of-week
        call "AttendeesToArriveOnDay" using content DayOfTheWeek(CurrentDayOfWeek) by reference PeopleToArriveToday, KidsToArriveToday
        accept HomeScreen from crt end-accept
        evaluate true
            when OperationIsView perform ViewAttendee
            when OperationIsAdd  perform AddAttendee
        end-evaluate
    end-perform

    stop run
.

SearchAttendee section.
    move spaces to AuthCode
    accept SearchByAuthCodeScreen end-accept
    evaluate true
        when OperationIsView call "AttendeesList"
            using by content AttendeesFileName by reference Authcode of Attendee
        when other move function upper-case(AuthCode) to AuthCode
    end-evaluate
.

ViewAttendee section.
    initialize Attendee
    perform SearchAttendee
    call "GetAttendeeByAuthCode"
        using by content Authcode of Attendee,
        by reference Attendee

    if Name of Attendee is equal to high-values or AuthCode is not HexNumber then
        display "Invalid authcode or authcode not found"
    else
        perform until OperationIsBack or OperationIsExit
            accept ViewAttendeeScreen end-accept
            evaluate true
                when OperationIsEdit perform EditAttendee
            end-evaluate
        end-perform
    end-if
.

EditAttendee section.
    perform until OperationIsBack or OperationIsExit or OperationIsSave
        accept EditAttendeeScreen end-accept
        evaluate true
            when OperationIsSave
                evaluate true
                    when AddAttendeeFlagOn call "AddAttendee" using by content Attendee
                    when not AddAttendeeFlagOn call "UpdateAttendee" using by content Attendee
                end-evaluate
            when OperationIsTogglePaid
                evaluate true
                    when AttendeePaid set AttendeeNotPaid to true
                    when AttendeeNotPaid set AttendeePaid to true
                end-evaluate
            when OperationIsToggleArrivalDay
                evaluate true
                    when ArrivalDayIsWednesday set ArrivalDayIsThursday to true
                    when ArrivalDayIsThursday set ArrivalDayIsFriday to true
                    when ArrivalDayIsFriday set ArrivalDayIsSaturday to true
                    when ArrivalDayIsSaturday set ArrivalDayIsWednesday to true
                end-evaluate
            when OperationIsToggleStatus
                evaluate true
                    when AttendeeComing set AttendeeArrived to true
                    when AttendeeArrived set AttendeeCancelled to true
                    when AttendeeCancelled set AttendeeComing to true
                end-evaluate
        end-evaluate
    end-perform
.

AddAttendee section.
    initialize Attendee
    call "createAuthCode" using by reference AuthCode of Attendee
    move DayOfTheWeek(CurrentDayOfWeek) to ArrivalDay of Attendee
    set AttendeeArrived of Attendee to true
    set AttendeeNotPaid of Attendee to true
    move 40 to AmountToPay
    set AddAttendeeFlagOn to true
    perform EditAttendee
.

end program BAMS.
