identification division.
function-id. createAuthCode.

data division.
local-storage section.
    01 CurrentTime.
        02 filler   pic 9(4).
        02 Seed     pic 9(4).

    01 DecimalDigit pic 99 value zero.
    01 CurrentDigit pic 9 value zero.
    01 HexDigits    pic x(16) value "0123456789ABCDEF".

linkage section.
    01 NewAuthCode pic x(6) value zero.

procedure division returning NewAuthCode.
    accept CurrentTime from time
    compute DecimalDigit = function random(Seed)
    perform with test after varying CurrentDigit from 1 by 1
        until CurrentDigit equal to 6
        compute DecimalDigit = (function random * 15) + 1
        move HexDigits(DecimalDigit + 1:1) to NewAuthCode(CurrentDigit:1)
    end-perform
    goback
    .
end function createAuthCode.
