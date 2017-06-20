identification division.
program-id. BAMS.

environment division.
configuration section.
    special-names.
        crt status is CommandKeys.
        alphabet mixed is " ZzYyXxWwVvUuTtSsRrQqPpOoNnMmLlKkJjIiHhGgFfEeDdCcBbAa".
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".
    repository.
        function all intrinsic.

input-output section.
    file-control.
        select optional AttendeesFile assign to AttendeesFileName
            organization is indexed
            access mode is dynamic
            record key is AuthCode of AttendeeRecord
            file status is AttendeeStatus.

        select optional BackupFile assign to BackupFileName
            organization is line sequential.

data division.
file section.
    fd AttendeesFile is global.
        copy DD-Attendee replacing Attendee by
            ==AttendeeRecord is global.
            88 EndOfAttendeesFile value high-values==.

    fd BackupFile.
        copy DD-Attendee replacing Attendee by
            ==BackupRecord.
            88 EndOfBackupFile value high-values==.

working-storage section.

    01 AddAttendeeFlag pic 9 value 0.
        88 AddAttendeeFlagOn value 1 when set to false is 0.

    01 AttendeesFileName pic x(20) value "attendees.dat".
    01 BackupFileName pic x(20) value "attendees.bak".

    01 AttendeeStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

    01 AttendeesTable.
        02 Attendee occurs 1 to 200 times
                depending on NumberOfAttendees
                ascending key is Name
                ascending key is Email
                ascending key is AuthCode
                indexed by AttendeeIndex.
            03 Name     pic x(25) value spaces.
            03 Email    pic x(40) value spaces.
            03 AuthCode pic x(6) value all "0".
            03 AmountToPay pic 999 value 40.
            03 PaymentStatus pic a value "N".
                88 AttendeePaid values "Y", "y".
                88 AttendeeNotPaid values "N", "n".
            03 AmountPaid  pic 999 value zero.
            03 DatePaid value zeroes.
                04 CentuaryPaid pic 99.
                04 YearPaid pic 99.
                04 MonthPaid pic 99.
                04 DayPaid pic 99.
            03 Telephone    pic x(14) value spaces.
            03 ArrivalDay   pic xxx value spaces.
                88 ArrivalDayIsValid values "Wed", "Thu", "Fri", "Sat".
                88 ArrivalDayIsWednesday value "Wed".
                88 ArrivalDayIsThursday value "Thu".
                88 ArrivalDayIsFriday value "Fri".
                88 ArrivalDayIsSaturday value "Sat".
            03 NumberOfKids pic 9 value zero.
            03 AttendanceStatus pic a value "C".
                88 AttendeeComing values "C", "c".
                88 AttendeeArrived values "A", "a".
                88 AttendeeCancelled values "X", "x".
            03 StayingTillMonday pic 9 value 0.
                88 CanStayTillMonday value 1 when set to false is 0.
            03 Diet pic x(60) value spaces.

    01 AuthCodeToSearchFor pic x(6) value all "0".

    01 BarnCampStats.
        02 PeopleOnSite pic 999 value zero.
        02 PeopleSignedUp pic 999 value zero.
        02 PeopleStayingTillMonday pic 999 value zero.
        02 PeopleToArrive pic 999 value zero.
        02 PeopleToArriveToday pic 999 value zero.
        02 PeopleToBeOnSiteToday pic 999 value zero.
        02 KidsOnSite pic 99 value zero.
        02 KidsToArrive pic 99 value zero.
        02 KidsToArriveToday pic 99 value zero.
        02 TotalEstimatedAttendees pic 999 value zero.
        02 TotalEstimatedKids pic 99 value zero.

    01 EmailToSearchFor pic x(40) value spaces.
    01 NameToSearchFor pic x(25).
    01 NumberOfAttendees pic 999.

    01 Command pic x.
    copy DD-CommandKeys.

    01 CommandLineArgumentCount pic 9 value zero.

    copy DD-Attendee replacing Attendee by
            ==CurrentAttendee==.

    01 CurrentAttendeeNumber pic 999 value zero.
    01 CurrentRow pic 99 value zero.

    01 CurrentDayOfWeek pic 9 value zero.
    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic xxx occurs 7 times.
            88 ValidDayOfWeek values "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun".

    01 DefaultAmountToPay constant as 50.

    01 FirstRecordToShow pic 999 value 1.
    01 ForegroundColour pic 9 value 2.

    01 RowNumberFound pic 999 value zero.
    copy DD-ScreenHeader.
    01 LastRecordToShow pic 999 value 20.
    01 PageOffset pic 999 value 1.
    01 RecordsPerPage constant as 20.
    01 RecordSelected pic 999.

    01 RecordStatus pic 9 value 0.
        88 RecordFound value 1 when set to false is 0.

