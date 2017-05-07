identification division.
program-id. BAMS.

environment division.
configuration section.
    special-names.
        crt status is Operation.
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".

input-output section.
    file-control.
        select optional AttendeesFile assign to AttendeesFileName
            organization is indexed
            access mode is dynamic
            record key is AuthCode of AttendeeRecord
            file status is RecordStatus.

data division.
file section.
    fd AttendeesFile is global.
        copy DD-Attendee replacing Attendee by
            ==AttendeeRecord is global.
            88 EndOfAttendeesFile value high-values==.

working-storage section.
    copy DD-Attendee.

    01 AddAttendeeFlag pic 9 value 0.
        88 AddAttendeeFlagOn value 1 when set to false is 0.

    01 AttendeesFileName pic x(20) value "attendees.dat".

    01 RecordStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

    01 BackupFileName   pic x(20) value "attendees.bak".

    01 BarnCampStats.
        02 PeopleOnSite pic 999 value zero.
        02 PeopleSignedUp pic 999 value zero.
        02 PeopleToArrive pic 999 value zero.
        02 PeopleToArriveToday pic 999 value zero.
        02 KidsOnSite pic 99 value zero.
        02 KidsToArrive pic 99 value zero.
        02 KidsToArriveToday pic 99 value zero.
        02 TotalEstimatedAttendees pic 999 value zero.
        02 TotalEstimatedKids pic 99 value zero.

    copy DD-Operation.

    01 Command pic x.

    01 CommandLineArgumentCount pic 9 value zero.

    01 CurrentDayOfWeek pic 9 value zero.
    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic x(3) occurs 7 times.
            88 ValidDayOfWeek values "Wed", "Thu", "Fri", "Sat", "Sun".

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
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode of Attendee.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 from Name of Attendee.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 from Email of Attendee.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 from Telephone of Attendee.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 from ArrivalDay of Attendee.
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 from AttendanceStatus of Attendee.
        03 line 14 column 1 value "Kids:".
        03 line 14 column 15 from NumberOfKids of Attendee.
        03 line 16 column 1 value "Pay amount:".
        03 pic 999 line 16 column 15 from AmountToPay of Attendee.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 from PaymentStatus of Attendee.
        03 line 20 column 1 value "Diet issues:".
        03 line 20 column 15 from Diet of Attendee.
        03 line 24 column 1 value "Commands: F1 Home, F4 Edit                                                   " reverse-video highlight.
        03 line 24 column 78 to Command.

    01 SearchByAuthCodeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 2 column 1 value "Enter AuthCode and press enter, F2 to find:".
        03 line 2 column plus 2 to AuthCode of Attendee required.
        03 line 24 column 1 value "Commands: F1 Home, F2 Find - type in authcode and press ENTER                         " reverse-video highlight.

    01 EditAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode of Attendee.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 using Name of Attendee required.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 using Email of Attendee.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 using Telephone of Attendee.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 from ArrivalDay of Attendee.
        03 line 10 column plus 2 value "(Wed/Thu/Fri/Sat)".
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 from AttendanceStatus of Attendee.
        03 line 12 column plus 2 value "(A = arrived, C = coming, X = cancelled)".
        03 line 14 column 1 value "Kids:".
        03 pic 9 line 14 column 15 using NumberOfKids of Attendee required.
        03 line 16 column 1 value "Pay amount:".
        03 pic 999 line 16 column 15 using AmountToPay of Attendee required full.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 from PaymentStatus of Attendee.
        03 line 20 column 1 value "Diet issues:".
        03 line 20 column 15 using Diet of Attendee.
        03 line 24 column 1 value "Commands: F1 Home; Toggle: F5 Arrival, F6 Status, F7 Paid; F8 Save            " reverse-video highlight.
        03 line 24 column 78 to Command.

procedure division.
    perform EnableExtendedKeyInput
    perform SetupAttendeesDataFileName
.

Main section.
    perform until OperationIsExit
        perform LoadAttendeeRecords
        perform DisplayHomeScreen
    end-perform

    stop run
.

LoadAttendeeRecords section.
        accept CurrentDayOfWeek from day-of-week
        initialize PeopleSignedUp, PeopleOnSite, PeopleToArrive, PeopleToArriveToday,
            KidsOnSite, KidsToArrive, KidsToArriveToday
        move zeroes to AuthCode of AttendeeRecord
        start AttendeesFile key is greater than AuthCode of AttendeeRecord
        open input AttendeesFile
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
            perform until EndOfAttendeesFile
                evaluate true
                    when AttendeeArrived of AttendeeRecord
                        add 1 to PeopleOnSite
                        add NumberOfKids of AttendeeRecord to KidsOnSite
                    when AttendeeComing of AttendeeRecord
                        add 1 to PeopleToArrive
                        add NumberOfKids of AttendeeRecord to KidsToArrive
                        if ValidDayOfWeek(CurrentDayOfWeek) and
                            ArrivalDay of AttendeeRecord is equal to DayOfTheWeek(CurrentDayOfWeek) then
                            add 1 to PeopleToArriveToday
                            add NumberOfKids of AttendeeRecord to KidsToArriveToday
                        end-if
                end-evaluate
                add 1 to PeopleSignedUp
                read AttendeesFile next record
                    at end set EndOfAttendeesFile to true
                end-read
            end-perform
        close AttendeesFile

        add PeopleToArrive to PeopleOnSite giving TotalEstimatedAttendees
        add KidsToArrive to KidsOnSite giving TotalEstimatedKids
        .

