identification division.
program-id. Stats.

data division.
working-storage section.
    01 TotalPaid pic 9(4) value zero.
    01 TotalToPay pic 9(4) value zero.
    01 TotalIncome pic 9(4) value zero.
    01 NumberOfAttendees pic 9(3) value zero.
    01 AveragePaid pic 99v99 value zero.
    01 IgnoredValue pic 9(4).

    01 FigureOutput pic z,z99.99.

procedure division.
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

    exit program
    .
end program Stats.