screen section.
    01 HomeScreen background-color 0 foreground-color ForegroundColour.
        03 blank screen.
        03 line 1 column 1 from ScreenHeader reverse-video.
        03 line 5 column 34 value "Welcome to BAMS" underline.
        03 line 7 column 36 value "Today is ".
        03 line 7 column plus 1 from DayOfTheWeek(CurrentDayOfWeek).
        03 line 10 column 5 value "Adults on site: ".
        03 pic zzz9 line 10 column plus 3 from PeopleOnSite.
        03 line 11 column 5 value "Adults to arrive: ".
        03 pic zzz9 line 11 column plus 1 from PeopleToArrive.
        03 line 12 column 5 value "                " underline.
        03 line 13 column 5 value "Total adults:    ".
        03 pic zzz9 line 13 column plus 2 from TotalEstimatedAttendees.
        03 line 16 column 5 value "To arrive today: ".
        03 pic zzz9 line 16 column plus 2 from PeopleToArriveToday.
        03 line 17 column 5 value "To be onsite today: ".
        03 pic zzz9 line 17 column minus 1 from PeopleToBeOnSiteToday.
        03 line 19 column 5 value "Staying till Mon: ".
        03 pic zzz9 line 19 column plus 1 from PeopleStayingTillMonday.
        03 line 10 column 50 value "Kids on-site: ".
        03 pic z9 line 10 column plus 5 from KidsOnSite.
        03 line 11 column 50 value "Kids to arrive: ".
        03 pic z9 line 11 column plus 3 from KidsToArrive.
        03 line 12 column 50 value "           " underline.
        03 line 13 column 50 value "Total kids:".
        03 pic z9 line 13 column plus 8 from TotalEstimatedKids.
        03 line 16 column 45 value "Kids to arrive today: ".
        03 pic z9 line 16 column plus 2 from KidsToArriveToday.
        03 line 24 column 1
            value "Commands: F2 List, F3 Add, F4 Edit, F10 Exit                                 " reverse-video.
        03 line 24 column 78 to Command.

    01 EditAttendeeScreen background-color 0 foreground-color ForegroundColour.
        03 blank screen.
        03 line 1 column 1 from ScreenHeader reverse-video.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode of CurrentAttendee.
        03 line 2 column 76 value "#".
        03 line 2 column plus 1 from CurrentAttendeeNumber.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 using Name of CurrentAttendee required.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 using Email of CurrentAttendee.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 using Telephone of CurrentAttendee.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 from ArrivalDay of CurrentAttendee.
        03 line 10 column plus 2 value "(Wed/Thu/Fri/Sat)".
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 from AttendanceStatus of CurrentAttendee.
        03 line 12 column plus 2 value "(A = arrived, C = coming, X = cancelled)".
        03 line 14 column 1 value "Kids:".
        03 pic 9 line 14 column 15 using NumberOfKids of CurrentAttendee required.
        03 line 16 column 1 value "Pay amount:".
        03 pic 999 line 16 column 15 using AmountToPay of CurrentAttendee required full.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 from PaymentStatus of CurrentAttendee.
        03 line 20 column 1 value "Diet issues:".
        03 line 20 column 15 using Diet of CurrentAttendee.
        03 line 24 column 1 value "Commands: F1 Home; Toggle: F5 Arrival, F6 Status, F7 Paid; F8 Save            " reverse-video.
        03 line 24 column 78 to Command.

    01 ListScreen background-color 0 foreground-color ForegroundColour.
        03 blank screen.
        03 line 1 column 1 from ScreenHeader reverse-video.
        03 line 2 column 1 value "Num" underline.
        03 line 2 column 6 value "Name" underline.
        03 line 2 column 31 value "Email" underline.
        03 line 2 column 71 value "AuthCode" underline.
        03 line 24 column 1 value "Commands: F1 Home, PgUp/PgDown to scroll, Enter number and press ENTER         " reverse-video.

    01 SearchScreen background-color 0 foreground-color ForegroundColour.
        03 blank screen.
        03 line 1 column 1 from ScreenHeader reverse-video.
        03 line 2 column 1 value "Enter AuthCode, Name, or Email and search - F2 to list all attendees:".
        03 line 4 column 1 value "AuthCode: ".
        03 line 4 column plus 2 to AuthCodeToSearchFor.
        03 line 6 column 1 value "Name:     ".
        03 line 6 column plus 2 to NameToSearchFor.
        03 line 8 column 1 value "Email:    ".
        03 line 8 column plus 2 to EmailToSearchFor.
        03 line 24 column 1
            value "Commands: F1 Home, F2 List; Search: F5 AuthCode, F6 Name, F7 Email           " reverse-video.

    01 ViewAttendeeScreen background-color 0 foreground-color ForegroundColour.
        03 blank screen.
        03 line 1 column 1 from ScreenHeader reverse-video.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode of CurrentAttendee.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 from Name of CurrentAttendee.
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
        03 line 24 column 1
            value "Commands: F1 Home, F4 Edit                                                   " reverse-video.
        03 line 24 column 78 to Command.


