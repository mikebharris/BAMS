identification division.
program-id. BAMS.

environment division.
configuration section.
    special-names.
        crt status is CommandKeys.
        *> Reverse case-folded alphabet: descending sort on this sequence produces visible A-Z order
        alphabet mixed is " ZzYyXxWwVvUuTtSsRrQqPpOoNnMmLlKkJjIiHhGgFfEeDdCcBbAa".
        *> 6 hex digits = 16^6 = 16.7M possible AuthCodes, sufficient for any realistic event size
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".
    repository.
        function all intrinsic.

input-output section.
    file-control.
        *> optional: program starts cleanly before first import run
        select optional AttendeesFile assign to AttendeesFileName
            organization is indexed
            access mode is dynamic
            record key is AuthCode of AttendeeRecord
            file status is DataFileStatus.
            
        select EventFile assign to EventFileName
            organization is line sequential.

        select optional BackupFile assign to BackupFileName
            organization is line sequential.
            
data division.
file section.
fd AttendeesFile.
copy DD-Attendee replacing Attendee by
    ==AttendeeRecord.
    88 EndOfAttendeesFile value high-values==.

fd EventFile.
copy DD-HlEvent replacing HlEvent by
    ==EventRecord.
    88 EndOfEventFile value high-values==.

fd BackupFile.
copy DD-Attendee replacing Attendee by
    ==BackupRecord.
    88 EndOfBackupFile value high-values==.

working-storage section.
01 AddAttendeeFlag pic x value "N".
    88 AddAttendeeFlagOn value "Y" when set to false is "N".

01 AttendeesFileName pic x(255) value "attendees.dat".
01 EventFileName pic x(20) value "event.dat".
01 BackupFileName pic x(19).

01 DataFileStatus   pic x(2).
    88 Successful   value "00".
    88 RecordExists value "22".
    88 NoSuchRecord value "23".

01 AttendeesTable.
copy DD-Attendee replacing 01 by 02 Attendee by
    ==Attendee occurs 1 to 200 times
            depending on NumberOfAttendees
            indexed by AttendeeIndex==.

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

01 EventDetails.
    02 EventName pic x(40) value "HacktionLab".
    02 EventBaseCharge pic 999 value zero.
    02 EventStartDay value "Fri".
    02 EventEndDay value "Sun".
    
01 EventNamePosition pic 99 value 8.

01 NameToSearchFor pic x(25).
01 NumberOfAttendees pic 999.

01 Command pic x.
copy DD-CommandKeys.

01 CommandLineArgumentCount pic 9 value zero.

copy DD-Attendee replacing Attendee by
        ==CurrentAttendee==.

01 CurrentAttendeeNumber pic 999 value zero.
01 CurrentRow pic 99 value zero.
01 BackupRowCounter pic 999 value zero.

01 CurrentDayOfWeek pic 9 value zero.
01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
    02 DayOfTheWeek pic xxx occurs 7 times.
        88 ValidDayOfWeek values "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun".
        
01 FirstRecordToShow pic 999 value 1.

01 ColourScheme.
    88 ColourSchemeIsMonochrome value 02.
    88 ColourSchemeIsColour value 17.
    02 BackgroundColour pic 9 value 0.
    02 ForegroundColour pic 9 value 2.

01 LastRecordToShow pic 999 value 20.
01 PageOffset pic 999 value 1.
01 RecordsPerPage constant as 20.
01 RecordSelected pic 999.

01 RecordStatus pic 9 value 0.
    88 RecordFound value 1 when set to false is 0.

copy DD-ScreenHeader.

screen section.
copy SC-HomeScreen.
copy SC-EditScreen.
copy SC-ListScreen.
copy SC-SearchScreen.
copy SC-ViewScreen.
       
procedure division.

Main section.
    perform EnableExtendedKeyInput
    perform LoadEventAndAttendeeData
    perform LoadEventDetails
    perform LoadDataFileIntoTable
    set ColourSchemeIsColour to true

    perform until CommandKeyIsF10
        perform DisplayHomeScreen
    end-perform

    stop run
.

EnableExtendedKeyInput section.
    *> GNU COBOL requires these at runtime to capture function keys and ESC via CRT STATUS
    set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'
    set environment 'COB_SCREEN_ESC' to 'Y'
.

LoadEventDetails section.
    open input EventFile
       read EventFile next record
           at end set EndOfEventFile to true
       end-read
       if not EndOfEventFile then
           move EventRecord to EventDetails
       end-if
    close EventFile
    compute EventNamePosition = 40 - (length(trim(EventName of EventDetails)) / 2)
.

LoadEventAndAttendeeData section.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount greater than zero then
        accept AttendeesFileName from argument-value
    end-if
    if CommandLineArgumentCount equal to 2 then
       accept EventFileName from argument-value
    end-if   
.

LoadDataFileIntoTable section.
    *> position past the zero key so we read from the first real record
    move zeroes to AuthCode of AttendeeRecord
    open input AttendeesFile
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        move zero to NumberOfAttendees
        perform until EndOfAttendeesFile
            add 1 to NumberOfAttendees
            move AttendeeRecord to Attendee(NumberOfAttendees)
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile

    *> descending + mixed collating sequence = case-insensitive A-Z order on screen
    sort Attendee
        on descending key AttendeeName of Attendee
        collating sequence is mixed
.

DisplayHomeScreen section.
    perform SetupHomeScreenStats
    accept HomeScreen from crt end-accept
    evaluate true
        when CommandKeyIsF2
            perform ListAttendees
            perform EditAttendee
        when CommandKeyIsF3 perform AddAttendee
        when CommandKeyIsF4 perform SearchAttendees
        when CommandKeyIsF9
            if ColourSchemeIsMonochrome then
                set ColourSchemeIsColour to true
            else
                set ColourSchemeIsMonochrome to true
            end-if
        when CommandKeyIsF12 perform UploadToClams
    end-evaluate
