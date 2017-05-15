identification division.
program-id. Stats.

data division.
working-storage section.
    01 TotalPaid pic 9(4) value zero.
    01 TotalToPay pic 9(4) value zero.
    01 TotalIncome pic 9(4) value zero.

    01 FigureOutput pic z,z99.

procedure division.
    call "Attendees"
    call "FinancialStats" using by reference TotalPaid, TotalToPay

    move TotalPaid to FigureOutput
    display "Total paid is:   " FigureOutput
    move TotalToPay to FigureOutput
    display "Total to pay is: " FigureOutput
    add TotalPaid to TotalToPay giving TotalIncome
    move TotalIncome to FigureOutput
    display "-----------------------"
    display "Total income is: " FigureOutput

    exit program
    .
end program Stats.