procedure division.

Setup section.
    perform EnableExtendedKeyInput
    perform SetupAttendeesDataFileName
    perform LoadDataFileIntoTable
.

Main section.
    perform until CommandKeyIsF10
        perform DisplayHomeScreen
    end-perform

    stop run.

DisplayHomeScreen section.
    perform SetupHomeScreenStats
    accept HomeScreen from crt end-accept
    evaluate true
        when CommandKeyIsF2
            perform ListAttendees
            set AddAttendeeFlagOn to false
            perform EditAttendee
        when CommandKeyIsF3 perform AddAttendee
        when CommandKeyIsF4 perform SearchAttendees
        when CommandKeyIsF9
            if ForegroundColour is equal to 7 then
                move 2 to ForegroundColour
            else
                add 1 to ForegroundColour
            end-if
    end-evaluate
.

ListAttendees section.
    sort Attendee
        on descending key Name of Attendee
        collating sequence is mixed

    move zero to PageOffset
    perform until CommandKeyIsF1 or CommandKeyIsEnter
        display ListScreen
        add 1 to PageOffset giving FirstRecordToShow
        move 3 to CurrentRow
        add PageOffset to RecordsPerPage giving LastRecordToShow
        perform varying CurrentAttendeeNumber from FirstRecordToShow by 1
            until CurrentAttendeeNumber greater than LastRecordToShow or
                CurrentAttendeeNumber equal to NumberOfAttendees
            display CurrentAttendeeNumber
                at line CurrentRow
                foreground-color ForegroundColour
            end-display
            display Name of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 6
                foreground-color ForegroundColour
            end-display
            display Email of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 31
                foreground-color ForegroundColour
            end-display
            display AuthCode of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 71
                foreground-color ForegroundColour
            end-display
            display AttendanceStatus of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 80
                foreground-color ForegroundColour
            end-display
            add 1 to CurrentRow
        end-perform
        accept RecordSelected at line 24 column 78 foreground-color ForegroundColour
        evaluate true also true
            when CommandKeyIsPgDn also LastRecordToShow is less than NumberOfAttendees
                add RecordsPerPage to PageOffset
            when CommandKeyIsPgUp also PageOffset is greater than or equal to RecordsPerPage
                subtract RecordsPerPage from PageOffset
        end-evaluate
    end-perform

    if CommandKeyIsEnter and RecordSelected greater than zero then
        move Attendee(RecordSelected) to CurrentAttendee
        set RecordFound to true
    end-if
.