DisplayHomeScreen section.
    accept HomeScreen from crt end-accept
    evaluate true
        when OperationIsView perform ViewAttendee
        when OperationIsAdd  perform AddAttendee
    end-evaluate
.

ViewAttendee section.
    initialize Attendee
    perform DisplaySearchScreen
    if AuthCode of Attendee is not HexNumber then
        exit section
    end-if
    open input AttendeesFile
    move Authcode of Attendee to AuthCode of AttendeeRecord
    read AttendeesFile record into Attendee
        key is AuthCode of AttendeeRecord
        invalid key display "Record for " Authcode of Attendee " not found - " RecordStatus
    end-read
    close AttendeesFile

    if Name of Attendee is equal to high-values then
        display "Invalid authcode or authcode not found"
    else
        perform until OperationIsBack
            accept ViewAttendeeScreen end-accept
            evaluate true
                when OperationIsEdit perform EditAttendee
            end-evaluate
        end-perform
    end-if
.

DisplaySearchScreen section.
    move spaces to AuthCode of Attendee
    accept SearchByAuthCodeScreen end-accept
    evaluate true
        when OperationIsView call "ListAttendeesScreen"
            using by content AttendeesFileName by reference Authcode of Attendee
        when other move function upper-case(AuthCode of Attendee) to AuthCode of Attendee
    end-evaluate
.

EditAttendee section.
    perform until OperationIsBack or OperationIsSave
        accept EditAttendeeScreen end-accept
        evaluate true
            when OperationIsSave
                perform SaveAttendee
            when OperationIsTogglePaid
                evaluate true
                    when AttendeePaid of Attendee set AttendeeNotPaid of Attendee to true
                    when AttendeeNotPaid of Attendee set AttendeePaid of Attendee to true
                end-evaluate
            when OperationIsToggleArrivalDay
                evaluate true
                    when ArrivalDayIsWednesday of Attendee set ArrivalDayIsThursday of Attendee to true
                    when ArrivalDayIsThursday of Attendee set ArrivalDayIsFriday of Attendee to true
                    when ArrivalDayIsFriday of Attendee set ArrivalDayIsSaturday of Attendee to true
                    when ArrivalDayIsSaturday of Attendee set ArrivalDayIsWednesday of Attendee to true
                end-evaluate
            when OperationIsToggleStatus
                evaluate true
                    when AttendeeComing of Attendee set AttendeeArrived of Attendee to true
                    when AttendeeArrived of Attendee set AttendeeCancelled of Attendee to true
                    when AttendeeCancelled of Attendee set AttendeeComing of Attendee to true
                end-evaluate
        end-evaluate
    end-perform
.

SaveAttendee section.
    call "C$COPY" using AttendeesFileName, BackupFileName, 0
    open i-o AttendeesFile
    evaluate true
        when AddAttendeeFlagOn
            write AttendeeRecord from Attendee
                invalid key
                    if RecordExists
                        display "Record for " Name of Attendee "  already exists"
                    else
                        display "Error - status is " RecordStatus
                    end-if
            end-write
        when not AddAttendeeFlagOn
            rewrite AttendeeRecord from Attendee
                invalid key
                    if NoSuchRecord
                        display "Record for " AuthCode of Attendee "  not found"
                    else
                        display "Error - status is " RecordStatus
                    end-if
                end-rewrite
    end-evaluate
    close AttendeesFile
.

AddAttendee section.
    initialize Attendee
    call "createAuthCode" using by reference AuthCode of Attendee
    set ArrivalDayIsFriday of Attendee to true
    set AttendeeArrived of Attendee to true
    set AttendeeNotPaid of Attendee to true
    move 40 to AmountToPay of Attendee
    set AddAttendeeFlagOn to true
    perform EditAttendee
.

EnableExtendedKeyInput section.
    set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'
    set environment 'COB_SCREEN_ESC' to 'Y'
.

SetupAttendeesDataFileName section.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 1 then
        accept AttendeesFileName from argument-value
        if AttendeesFileName not equal to spaces
            move AttendeesFileName to BackupFileName
            inspect BackupFileName replacing all ".dat" by ".bak"
        end-if
    end-if
.

end program BAMS.
