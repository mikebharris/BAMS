01 Attendee.
    05 AttendeeName pic x(25) value spaces.
    05 Email    pic x(40) value spaces.
    05 AuthCode pic x(6) value all "0".
    05 AmountToPay pic 999 value 40.
    05 PaymentStatus pic a value "N".
        88 AttendeePaid values "Y", "y".
        88 AttendeeNotPaid values "N", "n".
    05 AmountPaid  pic 999 value zero.
    05 DatePaid value zeroes.
        10 CentuaryPaid pic 99.
        10 YearPaid pic 99.
        10 MonthPaid pic 99.
        10 DayPaid pic 99.
    05 Telephone    pic x(14) value spaces.
    05 ArrivalDay   pic xxx value spaces.
        88 ArrivalDayIsValid values "Sun","Mon","Tue","Wed", "Thu", "Fri", "Sat".
        88 ArrivalDayIsWednesday value "Wed".
        88 ArrivalDayIsThursday value "Thu".
        88 ArrivalDayIsFriday value "Fri".
        88 ArrivalDayIsSaturday value "Sat".
        88 ArrivalDayIsSunday value "Sun".
    05 NumberOfKids pic 9 value zero.
    05 AttendanceStatus pic a value "C".
        88 AttendeeComing values "C", "c".
        88 AttendeeArrived values "A", "a".
        88 AttendeeCancelled values "X", "x".
    05 StayingTillMonday pic 9 value 0.
        88 CanStayTillMonday value 1 when set to false is 0.
    05 Diet pic x(60) value spaces.
