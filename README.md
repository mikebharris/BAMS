# BAMS
The BarnCamp Attendee Management System

A system for managing the Welcome Desk at [BarnCamp](https://barncamp.org.uk) written in GNU COBOL.


![Screen shot of BAMS Home Screen](homepage.png "BAMS Home Screen")

## Compiling

Firstly, Good Luck!  You'll need version 2.0 of [GNU COBOL](https://sourceforge.net/projects/open-cobol/) to compile this code.

I can compile it on Mac OS X 10.12 and under Debian GNU/Linux (kernel 3.16.0-4-amd64) with:
```
cobc -x -free -std=default bams.cbl Attendees.cbl createAuthCode.cbl ListAttendeesScreen.cbl
```

I have had huge problems trying to get it to compile under Linux using this modular approach, and so I had to merge it back down into a monolithic version and loose the test suite for it.  You can compile this version with:
```
cobc -x -free -std=default -o bams  bams-monolith.cbl createAuthCode.cbl ListAttdendeesScreen.cbl
```

To get version 2.0 of GNU COBOL compiler (cobc), download it from https://sourceforge.net/projects/open-cobol/files/gnu-cobol/2.0/ (rc2 is the latest at the time of typing), untar/zip it, and (on Linux) do:
```
./configure --with-curses=check --prefix=/usr/local CPPFLAGS=-I/usr/local/include/ LDFLAGS=-L/usr/local/lib
make
make install
```
Check which version is running with:
```
which cobc
```
This should be the version '/usr/local/bin/cobc' but if it isn't, replace 'cobc' in the command lines to compile with '/usr/local/bin/cobc'.

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

To run the test suite, you'll need to download [COBOL Test Suite](https://github.com/mikebharris/COBOL-Test-Suite).

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

# Using BAMS

BAMS is a classic console application that strives to use the keyboard to do things as much as possible.  To this end a set of different function and other control keys on a standard PC or Macintosh keyboard has been chosen to help you navigate the program.  We have striven to make the same key do the same kind of thing on every screen where it's used.   The operations of the keys are as follows:

* F1 - Return to the BAM Home Screen (available on all screens about from the Home Screen itself).
* F2 - Enter/Search for and View a given attendee already in the system.
* F3 - Add a new attendee to the system.
* F4 - Edit a given attendee already in the system.
* F5 - Toggle the arrival day of an attendee between Wednesday, Thursday, Friday and Saturday.
* F6 - Toggle the attendance status of an attendee between Coming, Arrived or Cancelled.
* F7 - Toggle the payment status of an attendee between Paid and Not Paid.
* F8 - Save and changes to the current attendee selected.
* F10 - Exit BAMS and return to the operating system, or the BAMS Home Screen when using the List Attendees Screen (actually a subprogram).
* PgUp/PgDown - Scroll screen-by-screen through a list of attendees.
* ENTER - Tell BAMS to accept the data in the current input field and input.

All other keys should more or less work as one might expect.

## Home Screen

The home screen looks like this:

![Screen shot of BAMS Home Screen](screenshots/home-screen.png "BAMS Home Screen")

In the middle you can see what the day is, and you can immediately tell how many adults and children are attending and how many are on-site already, and are to arrive.  There are three function key options:

* F2 - View a given attendee, which takes you to the Enter Authcode Screen.
* F3 - Add a new attendee, which takes you to the Add Attendee Screen.
* F10 - Exit BAMS and return to the operating system.

## Enter Authcode Screen

Pressing F2 from the Home Screen will take you to the Enter Authcode Screen, which looks like this:
![Screen shot of BAMS Enter Authcode Screen](screenshots/enter-authcode-screen.png "BAMS Enter Authcode Screen")

You have four options:

* Type in the desired Authcode and press enter.  If the Authcode entered exists, you'll arrive at the View Attendee screen.
* F1 - go back to the Home Screen
* F2 - Rather than enter the Authcode, go to the List Attendees Screen to search for it
* F10 - Exit BAMS and return to the operating system

## List Attendees Screen
![Screen shot of BAMS List Attendees Screen](screenshots/list-attendees-screen.png "BAMS List Attendees Screen")

## View Attendee Screen
![Screen shot of BAMS View Attendee Screen](screenshots/view-attendee-screen.png "BAMS View Attendee Screen")

## Edit Attendee Screen
![Screen shot of BAMS Edit Attendee Screen](screenshots/edit-attendee-screen.png "BAMS Edit Attendee Screen")

## Add Attendee Screen
![Screen shot of BAMS Add Attendee Screen](screenshots/add-attendee-screen.png "BAMS Add Attendee Screen")

