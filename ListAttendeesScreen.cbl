identification division.
program-id. ListAttendeesScreen is initial.

environment division.
configuration section.
    special-names.
        crt status is Operation.

input-output section.
    file-control.
        select optional AttendeesFile assign to AttendeesFileName
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
    01 Attendee occurs 200 times.
        02 Name     pic x(25) value spaces.
        02 Email    pic x(40) value spaces.
        02 AuthCode pic x(6) value all "0".

    01 RecordCount pic 999.
    01 RecordSelected pic 999.
    78 RecordsPerPage value 20.
    01 PageOffset pic 999 value 1.
    01 FirstRecordToShow pic 999 value 1.
    01 LastRecordToShow pic 999 value 20.
    01 CurrentRow pic 99 value zero.
    01 CurrentAttendeeNumber pic 999 value zero.

    01 AttendeeStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

    copy Operation.

linkage section.
    01 AttendeesFileName pic x(20) value "attendees.dat".
    01 ReturnAuthCode pic x(6) value all "0".

screen section.
    01 HomeScreen background-color 0 foreground-color 2 highlight.
        03 blank screen background-color 0 foreground-color 5.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video.
        03 line 2 column 1 value "Num" highlight underline.
        03 line 2 column 6 value "Name" highlight underline.
        03 line 2 column 31 value "Email" highlight underline.
        03 line 2 column 71 value "AuthCode" highlight underline.
        03 line 24 column 1 value "Commands: PgUp/PgDown to scroll, Enter number and press ENTER, F10 Exit        " reverse-video highlight.

procedure division using AttendeesFileName, ReturnAuthCode.

    set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'
    set environment 'COB_SCREEN_ESC' to 'Y'

    initialize ReturnAuthCode
    move zero to RecordCount
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            add 1 to RecordCount
            move Name of AttendeeRecord to Name of Attendee(RecordCount)
            move Email of AttendeeRecord to Email of Attendee(RecordCount)
            move AuthCode of AttendeeRecord to AuthCode of Attendee(RecordCount)
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile

    move zero to PageOffset
    perform until OperationIsExit or OperationIsFinish
        display HomeScreen
        add 1 to PageOffset giving FirstRecordToShow
        move 3 to CurrentRow
        add PageOffset to RecordsPerPage giving LastRecordToShow
        perform varying CurrentAttendeeNumber from FirstRecordToShow by 1
            until CurrentAttendeeNumber greater than LastRecordToShow or
                CurrentAttendeeNumber greater than RecordCount
            display CurrentAttendeeNumber
                at line CurrentRow
                foreground-color 2
            end-display
            display Attendee(CurrentAttendeeNumber)
                at line CurrentRow
                column 6
                foreground-color 2
            end-display
            add 1 to CurrentRow
        end-perform
        accept RecordSelected at line 24 column 78 foreground-color 2
        evaluate true also true
            when OperationIsNextPage also LastRecordToShow is less than RecordCount
                add RecordsPerPage to PageOffset
            when OperationIsPrevPage also PageOffset is greater than or equal to RecordsPerPage
                subtract RecordsPerPage from PageOffset
        end-evaluate
    end-perform

    if OperationIsFinish and RecordSelected greater than zero then
        move AuthCode of Attendee(RecordSelected) to ReturnAuthCode
    end-if

    goback.

end program ListAttendeesScreen.
