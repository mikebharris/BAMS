# BAMS
The BarnCamp Attendee Management System

A system for managing the Welcome Desk at [BarnCamp](https://barncamp.org.uk) written in GNU COBOL.


![Screen shot of BAMS Home Screen](homepage.png "BAMS Home Screen")

## Compiling

Firstly, Good Luck!  You'll need version 2.0 of [GNU COBOL](https://sourceforge.net/projects/open-cobol/) to compile this code.

I can compile it on Mac OS X 10.12 and under Debian GNU/Linux (kernel 3.16.0-4-amd64) with:
```
cobc -x -free -std=default bams.cbl Attendees.cbl createAuthCode.cbl AttendeesList.cbl
```

## Setting up data

First compile the data importer:
```
cobc -std=default -x -free ImportAttendees.cbl
```
Now run it to import the test data:
```
./ImportAttendees bams-test-data.csv test-data.dat
```
Or real data:
```
./ImportAttendees <name of real csv file> attendees.dat
```

## Run BAMS

Just run it with:
 ```
 ./bams
 ```

or optionally with a specific data file:
 ```
 ./bams path/to/data-file.dat
 ```

## Run the test suite

To run the test suite, you'll need to download and build [COBOL Test Suite](https://github.com/mikebharris/COBOL-Test-Suite).

First import the test data (see above).

Next compile the test suite:
```
cobc -x -std=default -free AttendeesTest.cbl Attendees.cbl createAuthCode.cbl path/to/COBOL-Test-Suite/AssertEquals.cbl
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

