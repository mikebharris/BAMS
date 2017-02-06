identification division.
program-id. BAMS.

environment division.
configuration section.
    special-names.
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".

    repository.
        function all intrinsic
        function createAuthCode.

data division.
working-storage section.
    01 BarnCampStats.
        02 PeopleOnSite pic 999 value zero.
        02 PeopleSignedUp pic 999 value zero.
        02 PeopleToArrive pic 999 value zero.
        02 PeopleToArriveToday pic 999 value zero.
        02 TotalEstimatedAttendees pic 999 value zero.
        02 KidsToArrive pic 99 value zero.
        02 KidsOnSite pic 99 value zero.
        02 KidsToArriveToday pic 99 value zero.
        02 TotalEstimatedKids pic 99 value zero.
        02 NumberOfCancellations pic 99 value zero.

    01 CurrentDayOfWeek pic 9 value zero.

    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic x(3) occurs 7 times.

    01 AttendeesFileName pic x(20) value spaces.

    copy Attendee.

    01 Command pic x.
        88 CommandIsExit values "x","X".
        88 CommandIsView values "v","V".
        88 CommandIsEdit values "e", "E".
        88 CommandIsAdd values "a", "A".
        88 CommandIsSave values "s", "S".
        88 CommandIsGoBack values "g", "G".
        88 CommandIsSearch value "?".
        88 CommandIsList value "l", "L".

    01 StringToSearch pic x(30) value spaces.
    01 SearchOperation pic x.
        88 SearchByAuthCode values "a", "A".
        88 SearchByEmail values "e", "E".
        88 SearchByName values "n", "N".

    01 Today pic x(3).
        88 IsValidDayOfWeek values "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat".

screen section.
    01 HomeScreen background-color 0 foreground-color 2 highlight.
        03 blank screen background-color 0 foreground-color 5.
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
        03 line 24 column 4 value "Commands are: (V)iew/edit, (A)dd or e(X)it".
        03 line 24 column 78 to Command.

    01 ViewAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 from Name.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 from Email.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 from Telephone.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 from ArrivalDay.
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 from AttendanceStatus.
        03 line 14 column 1 value "Kids:".
        03 line 14 column 15 from NumberOfKids.
        03 line 16 column 1 value "To Pay:".
        03 pic 999 line 16 column 15 from AmountToPay.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 from PaymentStatus.
        03 line 24 column 4 value "Commands are: (E)dit or (G)oback".
        03 line 24 column 78 to Command.

    01 SearchByAuthCodeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 using AuthCode required.

    01 ListAttendeesScreen background-color 0 foreground-color 2.
        03 blank screen.

    01 EditAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 using Name required.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 using Email.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 using Telephone.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 using ArrivalDay required.
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 using AttendanceStatus required.
        03 line 14 column 1 value "Kids:".
        03 pic 9 line 14 column 15 using NumberOfKids required.
        03 line 16 column 1 value "To Pay:".
        03 pic 999 line 16 column 15 using AmountToPay.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 using PaymentStatus required.
        03 line 24 column 4 value "Commands are: (S)ave or (G)oback".
        03 line 24 column 78 to Command.

procedure division.
Initialisation section.
    move "attendees.dat" to AttendeesFileName
    call "Attendees" using AttendeesFileName
.

Main section.
    perform until CommandIsExit
        call "AttendeeStats" using by reference PeopleSignedUp, PeopleOnSite, PeopleToArrive, KidsOnSite, KidsToArrive
        add PeopleToArrive to PeopleOnSite giving TotalEstimatedAttendees
        add KidsToArrive to KidsOnSite giving TotalEstimatedKids
        accept CurrentDayOfWeek from day-of-week
        call "AttendeesToArriveOnDay" using content DayOfTheWeek(CurrentDayOfWeek) by reference PeopleToArriveToday, KidsToArriveToday
        accept HomeScreen end-accept
        evaluate true
            when CommandIsView perform ViewAttendee
            when CommandIsAdd  perform AddAttendee
            when CommandIsList perform ListAttendees
        end-evaluate
    end-perform

    stop run
.

SearchAttendee section.
    move spaces to AuthCode
    accept SearchByAuthCodeScreen end-accept
    move upper-case(AuthCode) to AuthCode
.

ListAttendees section.
    accept ListAttendeesScreen
    call "ListAttendees"
    accept Command
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
        perform until CommandIsGoBack
            accept ViewAttendeeScreen end-accept
            evaluate true
                when CommandIsEdit perform EditAttendee
            end-evaluate
        end-perform
    end-if
.

EditAttendee section.
    perform until CommandIsGoBack or CommandIsSave
        accept EditAttendeeScreen end-accept
        evaluate true
            when CommandIsSave call "UpdateAttendee" using by content Attendee
        end-evaluate
    end-perform
    move space to Command
.

AddAttendee section.
    initialize Attendee
    move createAuthCode to AuthCode of Attendee
    move DayOfTheWeek(CurrentDayOfWeek) to ArrivalDay of Attendee
    set AttendeeArrived of Attendee to true
    set AttendeeNotPaid of Attendee to true
    move 40 to AmountToPay
    perform until CommandIsGoBack or CommandIsSave
        accept EditAttendeeScreen end-accept
        evaluate true
            when CommandIsSave call "AddAttendee" using by content Attendee
        end-evaluate
    end-perform
.

end program BAMS.
