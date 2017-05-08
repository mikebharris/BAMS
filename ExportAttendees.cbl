identification division.
program-id. ExportAttendees.

environment division.
    configuration section.
        repository.
            function all intrinsic.

input-output section.
file-control.
    select CSVFile assign to CSVFileName
        organization is line sequential.

    select optional AttendeesFile assign to AttendeesFileName
        organization is indexed
        access mode is dynamic
        record key is AuthCode.

data division.
file section.
fd CSVFile.
    01 CSVFileOutputLine pic x(255) value spaces.
        88 EndOfCSVFile value high-values.

fd AttendeesFile is global.
    copy DD-Attendee replacing Attendee by
        ==AttendeeRecord is global.
        88 EndOfAttendeesFile value high-values==.

working-storage section.
    01 CountOfLinesProcessed pic 999 value zero.

    01 AttendeesFileName pic x(20) value spaces.
    01 CSVSourceFileName pic x(30) value spaces.
    01 CommandLineArgumentCount pic 9 value zero.

procedure division.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 2 then
        accept AttendeesFileName from argument-value
        accept CSVFileName from argument-value
    else
        display "Usage: ExportAttendees <BAMS Data File> <CSV Output File>"
        stop run
    end-if
    display "Reading from " trim(AttendeesFileName) " and writing to " trim(CSVFileName)
    open output CSVFile
    write CSVFileOutputLine from "AuthCode,Name,Email,AmountToPay,AmountPaid,DatePaid,Telephone,ArrivalDay,StayingLate,NumberOfKids,Diet"
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            initialize CSVFileOutputLine
            string
                trim(AuthCode) delimited by size
                ","
                trim(Name) delimited by size
                ","
                trim(Email) delimited by size
                ","
                trim(AmountToPay) delimited by size
                ","
                trim(AmountPaid) delimited by size
                ","
                trim(DatePaid) delimited by size
                ","
                trim(Telephone) delimited by size
                ","
                trim(ArrivalDay) delimited by size
                ","
                trim(StayingTillMonday) delimited by size
                ","
                trim(NumberOfKids) delimited by size
                ","
                trim(Diet) delimited by size
                into CSVFileOutputLine
            end-string
            display CSVFileOutputLine
            write CSVFileOutputLine
            add 1 to CountOfLinesProcessed
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    close CSVFile
    display "Total attendees exported to CSV is " CountOfLinesProcessed
stop run
.

end program ExportAttendees.
