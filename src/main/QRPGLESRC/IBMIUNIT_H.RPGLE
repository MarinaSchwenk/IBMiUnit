**free

/if not defined ( IBMiUnit_H )
/define IBMiUnit_H

/////////////////////////
// Test suite definitions

//
// IBMiUnit_setupSuite
//
// Initialize IBMiUnit for the current test program (a.k.a. suite).
// This needs to be called before any other
// IBMiUnit_xxx sub-procedures are called
//
dcl-pr IBMiUnit_setupSuite;
   name                     varchar(   256 )  const  options( *noPass );
   testSetupProcedure       pointer( *proc )  const  options( *noPass );
   testTeardownProcedure    pointer( *proc )  const  options( *noPass );
   suiteSetupProcedure      pointer( *proc )  const  options( *noPass );
   suiteTeardownProcedure   pointer( *proc )  const  options( *noPass );
end-pr;

//
// IBMiUnit_teardownSuite
//
// Wrap up, cleanup and do whatever is necessary to
// complete the IBMiUnit tests in the program. Every
// IBMiUnit_setup call needs one, and only one, corresponding
// IBMiUnit_teardown call.
//
dcl-pr IBMiUnit_teardownSuite;
end-pr;

//
// IBMiUnit_addTestSuite
//
// Add all the tests in another test program (suite) to
// the current suite.
//
dcl-pr IBMiUnit_addTestSuite;
   name     varchar( 10 )  const;
   library  varchar( 10 )  const  options( *noPass );
end-pr;

//
// IBMiUnit_addTestCase
//
// Add a test case to the current suite.
// Test cases are sub-procedures in the same program that
// do not take any parameters or return any values.
//
dcl-pr IBMiUnit_addTestCase;
   procedure   pointer( *proc )  const;
   name        varchar(   256 )  const  options( *noPass );
end-pr;

//////////////////////////
// Assertions and failures

//
// fail
//
// Fail a test with the given (optional) message;
// "assertion failure" will be used if the parameter is not passed.
//
dcl-pr fail;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertOff
//
// Make sure the indicator is *OFF; fail with the optional
// message if it isn't.
//
dcl-pr assertOff;
   value     ind             const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertOn
//
// Make sure the indicator is *ON; fail with the optional
// message if it isn't.
//
dcl-pr assertOn;
   value     ind             const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertNull
//
// Make sure the pointer is *NULL; fail with the optional
// message if it isn't.
//
dcl-pr assertNull;
   value     pointer         const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertNotNull
//
// Make sure the pointer is not *NULL; fail with the optional
// message if it is.
//
dcl-pr assertNotNull;
   value     pointer         const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertCharEquals
//
// Make sure the 2 character values are identical; fail with the optional
// message if they aren't. Trailing blanks are significant in the comparison
// unless explicitly ignored.
//
dcl-pr assertCharEquals;
   expected              varchar( 250 )  const;
   actual                varchar( 250 )  const;
   message               varchar( 256 )  const  options( *noPass );
   ignoreTrailingBlanks  ind             const  options( *noPass );
end-pr;

//
// assertCharNotEquals
//
// Make sure the 2 character values are not identical; fail with the optional
// message if they are. Trailing blanks are significant in the comparison
// unless explicitly ignored.
//
dcl-pr assertCharNotEquals;
   unexpected            varchar( 250 )  const;
   actual                varchar( 250 )  const;
   message               varchar( 256 )  const  options( *noPass );
   ignoreTrailingBlanks  ind             const  options( *noPass );
end-pr;

//
// assertDateEquals
//
// Make sure the 2 date values are identical; fail with the optional
// message if they aren't.
//
dcl-pr assertDateEquals;
   expected  date            const;
   actual    date            const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertDateNotEquals
//
// Make sure the 2 date values are not identical; fail with the optional
// message if they are.
//
dcl-pr assertDateNotEquals;
   unexpected  date            const;
   actual      date            const;
   message     varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertFloatEquals
//
// Make sure the 2 float values are identical; fail with the optional
// message if they aren't.
//
dcl-pr assertFloatEquals;
   expected  float( 8 )      const;
   actual    float( 8 )      const;
   delta     float( 8 )      const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertFloatNotEquals
//
// Make sure the 2 float values are not identical; fail with the optional
// message if they are.
//
dcl-pr assertFloatNotEquals;
   unexpected  float( 8 )      const;
   actual      float( 8 )      const;
   delta       float( 8 )      const;
   message     varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertNumericEquals
//
// Make sure the 2 (non-float) numeric values are identical; fail with the optional
// message if they aren't.
//
dcl-pr assertNumericEquals;
   expected  packed( 60 : 25 )  const;
   actual    packed( 60 : 25 )  const;
   message   varchar( 256 )     const  options( *noPass );
end-pr;

//
// assertNumericNotEquals
//
// Make sure the 2 (non-float) numeric values are not identical; fail with the optional
// message if they are.
//
dcl-pr assertNumericNotEquals;
   unexpected  packed( 60 : 25 )  const;
   actual      packed( 60 : 25 )  const;
   message     varchar( 256 )     const  options( *noPass );
end-pr;

//
// assertTimeEquals
//
// Make sure the 2 time values are identical; fail with the optional
// message if they aren't.
//
dcl-pr assertTimeEquals;
   expected  time            const;
   actual    time            const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertTimeNotEquals
//
// Make sure the 2 time values are not identical; fail with the optional
// message if they are.
//
dcl-pr assertTimeNotEquals;
   unexpected  time            const;
   actual      time            const;
   message     varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertTimestampEquals
//
// Make sure the 2 timestamp values are identical; fail with the optional
// message if they aren't.
//
dcl-pr assertTimestampEquals;
   expected  timestamp       const;
   actual    timestamp       const;
   message   varchar( 256 )  const  options( *noPass );
end-pr;

//
// assertTimestampNotEquals
//
// Make sure the 2 timestamp values are not identical; fail with the optional
// message if they are.
//
dcl-pr assertTimestampNotEquals;
   unexpected  timestamp       const;
   actual      timestamp       const;
   message     varchar( 256 )  const  options( *noPass );
end-pr;

/endif
