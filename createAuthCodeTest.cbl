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
    01 TestCount pic 99 value zero.
    01 CharPosition pic 9 value zero.
    01 ZeroFound pic x value "N".
        88 ZeroWasFound value "Y" when set to false is "N".
    *> used to wait for clock tick change so each createAuthCode call gets a unique seed
    01 LastTimeTick pic 9(8) value zero.
    01 CurrentTimeTick pic 9(8) value zero.

procedure division.
    *> Test 1: generated code must be valid hex
    call "createAuthCode" using by reference AuthCode
    if AuthCode is HexNumber then
        display "PASS: valid AuthCode returned " AuthCode
    else
        display "FAIL: invalid AuthCode returned " AuthCode
    end-if

    *> Test 2: all 16 hex digits including "0" must be reachable
    *> createAuthCode seeds from the centisecond clock, so calls within the same
    *> hundredth of a second produce identical output. We wait for the tick to
    *> change between each call to guarantee a unique seed each time.
    *> 20 codes x 6 digits = 120 draws; P(no zero with fair generator) is ~0.03%
    set ZeroWasFound to false
    accept LastTimeTick from time
    perform varying TestCount from 1 by 1
            until TestCount greater than 20 or ZeroWasFound
        perform until CurrentTimeTick not equal to LastTimeTick
            accept CurrentTimeTick from time
        end-perform
        move CurrentTimeTick to LastTimeTick
        call "createAuthCode" using by reference AuthCode
        perform varying CharPosition from 1 by 1 until CharPosition greater than 6
            if AuthCode(CharPosition:1) equal to "0"
                set ZeroWasFound to true
            end-if
        end-perform
    end-perform
    if ZeroWasFound then
        display "PASS: digit 0 found in generated AuthCodes"
    else
        display "FAIL: digit 0 never generated - range bias in formula"
    end-if

    stop run
    .
end program createAuthCodeTest.
