# IBMiUnit Developer Documentation

## Framework/Suite Procedures

None of these procedure have a return value. All parameters are passed as `const`.

### IBMiUnit_setupSuite

Initialize IBMiUnit for the current test program (a.k.a. suite). This needs to be called before any other IBMiUnit_xxx sub-procedures are called.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
name | varchar(256) | No | a UI-friendly name for failure and status messages
testSetupProcedure | pointer(*proc) | No | a procedure to call before each test case is run
testTeardownProcedure | pointer(*proc) | No | a procedure to call after each test case is run
suiteSetupProcedure | pointer(*proc) | No | a procedure to call before the first test case in the suite is run
suiteTeardownProcedure | pointer(*proc) | No | a procedure to call after the last test case in the suite is run

### IBMiUnit_teardownSuite

Wrap up, cleanup and do whatever is necessary to complete the IBMiUnit tests in the program. Every `IBMiUnit_setup` call needs one, and only one, corresponding `IBMiUnit_teardown` call.

#### Parameters

(none)

### IBMiUnit_addTestSuite

Add all the tests in another test program (suite) to the current suite.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
name | varchar(10) | Yes | object name of the test program to add
library | varchar(10) | No | library where the program is found; `*LIBL` will be used if this parameter isn't specified

### IBMiUnit_addTestCase

Add a test case to the current suite. Test cases are sub-procedures in the same program that do not take any parameters or return any values.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
procedure | pointer(*proc) | Yes | pointer to the sub-procedure
name | varchar(256) | No | a UI-friendly name for failure and status messages

## Test Procedures 

None of these procedure have a return value. All parameters are passed as `const`.

### fail

Fail a test with the given (optional) message.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
message | varchar(256) | No | text to display on the UI; "assertion failure" will be used if this parameter is not passed

### assertOff

Make sure the indicator is \*OFF; fail with the optional message if it isn't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
value | ind | Yes | indicator to test
message | varchar(256) | No | text to display on the UI if the indicator is *ON

### assertOn

Make sure the indicator is \*ON; fail with the optional message if it isn't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
value | ind | Yes | indicator to test
message | varchar(256) | No | text to display on the UI if the indicator is *OFF

### assertNull

Make sure the pointer is \*NULL; fail with the optional message if it isn't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
value | pointer | Yes | pointer to test
message | varchar(256) | No | text to display on the UI if the pointer is not *NULL

### assertNotNull

Make sure the pointer is not \*NULL; fail with the optional message if it is.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
value | pointer | Yes | pointer to test
message | varchar(256) | No | text to display on the UI if the pointer is *NULL

### assertCharEquals

Make sure the 2 character values are identical; fail with the optional message if they aren't. Trailing blanks are significant in the comparison unless explicitly ignored.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
expected | varchar(250) | Yes | string that should be present
actual | varchar(250) | Yes | string to test
message | varchar(256) | No | text to display on the UI if the values are not identical
ignoreTrailingBlanks | ind | No | whether or not trailing spaces are significant in the comparison; default is *OFF

### assertCharNotEquals

Make sure the 2 character values are not identical; fail with the optional message if they are. Trailing blanks are significant in the comparison unless explicitly ignored.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
unexpected | varchar(250) | Yes | string that should not be present
actual | varchar(250) | Yes | string to test
message | varchar(256) | No | text to display on the UI if the values are identical
ignoreTrailingBlanks | ind | No | whether or not trailing spaces are significant in the comparison; default is *OFF

### assertDateEquals

Make sure the 2 date values are identical; fail with the optional message if they aren't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
expected | date | Yes | date that should be found
actual | date | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are not identical

### assertDateNotEquals

Make sure the 2 date values are not identical; fail with the optional message if they are.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
unexpected | date | Yes | date the should not be found
actual | date | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are identical

### assertFloatEquals

Make sure the 2 float values are identical; fail with the optional message if they aren't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
expected | float(8) | Yes | value that should be found
actual | float(8) | Yes | value that was found
delta | float(8) | Yes | leeway allowed between `expected` and `actual` since float values are not exact
message | varchar(256) | No | text to display on the UI if the values are not identical

### assertFloatNotEquals

Make sure the 2 float values are not identical; fail with the optional message if they are.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
unexpected | float(8) | Yes | value that should not be found
actual | float(8) | Yes | value that was found
delta | float(8) | Yes | leeway allowed between `expected` and `actual` since float values are not exact
message | varchar(256) | No | text to display on the UI if the values are identical

### assertNumericEquals

Make sure the 2 (non-float) numeric values are identical; fail with the optional message if they aren't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
expected | packed(60:25) | Yes | value that should be found
actual | packed(60:25) | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are not identical

### assertNumericNotEquals

Make sure the 2 (non-float) numeric values are not identical; fail with the optional message if they are.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
unexpected | packed(60:25) | Yes | value that should not be found
actual | packed(60:25) | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are identical

### assertTimeEquals

Make sure the 2 time values are identical; fail with the optional message if they aren't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
expected | time | Yes | value that should be found
actual | time | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are not identical

### assertTimeNotEquals

Make sure the 2 time values are not identical; fail with the optional message if they are.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
unexpected | time | Yes | value that should not be found
actual | time | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are identical

### assertTimestampEquals

Make sure the 2 timestamp values are identical; fail with the optional message if they aren't.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
expected | timestamp | Yes | value that should be found
actual | timestamp | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are not identical

### assertTimestampNotEquals

Make sure the 2 timestamp values are not identical; fail with the optional message if they are.

####  Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
unexpected | timestamp | Yes | value that should not be found
actual | timestamp | Yes | value that was found
message | varchar(256) | No | text to display on the UI if the values are identical

## Commands

### RUNUNIT

Run a suite of tests. The interactive user-interface, UI(\*INT), will use the 5250 status line for feedback as the tests are running and display a completion or escape message when everything is complete. The RPG DSPLY user-interface, UI(\*DSPLY) simply uses the DSPLY op-code for all messages and is very verbose.

#### Parameters

Name | Type | Required? | Description 
---- | ---- | --------- | ------------
suite | qualified object name | Yes | the name of the test suite to run
ui | \*INT, \*DSPLY | No | how the feedback should be shown; defaults to \*INT