SearchAttendees section.
    initialize CurrentAttendee
    perform until CommandKeyIsF1 or CommandKeyIsF2 or CommandKeyIsF5
        or CommandKeyIsF6 or CommandKeyIsF7
        accept SearchScreen from crt end-accept
        evaluate true
            when CommandKeyIsF2 perform ListAttendees
            when CommandKeyIsF5 perform SearchByAuthCode
            when CommandKeyIsF6 perform SearchByName
            when CommandKeyIsF7 perform SearchByEmail
        end-evaluate
    end-perform

    if RecordFound then
        perform EditAttendee
    end-if
.

LoadDataFileIntoTable section.
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        if not EndOfAttendeesFile then
            perform with test before varying NumberOfAttendees from 1 by 1 until EndOfAttendeesFile
                move AttendeeRecord to Attendee(NumberOfAttendees)
                read AttendeesFile next record
                    at end set EndOfAttendeesFile to true
                end-read
            end-perform
        end-if
    close AttendeesFile

    sort Attendee
        on descending key Name of Attendee
        collating sequence is mixed
.

SetupHomeScreenStats section.
        accept CurrentDayOfWeek from day-of-week
        initialize PeopleSignedUp, PeopleOnSite, PeopleToArrive, PeopleToArriveToday,
            KidsOnSite, KidsToArrive, KidsToArriveToday
        perform varying CurrentAttendeeNumber from 1 by 1
            until CurrentAttendeeNumber equal to NumberOfAttendees
                evaluate true
                    when AttendeeArrived of Attendee(CurrentAttendeeNumber)
                        add 1 to PeopleOnSite
                        add NumberOfKids of Attendee(CurrentAttendeeNumber) to KidsOnSite
                        if CanStayTillMonday of Attendee(CurrentAttendeeNumber) then
                            add 1 to PeopleStayingTillMonday
                        end-if
                    when AttendeeComing of Attendee(CurrentAttendeeNumber)
                        add 1 to PeopleToArrive
                        add NumberOfKids of Attendee(CurrentAttendeeNumber) to KidsToArrive
                        if ValidDayOfWeek(CurrentDayOfWeek) and
                            ArrivalDay of Attendee(CurrentAttendeeNumber) is greater than or equal to DayOfTheWeek(CurrentDayOfWeek) then
                            add 1 to PeopleToArriveToday
                            add NumberOfKids of Attendee(CurrentAttendeeNumber) to KidsToArriveToday
                        end-if
                end-evaluate
                add 1 to PeopleSignedUp
                add PeopleToArriveToday to PeopleOnSite giving PeopleToBeOnSiteToday
            end-perform

        add PeopleToArrive to PeopleOnSite giving TotalEstimatedAttendees
        add KidsToArrive to KidsOnSite giving TotalEstimatedKids
        .

AddAttendee section.
    initialize CurrentAttendee
    call "createAuthCode" using by reference AuthCode of CurrentAttendee
    move DayOfTheWeek(CurrentDayOfWeek) to ArrivalDay of CurrentAttendee
    set AttendeeArrived of CurrentAttendee to true
    set AttendeeNotPaid of CurrentAttendee to true
    move DefaultAmountToPay to AmountToPay of CurrentAttendee
    set AddAttendeeFlagOn to true
    set RecordFound to true
    perform EditAttendee
.

EditAttendee section.
    if not RecordFound then
        exit section
    end-if

    perform until CommandKeyIsF1 or CommandKeyIsF8
        accept EditAttendeeScreen from crt end-accept
        evaluate true
            when CommandKeyIsF8
                perform SaveAttendee
                perform ViewAttendee
            when CommandKeyIsF7
                evaluate true
                    when AttendeePaid of CurrentAttendee set AttendeeNotPaid of CurrentAttendee to true
                    when AttendeeNotPaid of CurrentAttendee set AttendeePaid of CurrentAttendee to true
                end-evaluate
            when CommandKeyIsF5
                evaluate true
                    when ArrivalDayIsWednesday of CurrentAttendee set ArrivalDayIsThursday of CurrentAttendee to true
                    when ArrivalDayIsThursday of CurrentAttendee set ArrivalDayIsFriday of CurrentAttendee to true
                    when ArrivalDayIsFriday of CurrentAttendee set ArrivalDayIsSaturday of CurrentAttendee to true
                    when ArrivalDayIsSaturday of CurrentAttendee set ArrivalDayIsWednesday of CurrentAttendee to true
                end-evaluate
            when CommandKeyIsF6
                evaluate true
                    when AttendeeComing of CurrentAttendee set AttendeeArrived of CurrentAttendee to true
                    when AttendeeArrived of CurrentAttendee set AttendeeCancelled of CurrentAttendee to true
                    when AttendeeCancelled of CurrentAttendee set AttendeeComing of CurrentAttendee to true
                end-evaluate
        end-evaluate
    end-perform