.

SetupHomeScreenStats section.
    accept CurrentDayOfWeek from day-of-week
    initialize PeopleSignedUp, PeopleOnSite, PeopleToArrive, PeopleToArriveToday,
        PeopleStayingTillMonday, KidsOnSite, KidsToArrive, KidsToArriveToday
    perform varying CurrentAttendeeNumber from 1 by 1
        until CurrentAttendeeNumber greater than NumberOfAttendees
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

ListAttendees section.
    sort Attendee
        on descending key AttendeeName of Attendee
        collating sequence is mixed

    move zero to PageOffset
    perform until CommandKeyIsF1 or CommandKeyIsEnter
        display ListScreen
        add 1 to PageOffset giving FirstRecordToShow
        move 3 to CurrentRow
        add PageOffset to RecordsPerPage giving LastRecordToShow
        perform varying CurrentAttendeeNumber from FirstRecordToShow by 1
            until CurrentAttendeeNumber greater than LastRecordToShow or
                CurrentAttendeeNumber greater than NumberOfAttendees
            display CurrentAttendeeNumber
                at line CurrentRow
                background-color BackgroundColour
                foreground-color ForegroundColour
            end-display
            display AttendeeName of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 6
                background-color BackgroundColour
                foreground-color ForegroundColour
            end-display
            display Email of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 31
                background-color BackgroundColour
                foreground-color ForegroundColour
            end-display
            display AuthCode of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 71
                background-color BackgroundColour
                foreground-color ForegroundColour
            end-display
            display AttendanceStatus of Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 80
                background-color BackgroundColour
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

    if CommandKeyIsEnter
            and RecordSelected greater than zero
            and RecordSelected is less than or equal to NumberOfAttendees then
        move Attendee(RecordSelected) to CurrentAttendee
        move RecordSelected to CurrentAttendeeNumber
        set RecordFound to true
        set AddAttendeeFlagOn to false
    else
        set RecordFound to false
    end-if
.

EditAttendee section.
    if not RecordFound then
        exit section
    end-if

    perform until CommandKeyIsF1 or CommandKeyIsF8
        accept EditScreen from crt end-accept
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
                    when ArrivalDayIsSaturday of CurrentAttendee set ArrivalDayIsSunday of CurrentAttendee to true
                    when other set ArrivalDayIsThursday of CurrentAttendee to true
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

SaveAttendee section.
    perform CreateTimeStampedBackupFile
    open i-o AttendeesFile
    evaluate true
        when AddAttendeeFlagOn
            add 1 to NumberOfAttendees
            move CurrentAttendee to Attendee(NumberOfAttendees)
            write AttendeeRecord from Attendee(NumberOfAttendees)
                invalid key
                    display "Error saving new attendee: " DataFileStatus
            end-write
            move NumberOfAttendees to CurrentAttendeeNumber
        when not AddAttendeeFlagOn
            move CurrentAttendee to Attendee(CurrentAttendeeNumber)
            rewrite AttendeeRecord from Attendee(CurrentAttendeeNumber)
                invalid key
                    display "Error updating attendee: " DataFileStatus
            end-rewrite
    end-evaluate
    close AttendeesFile
.

CreateTimeStampedBackupFile section.
    move concatenate(formatted-current-date("YYYYMMDDThhmmss"), ".bak") to BackupFileName
    open output BackupFile
    perform varying BackupRowCounter from 1 by 1
        until BackupRowCounter greater than NumberOfAttendees
        move Attendee(BackupRowCounter) to BackupRecord
        write BackupRecord
    end-perform
    close BackupFile
.

ViewAttendee section.
    perform until CommandKeyIsF1
        accept ViewScreen end-accept
        evaluate true
            when CommandKeyIsF3 perform AddAttendee
            when CommandKeyIsF4 perform EditAttendee
        end-evaluate
    end-perform
.

AddAttendee section.
    initialize CurrentAttendee
    call "createAuthCode" using by reference AuthCode of CurrentAttendee
    move DayOfTheWeek(CurrentDayOfWeek) to ArrivalDay of CurrentAttendee
    set AttendeeComing of CurrentAttendee to true
    set AttendeeNotPaid of CurrentAttendee to true
    move EventBaseCharge of EventDetails to AmountToPay of CurrentAttendee
    set AddAttendeeFlagOn to true
    set RecordFound to true
    perform EditAttendee
.

SearchAttendees section.
    initialize CurrentAttendee
    set RecordFound to false
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

SearchByAuthCode section.
    if AuthCodeToSearchFor is not HexNumber then
        exit section
    end-if

    search Attendee
        when upper-case(AuthCode of Attendee(AttendeeIndex)) is equal to upper-case(AuthCodeToSearchFor)
            perform SetCurrentAttendeeToFound
    end-search
.

SearchByName section.
    search Attendee
        when upper-case(AttendeeName of Attendee(AttendeeIndex)) is equal to upper-case(NameToSearchFor)
            perform SetCurrentAttendeeToFound
    end-search
.

SearchByEmail section.
    search Attendee
        when upper-case(Email of Attendee(AttendeeIndex)) is equal to upper-case(EmailToSearchFor)
            perform SetCurrentAttendeeToFound
    end-search
.

SetCurrentAttendeeToFound section.
    set CurrentAttendeeNumber to AttendeeIndex
    move Attendee(CurrentAttendeeNumber) to CurrentAttendee
    set RecordFound to true
.

UploadToClams section.
    call "SYSTEM" using "./clams-upload.sh"
    if return-code not equal zero
        display "Upload to CLAMS failed with error " return-code
    end-if
.

end program BAMS.
