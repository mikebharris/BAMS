identification division.
program-id. createAuthCodeTest.

environment division.
configuration section.
    special-names.
        class HexNumber is "0" thru "9",
                           "A" thru "F",
                           "a" thru "f".

data division.
working-storage section.
    01 AuthCode pic x(6) value zero.

procedure division.
    call "createAuthCode" using by reference AuthCode
    if AuthCode is HexNumber then
        display "Valid AuthCode returned " AuthCode
    else
        display "Invalid AuthCode retunred " AuthCode
    end-if
    stop run
    .
end program createAuthCodeTest.
