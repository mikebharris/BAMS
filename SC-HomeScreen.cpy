01 HomeScreen background-color BackgroundColour foreground-color ForegroundColour.
    03 blank screen.
    03 line 1 column 1 from ScreenHeader reverse-video.
    03 line 4 column EventNamePosition from EventName of EventDetails.
    03 line 7 column 34 value "Today is ".
    03 line 7 column plus 1 from DayOfTheWeek(CurrentDayOfWeek).
    03 line 10 column 5 value "Adults on site: ".
    03 pic zzz9 line 10 column plus 3 from PeopleOnSite.
    03 line 11 column 5 value "Adults to arrive: ".
    03 pic zzz9 line 11 column plus 1 from PeopleToArrive.
    03 line 12 column 5 value "                " underline.
    03 line 13 column 5 value "Total adults:    ".
    03 pic zzz9 line 13 column plus 2 from TotalEstimatedAttendees.
    03 line 16 column 5 value "To arrive today: ".
    03 pic zzz9 line 16 column plus 2 from PeopleToArriveToday.
    03 line 17 column 5 value "To be onsite today: ".
    03 pic zzz9 line 17 column minus 1 from PeopleToBeOnSiteToday.
    03 line 19 column 5 value "Staying till Mon: ".
    03 pic zzz9 line 19 column plus 1 from PeopleStayingTillMonday.
    03 line 10 column 50 value "Kids on-site: ".
    03 pic z9 line 10 column plus 5 from KidsOnSite.
    03 line 11 column 50 value "Kids to arrive: ".
    03 pic z9 line 11 column plus 3 from KidsToArrive.
    03 line 12 column 50 value "           " underline.
    03 line 13 column 50 value "Total kids:".
    03 pic z9 line 13 column plus 8 from TotalEstimatedKids.
    03 line 16 column 45 value "Kids to arrive today: ".
    03 pic z9 line 16 column plus 2 from KidsToArriveToday.
    03 line 24 column 1
        value "Commands: F2 List, F3 Add, F4 Edit, F9 Mono/Colour, F11 CLAMS, F12 Exit            " reverse-video.
    03 line 24 column 78 to Command.
