identification division.
program-id. Attendees.

environment division.
input-output section.
    file-control.
        select optional AttendeesFile assign to AttendeeFileName
            organization is indexed
            access mode is dynamic
            record key is AuthCode of AttendeeRecord
            file status is AttendeeStatus.

data division.
file section.
    fd AttendeesFile is global.
        copy Attendee replacing Attendee by
            ==AttendeeRecord is global.
            88 EndOfAttendeesFile value high-values==.

working-storage section.
    01 AttendeeStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

    01 AttendeeFileName pic x(20) value "attendees.dat".
    01 BackupFileName   pic x(20) value "attendees.bak".

linkage section.
    01 AttendeesToArrive pic 999 value zero.
    01 AttendeesOnSite pic 999 value zero.
    01 CustomFileName pic x(20) value spaces.
    01 DayOfWeek pic x(3) value spaces.
        88 ValidDayOfWeek values "Wed", "Thu", "Fri", "Sat", "Sun".
    01 NumberOfAttendees pic 999 value zero.
    01 KidsToArrive pic 99 value zero.
    01 KidsOnSite pic 99 value zero.
    copy Attendee replacing Attendee by ==ThisAttendee is global==.
    01 ThisAuthCode pic x(6) value all "0".
    01 ThisEmail pic x(25) value spaces.
    01 ThisName pic x(25) value spaces.
    01 TotalPaid pic 9(4) value zero.
    01 TotalToPay pic 9(4) value zero.

procedure division.
    goback
    .

entry "SetAttendeesFileName" using CustomFileName.
    if CustomFileName not equal to spaces
        move CustomFileName to AttendeeFileName
        move AttendeeFileName to BackupFileName
        inspect BackupFileName replacing all ".dat" by ".bak"
    end-if
    goback.

entry "AddAttendee" using ThisAttendee
    call "C$COPY" using AttendeeFileName, BackupFileName, 0
    open i-o AttendeesFile
        write AttendeeRecord from ThisAttendee
            invalid key
                if RecordExists
                    display "Record for " Name of ThisAttendee "  already exists"
                else
                    display "Error - status is " AttendeeStatus
                end-if
        end-write
    close AttendeesFile
    goback
    .

entry "UpdateAttendee" using ThisAttendee
    call "C$COPY" using AttendeeFileName, BackupFileName, 0
    open i-o AttendeesFile
        move ThisAttendee to AttendeeRecord
        rewrite AttendeeRecord
            invalid key
                if NoSuchRecord
                    display "Record for " AuthCode of ThisAttendee "  not found"
                else
                    display "Error - status is " AttendeeStatus
                end-if
        end-rewrite
    close AttendeesFile
    goback
    .

entry "GetAttendeeByAuthCode" using ThisAuthCode, ThisAttendee
    initialize ThisAttendee
    open input AttendeesFile
    move ThisAuthCode to AuthCode of AttendeeRecord
    read AttendeesFile record into ThisAttendee
        key is AuthCode of AttendeeRecord
        invalid key display "Record for " ThisAuthCode " not found - " AttendeeStatus
    end-read
    close AttendeesFile
    goback
    .

entry "ListAttendees"
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            display AttendeeRecord
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    goback
    .

entry "AttendeeStats" using NumberOfAttendees, AttendeesOnSite, AttendeesToArrive, KidsOnSite, KidsToArrive
    move zero to NumberOfAttendees
    move zero to AttendeesOnSite
    move zero to AttendeesToArrive
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            evaluate true
                when AttendeeArrived of AttendeeRecord
                    add 1 to AttendeesOnSite
                    add NumberOfKids of AttendeeRecord to KidsOnSite
                when AttendeeComing of AttendeeRecord
                    add 1 to AttendeesToArrive
                    add NumberOfKids of AttendeeRecord to KidsToArrive
            end-evaluate
            add 1 to NumberOfAttendees
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    goback
    .

entry "FinancialStats" using TotalPaid, TotalToPay
    move zero to TotalPaid
    move zero to TotalToPay
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            evaluate true
                when AttendeePaid of AttendeeRecord
                    add AmountPaid of AttendeeRecord to TotalPaid
                when AttendeeNotPaid of AttendeeRecord
                    add AmountToPay of AttendeeRecord to TotalToPay
            end-evaluate
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    goback
    .

entry "AttendeesToArriveOnDay" using DayOfWeek, AttendeesToArrive, KidsToArrive
    initialize AttendeesToArrive, KidsToArrive
    if ValidDayOfWeek
        move zeroes to AuthCode of AttendeeRecord
        start AttendeesFile key is greater than AuthCode of AttendeeRecord
        open input AttendeesFile
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
            perform until EndOfAttendeesFile
                evaluate true
                    when AttendeeComing of AttendeeRecord
                        and ArrivalDay of AttendeeRecord is equal to DayOfWeek
                            add 1 to AttendeesToArrive
                            add NumberOfKids of AttendeeRecord to KidsToArrive
                end-evaluate
                read AttendeesFile next record
                    at end set EndOfAttendeesFile to true
                end-read
            end-perform
        close AttendeesFile
    end-if
    goback
    .

end program Attendees.
