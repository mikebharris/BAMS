01 Attendee.
    02 Name     pic x(25) value spaces.
    02 Email    pic x(40) value spaces.
    02 AuthCode pic x(6) value all "0".
    02 AmountToPay pic 999 value 40.
    02 PaymentStatus pic a value "N".
        88 AttendeePaid values "Y", "y".
        88 AttendeeNotPaid values "N", "n".
    02 AmountPaid  pic 999 value zero.
    02 DatePaid value zeros.
        03 CentuaryPaid pic 99.
        03 YearPaid pic 99.
        03 MonthPaid pic 99.
        03 DayPaid pic 99.
    02 Telephone    pic x(14) value spaces.
    02 ArrivalDay   pic xxx value spaces.
        88 ArrivalDayIsWednesday value "Wed".
        88 ArrivalDayIsThursday value "Thu".
        88 ArrivalDayIsFriday value "Fri".
        88 ArrivalDayIsSaturday value "Sat".
    02 NumberOfKids pic 9 value zero.
    02 AttendanceStatus pic a value "C".
        88 AttendeeComing values "C", "c".
        88 AttendeeArrived values "A", "a".
        88 AttendeeCancelled values "X", "x".
