
# BAMS modular version using ENTRY

I tried originally to write a version using COBOL's ENTRY to create a kind of encapsulated, OO-like approach to creating an Attendee object that BAMS and it's supplementary utilities would then use.  I also wanted to do it using test-driven development, which I was able to do.

The problem was that although it all worked swimmingly under OS X, it wouldn't compile under Linux, which was the target platform, and so I had to abandon my plan.

To run the test suite, you'll need to download [COBOL Test Suite](https://github.com/mikebharris/COBOL-Test-Suite).

First import the test data (see above).

Next compile the test suite:
```
cobc -x -std=default -free AttendeesTest.cbl Attendees.cbl ../createAuthCode.cbl path/to/COBOL-Test-Suite/AssertEquals.cbl
```
Now run the test suite:
````
./AttendeesTest
Cyder Punk               anicedrop@riseup.net                    123456035N0002017010401234 567 890 Fri0C
Zak Mindwarp             zak@mindwarp.io                         ABCDEF050Y0502017010101234 567 890 Wed0C
Ronald Chump             r.chump@whitehouse.gov                  BCDEF1050N0000000000001234 567 890 Fri1C
Joe Bloggs               joe@bloggs.com                          CDEF12035N0002017010101234 567 890 Fri2C
Random Guy               somebody@somewhere.net                  DEF123035N0000000000001234 567 890 Wed0C
Undercover Agent         obviouscrusty@gmail.com                 EF1234035N0002017010301234 567 890 Fri0C
Cynthia Underhill        cynthia234@hotmail.com                  F12345035N0002017010301234 567 890 Fri0C
Passed: TestReturnCountOfAttendees: Correct number of attendees returned: 7
Passed: TestImportedRecordExists: Result returns the correct details for first Attendee
Passed: Result returns the correct details for added Attendee with AuthCode of
Passed: Number of attendees not incremented for record update: 7
Passed: TestCanAddAnotherAttendee: Result returns the correct details for added Attendee
Passed: TestReturnCountOfAttendees: Correct number of attendees returned: 8
Passed: TestReturnTotalNumberOfKids: Correct number of kids returned: 6
Passed: TestShouldUpdateNumberOfKids: Correct number of kids returned: 8
Passed: TestAttendeeStats: Correct TOTAL number of attendees returned: 8
Passed: TestAttendeeStats: Correct number of attendees ON-Site returned: 1
Passed: TestAttendeeStats: Correct number of attendees TO ARRIVE returned: 7
Passed: TestAttendeeStats: Correct number of kids TO ARRIVE returned: 6
Passed: TestAttendeeStats: Correct number of kids TO On-Site returned: 2
Passed: TestFetchAttendeeByEmail: Result returned the correct details for Attendee
Passed: TestFetchAttendeeByName: Result returned the correct details for Attendee
Passed: TestFetchAttendeesToArriveOnDay: Correct number of attendees returned for Wednesday arrivals
Passed: TestFetchAttendeesToArriveOnDay: Correct number of kids returned for Wednesday arrivals
Passed: TestFetchAttendeesToArriveOnDay: Correct number of attendees returned for Friday arrivals
Passed: TestFetchAttendeesToArriveOnDay: Correct number of kids returned for Friday arrivals
Passed: TestCanFetchTotalOfMoney: Correct amount of money paid returned
Passed: TestCanFetchTotalOfMoney: Correct amount of money to pay returned
Cyder Punk               anicedrop@riseup.net                    123456035N0002017010401234 567 890 Fri0C
Jose Cuervo              jose@cuervo.es                          7CE3Y7000 00000000000              Wed3C
Zak Mindwarp             zak@mindwarp.io                         ABCDEF050Y0502017010101234 567 890 Wed2A
Ronald Chump             r.chump@whitehouse.gov                  BCDEF1050N0000000000001234 567 890 Fri1C
Joe Bloggs               joe@bloggs.com                          CDEF12035N0002017010101234 567 890 Fri2C
Random Guy               somebody@somewhere.net                  DEF123035N0000000000001234 567 890 Wed0C
Cover Broken             obviouscrusty@gmail.com                 EF1234035N0002017010301234 567 890 Fri0C
Cynthia Underhill        cynthia234@hotmail.com                  F12345035N0002017010301234 567 890 Fri0C
````