.

ViewAttendee section.
    perform until CommandKeyIsF1
        accept ViewAttendeeScreen end-accept
        evaluate true
            when CommandKeyIsF4 perform EditAttendee
        end-evaluate
    end-perform
.

SaveAttendee section.
    perform CreateTimeStampedBackupFile
    open i-o AttendeesFile
    evaluate true
        when AddAttendeeFlagOn
            add 1 to CurrentAttendeeNumber
            set NumberOfAttendees to CurrentAttendeeNumber
            move CurrentAttendee to Attendee(CurrentAttendeeNumber)
            write AttendeeRecord from Attendee(CurrentAttendeeNumber)
                invalid key
                    if RecordExists then
                        display "Record for " Name of Attendee(CurrentAttendeeNumber) "  already exists"
                    else
                        display "Error - status is " RecordStatus
                    end-if
            end-write
        when not AddAttendeeFlagOn
            move CurrentAttendee to Attendee(CurrentAttendeeNumber)
            rewrite AttendeeRecord from Attendee(CurrentAttendeeNumber)
                invalid key
                    if NoSuchRecord then
                        display "Record for " AuthCode of Attendee(CurrentAttendeeNumber) "  not found"
                    else
                        display "Error - status is " RecordStatus
                    end-if
                end-rewrite
    end-evaluate
    close AttendeesFile
.

SearchByAuthCode section.
    if AuthCodeToSearchFor is not HexNumber then
        set RecordFound to false
        exit section
    end-if

    search Attendee
        at end
            set RecordFound to false
        when upper-case(AuthCode of Attendee(AttendeeIndex)) is equal to upper-case(AuthCodeToSearchFor)
            set RowNumberFound to AttendeeIndex
            set RecordFound to true
    end-search

    if RecordFound then
        move Attendee(RowNumberFound) to CurrentAttendee
        move RowNumberFound to CurrentAttendeeNumber
    end-if
.

SearchByName section.
    search Attendee
        at end
            set RecordFound to false
        when upper-case(Name of Attendee(AttendeeIndex)) is equal to upper-case(NameToSearchFor)
            set RowNumberFound to AttendeeIndex
            set RecordFound to true
    end-search

    if RecordFound then
        move Attendee(RowNumberFound) to CurrentAttendee
        move RowNumberFound to CurrentAttendeeNumber
    end-if
.

SearchByEmail section.
    search Attendee
        at end
            set RecordFound to false
        when upper-case(Email of Attendee(AttendeeIndex)) is equal to upper-case(EmailToSearchFor)
            set RowNumberFound to AttendeeIndex
            set RecordFound to true
    end-search

    if RecordFound then
        move Attendee(RowNumberFound) to CurrentAttendee
        move RowNumberFound to CurrentAttendeeNumber
    end-if
.

EnableExtendedKeyInput section.
    set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'
    set environment 'COB_SCREEN_ESC' to 'Y'
.

SetupAttendeesDataFileName section.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 1 then
        accept AttendeesFileName from argument-value
    end-if
.

CreateTimeStampedBackupFile section.
    move concatenate(formatted-current-date("YYYYMMDDThhmmss"), ".bak") to BackupFileName
    open output BackupFile
    perform varying CurrentRow from 1 by 1
        until CurrentRow equal to NumberOfAttendees
        move Attendee(CurrentRow) to BackupRecord
        write BackupRecord
    end-perform
    close BackupFile
.

end program BAMS.
