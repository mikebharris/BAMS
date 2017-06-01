identification division.
program-id. BarnCampReport is initial.

environment division.
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
        copy DD-Attendee replacing Attendee by
            ==AttendeeRecord is global.
            88 EndOfAttendeesFile value high-values==.

working-storage section.
    01 AttendeeStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

    01 HeadCounts.
        02 HeadCountWednesday pic 99 value zero.
        02 HeadCountThursday pic 99 value zero.
        02 HeadCountFriday pic 99 value zero.
        02 HeadCountSaturday pic 99 value zero.
        02 HeadCountSunday pic 99 value zero.
        02 HeadCountMonday pic 99 value zero.

    01 TotalNightsCamping pic 999 value zero.
    01 CostPerNight constant as 2.
    01 TotalCampingCharge pic 999v99 value 0.00.

    01 TotalPaid pic 9(4) value zero.
    01 TotalToPay pic 9(4) value zero.
    01 TotalIncome pic 9(4) value zero.
    01 NumberOfAttendees pic 9(3) value zero.
    01 AveragePaid pic 99v99 value zero.
    01 IgnoredValue pic 9(4).

    01 FigureOutput pic z,z99.99.

    01 AttendeesFileName pic x(20) value spaces.
    01 CommandLineArgumentCount pic 9 value zero.

procedure division.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 2 then
        accept AttendeesFileName from argument-value
    else
        move "attendees.dat" to AttendeesFileName
    end-if
    display spaces
    display "Special diet report"
    display "==================="
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            if function length(function trim(Diet)) is greater than 5  then
                display function trim(Name) " says '" function trim (Diet) "'"
            end-if
            if AttendeeArrived then
                evaluate true
                    when ArrivalDayIsWednesday add 1 to HeadCountWednesday
                    when ArrivalDayIsThursday add 1 to HeadCountThursday
                    when ArrivalDayIsFriday add 1 to HeadCountFriday
                    when ArrivalDayIsSaturday add 1 to HeadCountSaturday
                end-evaluate
                if CanStayTillMonday then
                    add 1 to HeadCountMonday
                end-if
            end-if
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile

    add HeadCountWednesday to HeadCountThursday
    add HeadCountThursday to HeadCountFriday
    add HeadCountFriday to HeadCountSaturday
    add HeadCountSaturday to HeadCountSunday

    display spaces
    display "Attendance report"
    display "================"

    display "Wednesday: " HeadCountWednesday
    display "Thursday:  " HeadCountThursday
    display "Friday:    " HeadCountFriday
    display "Saturday:  " HeadCountSaturday
    display "Sunday:    " HeadCountSunday
    display "Monday:    " HeadCountMonday

    compute TotalNightsCamping = HeadCountWednesday + HeadCountThursday + HeadCountFriday + HeadCountSaturday + HeadCountMonday
    multiply CostPerNight by TotalNightsCamping giving TotalCampingCharge

    display "-----------------"

    display "Nights:    " TotalNightsCamping
    display "Charge:    " TotalCampingCharge

    display spaces
    display "Financial report"
    display "================"

    call "Attendees"
    call "FinancialStats" using by reference TotalPaid, TotalToPay

    display spaces
    move TotalPaid to FigureOutput
    display "Total paid is:   " FigureOutput
    move TotalToPay to FigureOutput
    display "Total to pay is: " FigureOutput
    add TotalPaid to TotalToPay giving TotalIncome
    move TotalIncome to FigureOutput
    display "-------------------------"
    display "Total income is: " FigureOutput

    call "AttendeeStats" using by reference NumberOfAttendees, IgnoredValue, IgnoredValue, IgnoredValue, IgnoredValue
    divide TotalIncome by NumberOfAttendees giving AveragePaid rounded mode is away-from-zero
    display spaces
    display "Average paid is:    " AveragePaid
    display spaces

    exit program.

end program BarnCampReport.
