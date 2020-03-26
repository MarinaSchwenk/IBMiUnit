**free

//
// IBMiUnit testing framework
//
// IBMiUnit Copyright (c) 2019 Marina Schwenk, Steve Johnson-Evers
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>
//
//-------------------------------------------------------------------------------------------------

ctl-opt  bndDir( 'OSSILE/OSSILE' );
ctl-opt  datFmt( *iso )  timFmt( *iso );
ctl-opt  noMain;

/copy 'IBMIUNIT_H.rpgle'

/define IBMiUi_noMain
/copy 'IBMIUI_H.rpgle'

/copy 'ARRAYLST_H.rpgle'
/copy 'MESSAGE_H.rpgle'

dcl-ds ui_t qualified template;
   setup            pointer( *proc );
   done             pointer( *proc );
   suiteSetup       pointer( *proc );
   suiteTeardown    pointer( *proc );
   suiteDone        pointer( *proc );
   testSetup        pointer( *proc );
   testCall         pointer( *proc );
   testTeardown     pointer( *proc );
   testDone         pointer( *proc );
   isStopRequested  pointer( *proc );
end-ds;

dcl-ds currentTestCase  likeds( testCase_t );  // global variable so failures know where it happened
dcl-s  rootTest         ind  inz( *on );
dcl-ds testSuite        likeds( testSuite_t );

dcl-s uiPgm    char( 10 )  inz( 'IBMIUIINT' ); // assume interactive 'green screen' in case
                                                // RUNUNIT is not used

/////////////////////////
// Test suite definitions

//
// IBMiUnit_setupSuite
//
// Initialize IBMiUnit for the current test program.
// This needs to be called before any other
// IBMiUnit_xxx sub-procedures are called
//
dcl-proc IBMiUnit_setupSuite export;

   dcl-pi *n;
      name                     varchar(   256 )  const  options( *noPass );
      testSetupProcedure       pointer( *proc )  const  options( *noPass );
      testTeardownProcedure    pointer( *proc )  const  options( *noPass );
      suiteSetupProcedure      pointer( *proc )  const  options( *noPass );
      suiteTeardownProcedure   pointer( *proc )  const  options( *noPass );
   end-pi;

   // very little is done up-front; just remember everything in a dynamic array

   if ( %parms >= 1 );
      testSuite.name = name;
   else;
      testSuite.name = '';
   endIf;

   if ( %parms >= 2 );
      testSuite.testSetupProcedure = testSetupProcedure;
   else;
      testSuite.testSetupProcedure = *null;
   endIf;

   if ( %parms >= 3 );
      testSuite.testTeardownProcedure = testTeardownProcedure;
   else;
      testSuite.testTeardownProcedure = *null;
   endIf;

   if ( %parms >= 4 );
      testSuite.suiteSetupProcedure = suiteSetupProcedure;
   else;
      testSuite.suiteSetupProcedure = *null;
   endIf;

   if ( %parms >= 5 );
      testSuite.suiteTeardownProcedure = suiteTeardownProcedure;
   else;
      testSuite.suiteTeardownProcedure = *null;
   endIf;

   testSuite.tests = arraylist_create();

   testSuite.programName = '';
   testSuite.programLibrary = '';
   testSuite.numberOfCases = 0;
   testSuite.numberOfSuites = 0;
   testSuite.numberOfDescendantCases = 0;
   testSuite.numberOfDescendantSuites = 0;
   testSuite.numberOfSuccessfulTests = 0;
   testSuite.numberOfFailureTests = 0;
   testSuite.numberOfErrorTests = 0;

end-proc;

//
// IBMiUnit_teardownSuite
//
// Wrap up, cleanup and do whatever is necessary to
// complete the IBMiUnit tests in the program. Every
// IBMiUnit_setup call needs one, and only one, corresponding
// IBMiUnit_teardown call.
//
dcl-proc IBMiUnit_teardownSuite export;

   dcl-ds ui likeds( ui_t );

   if ( rootTest );

      ui = loadUi();

      callSuiteProcedure( ui.setup : testSuite );

      runTests( ui : testSuite );

      cleanup( testSuite );

      callSuiteProcedure( ui.done : testSuite );

   endIf;

end-proc;

//
// IBMiUnit_addTestSuite
//
// Add all the tests in another test program (suite) to
// the current suite.
//
dcl-proc IBMiUnit_addTestSuite export;

   dcl-pi *n;
      name     varchar( 10 )  const;
      library  varchar( 10 )  const  options( *noPass );
   end-pi;

   dcl-ds testCase             likeds( testCase_t );
   dcl-ds currentTestSuite     likeds( testSuite_t );
   dcl-s  currentRootTest      ind;
   dcl-ds errorTestSuite       likeds( testSuite_t );
   dcl-pr externalProgram      extPgm( externalProgramName );
   end-pr;
   dcl-s  externalProgramName  char( 21 );
   dcl-ds message              likeds( message_t );

   // remember the current suite so the program can initialize a new suite and create that one

   currentTestSuite = testSuite;
   currentRootTest = rootTest;

   rootTest = *off;

   // call the external program

   if (( %parms > 1 ) and ( %addr( library ) <> *null ));
      externalProgramName = %trim( library ) + '/';
   else;
      externalProgramName = '*LIBL/';
   endIf;

   externalProgramName = %trim( externalProgramName ) + %trim( name );
   externalProgramName = toUpperCase( externalProgramName );

   monitor;

      callP externalProgram();

      // connect the newly created suite into the existing one

      testSuite.programName = name;
      if (( %parms > 1 ) and ( %addr( library ) <> *null ));
         testSuite.programLibrary = library;
      else;
         testSuite.programLibrary = '*LIBL';
      endIf;

      testCase.procedureOrSuite = TEST_SUITE;
      testCase.suite = testSuite;

      currentTestSuite.numberOfDescendantCases += testSuite.numberOfCases +
                                               testSuite.numberOfDescendantCases;
      currentTestSuite.numberOfDescendantSuites += testSuite.numberOfSuites +
                                                testSuite.numberOfDescendantSuites;

   on-error;

      // unable to add the suite, record a RESULT_ERROR

      message = message_receiveMessage( '*EXCP' );

      testCase.messageId = message.id;
      testCase.messageKey = message.key;

      errorTestSuite.programName = name;
      if (( %parms > 1 ) and ( %addr( library ) <> *null ));
         errorTestSuite.programLibrary = library;
      else;
         errorTestSuite.programLibrary = '*LIBL';
      endIf;

      errorTestSuite.result = RESULT_ERROR;
      errorTestSuite.tests = arraylist_create();

      testCase.procedureOrSuite = TEST_SUITE;
      testCase.suite = errorTestSuite;

      currentTestSuite.numberOfDescendantSuites += 1;

   endMon;

   testSuite = currentTestSuite;
   rootTest = currentRootTest;

   arraylist_add( testSuite.tests : %addr( testCase )
                                  : %size( testCase ) );

   testSuite.numberOfSuites += 1;

end-proc;

//
// IBMiUnit_addTestCase
//
// Add another test case to the current suite.
//
dcl-proc IBMiUnit_addTestCase export;

   dcl-pi *n;
      procedure   pointer( *proc )  const;
      name        varchar(   256 )  const  options( *noPass );
   end-pi;

   dcl-ds testCase  likeds( testCase_t );

   // very little is done up-front; just remember everything in a dynamic array

   testCase.procedureOrSuite = TEST_PROCEDURE;
   testCase.procedure = procedure;

   if (( %parms >= 2 ) and ( %addr( name ) <> *null ));
      testCase.name = name;
   else;
      testCase.name = '';
   endIf;

   arraylist_add( testSuite.tests : %addr( testCase )
                                  : %size( testCase ) );

   testSuite.numberOfCases += 1;

end-proc;

//////////////////////////
// Assertions and failures

//
// fail
//
// Fail a test with the given (optional) message.
//
dcl-proc fail export;

   dcl-pi *n;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s messageText varchar( 256 );

   messageText = 'assertion failure';

   if ( currentTestCase.name <> '' );
      messageText += ' in ' + currentTestCase.name;
   endIf;

   if (( %parms >= 1 ) and ( %addr( message ) <> *null ));
      messageText += ': ' + message;
   endIf;

   message_sendEscapeMessageToCaller( messageText );

end-proc;

//
// assertOff
//
// Make sure the indicator is *OFF; fail with the optional
// message if it isn't.
//
dcl-proc assertOff export;

   dcl-pi *n;
      value     ind             const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   if ( value = *off );
      return;
   endIf;

   if ( %parms() >= 2 );
      fail( message );
   else;
      fail();
   endIf;

end-proc;

//
// assertOn
//
// Make sure the indicator is *ON; fail with the optional
// message if it isn't.
//
dcl-proc assertOn export;

   dcl-pi *n;
      value     ind             const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   if ( value = *on );
      return;
   endIf;

   if ( %parms() >= 2 );
      fail( message );
   else;
      fail();
   endIf;

end-proc;

//
// assertNull
//
// Make sure the indicator is *NULL; fail with the optional
// message if it isn't.
//
dcl-proc assertNull export;

   dcl-pi *n;
      value     pointer         const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   if ( value = *null );
      return;
   endIf;

   if ( %parms() >= 2 );
      fail( message );
   else;
      fail();
   endIf;

end-proc;

//
// assertNotNull
//
// Make sure the indicator is not *NULL; fail with the optional
// message if it is.
//
dcl-proc assertNotNull export;

   dcl-pi *n;
      value     pointer         const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   if ( value <> *null );
      return;
   endIf;

   if ( %parms() >= 2 );
      fail( message );
   else;
      fail();
   endIf;

end-proc;

//
// assertCharEquals
//
// Make sure the 2 character values are identical; fail with the optional
// message if they aren't.
//
dcl-proc assertCharEquals export;

   dcl-pi *n;
      expected              varchar( 250 )  const;
      actual                varchar( 250 )  const;
      message               varchar( 256 )  const  options( *noPass );
      ignoreTrailingBlanks  ind             const  options( *noPass );
   end-pi;

   dcl-s  identicalPrefixLength  int(       5 );
   dcl-s  identicalSuffixLength  int(       5 );
   dcl-s  uiMessage              varchar( 512 );

   if (( %parms() > 3 ) and ( %addr( ignoreTrailingBlanks ) <> *null ) and ignoreTrailingBlanks );

      // don't care about trailing blanks

      if ( expected = actual );
         return;
      endIf;

   else;

      // trailing blanks are significant; compiler doesn't care so we need an explicit check

      if (( expected = actual ) and ( %len( expected ) = %len( actual )));
         return;
      endIf;

   endIf;

   // find the parts that differ

   identicalPrefixLength = 0;
   dow (( identicalPrefixLength < %len( expected )) and
        ( identicalPrefixLength < %len( actual )) and
        ( %subst( expected : identicalPrefixLength + 1 : 1 ) =
          %subst( actual : identicalPrefixLength + 1 : 1 )));
      identicalPrefixLength += 1;
   endDo;

   identicalSuffixLength = 0;
   dow (( identicalSuffixLength + identicalPrefixLength < %len( expected )) and
        ( identicalSuffixLength + identicalPrefixLength < %len( actual )) and
        ( %subst( expected : %len( expected ) - identicalSuffixLength : 1 ) =
          %subst( actual : %len( actual ) - identicalSuffixLength : 1 )));
      identicalSuffixLength += 1;
   endDo;

   // return a message like "assertion failure: expected:<[expected]> but was:<[actual]>"

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;

   uiMessage += 'expected:<';

   if ( identicalPrefixLength > 0 );
      uiMessage += %subst( expected : 1 : identicalPrefixLength );
   endIf;

   uiMessage += '[';

   if ( identicalPrefixLength + identicalSuffixLength < %len( expected ) );
      uiMessage += %subst( expected
                         : identicalPrefixLength + 1
                         : %len( expected ) - identicalPrefixLength - identicalSuffixLength );
   endIf;

   uiMessage += ']';

   if ( identicalSuffixLength > 0 );
      uiMessage += %subst( expected : %len( expected ) - identicalSuffixLength + 1 );
   endIf;

   uiMessage += '> but was:<';

   if ( identicalPrefixLength > 0 );
      uiMessage += %subst( actual : 1 : identicalPrefixLength );
   endIf;

   uiMessage += '[';

   if ( identicalPrefixLength + identicalSuffixLength < %len( actual ) );
      uiMessage += %subst( actual
                         : identicalPrefixLength + 1
                         : %len( actual ) - identicalPrefixLength - identicalSuffixLength );
   endIf;

   uiMessage += ']';

   if ( identicalSuffixLength > 0 );
      uiMessage += %subst( actual : %len( actual ) - identicalSuffixLength + 1 );
   endIf;

   uiMessage += '>';

   fail( uiMessage );

end-proc;

//
// assertCharNotEquals
//
// Make sure the 2 character values are not identical; fail with the optional
// message if they are.
//
dcl-proc assertCharNotEquals export;

   dcl-pi *n;
      unexpected            varchar( 250 )  const;
      actual                varchar( 250 )  const;
      message               varchar( 256 )  const  options( *noPass );
      ignoreTrailingBlanks  ind             const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if (( %parms() > 3 ) and ( %addr( ignoreTrailingBlanks ) <> *null ) and ignoreTrailingBlanks );

      // don't care about trailing blanks

      if ( unexpected <> actual );
         return;
      endIf;

   else;

      // trailing blanks are significant; compiler doesn't care so we need an explicit check

      if (( unexpected <> actual ) or ( %len( unexpected ) <> %len( actual )));
         return;
      endIf;

   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'unexpected:<' + unexpected + '>';

   fail( uiMessage );

end-proc;

//
// assertDateEquals
//
// Make sure the 2 date values are identical; fail with the optional
// message if they aren't.
//
dcl-proc assertDateEquals export;

   dcl-pi *n;
      expected  date            const;
      actual    date            const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if ( expected = actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;

   uiMessage += 'expected:<' + %char( expected ) +
                '> but was:<' + %char( actual ) + '>';

   fail( uiMessage );

end-proc;

//
// assertDateNotEquals
//
// Make sure the 2 date values are not identical; fail with the optional
// message if they are.
//
dcl-proc assertDateNotEquals export;

   dcl-pi *n;
      unexpected  date            const;
      actual      date            const;
      message     varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if ( unexpected <> actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'unexpected:<' + %char( unexpected ) + '>';

   fail( uiMessage );

end-proc;

//
// assertFloatEquals
//
// Make sure the 2 float values are identical; fail with the optional
// message if they aren't.
//
dcl-proc assertFloatEquals export;

   dcl-pi *n;
      expected  float( 8 )      const;
      actual    float( 8 )      const;
      delta     float( 8 )      const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 356 );

   if ( %abs( expected - actual ) <= %abs( delta ));
      return;
   endIf;

   if (( %parms() > 3 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'expected:<' + %char( expected ) + '> but was:<' + %char( actual ) + '>';

   fail( uiMessage );

end-proc;

//
// assertFloatNotEquals
//
// Make sure the 2 float values are not identical; fail with the optional
// message if they are.
//
dcl-proc assertFloatNotEquals export;

   dcl-pi *n;
      unexpected  float( 8 )      const;
      actual      float( 8 )      const;
      delta       float( 8 )      const;
      message     varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 356 );

   if ( %abs( unexpected - actual ) > %abs( delta ));
      return;
   endIf;

   if (( %parms() > 3 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'unexpected:<' + %char( unexpected ) + '>';

   fail( uiMessage );

end-proc;

//
// assertNumericEquals
//
// Make sure the 2 (non-float) numeric values are identical; fail with the optional
// message if they aren't.
//
dcl-proc assertNumericEquals export;

   dcl-pi *n;
      expected  packed( 60 : 25 )  const;
      actual    packed( 60 : 25 )  const;
      message   varchar( 256 )     const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 356 );

   if ( expected = actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'expected:<' + formatNumeric( expected )
              + '> but was:<' + formatNumeric( actual  ) + '>';

   fail( uiMessage );

end-proc;

//
// assertNumericNotEquals
//
// Make sure the 2 (non-float) numeric values are not identical; fail with the optional
// message if they are.
//
dcl-proc assertNumericNotEquals export;

   dcl-pi *n;
      unexpected  packed( 60 : 25 )  const;
      actual      packed( 60 : 25 )  const;
      message     varchar( 256 )     const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 356 );

   if ( unexpected <> actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'unexpected:<' + formatNumeric( unexpected ) + '>';

   fail( uiMessage );

end-proc;

//
// assertTimeEquals
//
// Make sure the 2 time values are identical; fail with the optional
// message if they aren't.
//
dcl-proc assertTimeEquals export;

   dcl-pi *n;
      expected  time            const;
      actual    time            const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if ( expected = actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;

   uiMessage += 'expected:<' + %char( expected ) +
                '> but was:<' + %char( actual ) + '>';

   fail( uiMessage );

end-proc;

//
// assertTimeNotEquals
//
// Make sure the 2 time values are not identical; fail with the optional
// message if they are.
//
dcl-proc assertTimeNotEquals export;

   dcl-pi *n;
      unexpected  time            const;
      actual      time            const;
      message     varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if ( unexpected <> actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'unexpected:<' + %char( unexpected ) + '>';

   fail( uiMessage );

end-proc;

//
// assertTimestampEquals
//
// Make sure the 2 timestamp values are identical; fail with the optional
// message if they aren't.
//
dcl-proc assertTimestampEquals export;

   dcl-pi *n;
      expected  timestamp       const;
      actual    timestamp       const;
      message   varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if ( expected = actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;

   uiMessage += 'expected:<' + %char( expected ) +
                '> but was:<' + %char( actual ) + '>';

   fail( uiMessage );

end-proc;

//
// assertTimestampNotEquals
//
// Make sure the 2 time values are not identical; fail with the optional
// message if they are.
//
dcl-proc assertTimestampNotEquals export;

   dcl-pi *n;
      unexpected  timestamp       const;
      actual      timestamp       const;
      message     varchar( 256 )  const  options( *noPass );
   end-pi;

   dcl-s uiMessage varchar( 512 );

   if ( unexpected <> actual );
      return;
   endIf;

   if (( %parms() > 2 ) and ( %addr( message ) <> *null ));
      uiMessage = message + ' ';
   else;
      uiMessage = '';
   endIf;
   uiMessage += 'unexpected:<' + %char( unexpected ) + '>';

   fail( uiMessage );

end-proc;

//
// IBMiUnit_registerUi
//
// Register the user interface plug-in that will be used for this test run.
//
// Note: This sub-procedure is exported, but it should not be used by anything
// other than other IBMiUnit programs. That is why it is not found in any _H files.
//
dcl-proc IBMiUnit_registerUi export;

   dcl-pi *n;
      ui     char( 10 )  const;
   end-pi;

   uiPgm = ui;

end-proc;

//////////////////////////
// Internal sub-procedures

//
// runTests
//
// Main testing block that runs tests and reports results.
//
// @return the number of procedures that have been tested.
//
dcl-proc runTests;

   dcl-pi *n;
      ui             likeds( ui_t )         const;
      testSuite      likeds( testSuite_t );
   end-pi;

   dcl-s  i               int(  10 );
   dcl-s  status          char( 1 );
   dcl-s  teardownStatus  like( status );
   dcl-ds testCase        likeds( testCase_t )  based( testCasePtr );
   dcl-s  testCasePtr     pointer;

   testSuite.result = RESULT_UNKNOWN;

   currentTestCase.name = 'suiteSetupProcedure';
   callUiSuite( ui.suiteSetup : testSuite );
   status = callProcedure( testSuite.suiteSetupProcedure );

   if (( status = RESULT_SUCCESSFUL ) and ( arraylist_getSize( testSuite.tests ) > 0 ));
      for i = 0 to arraylist_getSize( testSuite.tests ) - 1;

         testCasePtr = arraylist_get( testSuite.tests : i );

         if ( testCase.procedureOrSuite = TEST_PROCEDURE );

            testCase.result = RESULT_UNKNOWN;
            testCase.messageId = '';
            testCase.messageKey = '';

            currentTestCase = testCase;

            callUiCase( ui.testSetup : testCase );
            status = callProcedure( testSuite.testSetupProcedure );

            if ( status = RESULT_SUCCESSFUL );

               callUiCase( ui.testCall : testCase );
               status = callTestProcedure( testCase.procedure : testCase );
               testCase.result = status;

               callUiCase( ui.testTeardown : testCase );
               teardownStatus = callTestProcedure( testSuite.testTeardownProcedure : testCase );

               // assign the proper 'final' status using the results
               // from the test case itself and the teardown procedure

               if (( testCase.result = RESULT_SUCCESSFUL ) or
                   (( testCase.result = RESULT_FAILURE ) and
                    ( teardownStatus = RESULT_ERROR )));
                  testCase.result = teardownStatus;
               endIf;

            endIf;

            callUiCase( ui.testDone : testCase );

            select;
               when ( testCase.result = RESULT_ERROR );
                  testSuite.numberOfErrorTests += 1;
                  testSuite.result = RESULT_ERROR;

               when ( testCase.result = RESULT_FAILURE );
                  testSuite.numberOfFailureTests += 1;
                  if ( testSuite.result <> RESULT_ERROR );
                     testSuite.result = RESULT_FAILURE;
                  endIf;

               other;
                  testSuite.numberOfSuccessfulTests += 1;

            endSl;

         else;

            // run a 'child' suite

            if ( testCase.suite.result = RESULT_ERROR );

               testSuite.numberOfErrorTests += 1;

            else;

               runTests( ui : testCase.suite );

               // bubble-up the lower test suite status to the current suite

               testSuite.numberOfSuccessfulTests += testCase.suite.numberOfSuccessfulTests;
               testSuite.numberOfFailureTests    += testCase.suite.numberOfFailureTests;
               testSuite.numberOfErrorTests      += testCase.suite.numberOfErrorTests;

            endIf;

            if ( testCase.suite.result = RESULT_ERROR ) or
               (( testCase.suite.result = RESULT_FAILURE ) and
                ( testSuite.result = RESULT_UNKNOWN ));
               testSuite.result = testCase.suite.result;
            endIf;

         endIf;
      endFor;

      if ( testSuite.result = RESULT_UNKNOWN );
         testSuite.result = RESULT_SUCCESSFUL;
      endIf;

      currentTestCase.name = 'suiteTeardownProcedure';
      callUiSuite( ui.suiteTeardown : testSuite );
      status = callSuiteProcedure( testSuite.suiteTeardownProcedure : testSuite );

      if ( status = RESULT_ERROR ) or
         (( status = RESULT_FAILURE ) and
          ( testSuite.result = RESULT_SUCCESSFUL ));
         testSuite.result = status;
      endIf;

   endIf;

   callUiSuite( ui.suiteDone : testSuite );

end-proc;

//
// callProcedure
//
// Call a callback procedure in the testing code (outside this
// library).
//
// @return one of the RESULT_xxx value
// @see callSuiteProcedure
// @see callTestProcedure
//
dcl-proc callProcedure;

   dcl-pi *n char( 1 );
      procedurePtr  pointer( *proc )  const;
   end-pi;

   dcl-pr callback extproc( procedurePtr );
   end-pr;
   dcl-ds message  likeds( message_t );
   dcl-s  result   char( 1 );

   result = RESULT_SUCCESSFUL;

   if ( procedurePtr <> *null );

      monitor;

         callback();

      on-error;

         message = message_receiveMessage( '*EXCP' );

         if ( message.id = 'CPF9897' ); // TODO replace with IBMiUnit message ID
            result = RESULT_FAILURE;
         else;
            result = RESULT_ERROR;
         endIf;

      endMon;
   endIf;

   return result;

end-proc;

//
// callSuiteProcedure
//
// Call a callback procedure in the testing code (outside this
// library). Pass the current test suite to the procedure.
//
// @return one of the RESULT_xxx value
// @see callProcedure
// @see callTestProcedure
//
dcl-proc callSuiteProcedure;

   dcl-pi *n char( 1 );
      procedurePtr  pointer( *proc )  const;
      testSuite     likeds( testSuite_t )  const;
   end-pi;

   dcl-pr callback extproc( procedurePtr );
      testSuite    likeds( testSuite_t )    const;
   end-pr;
   dcl-ds message  likeds( message_t );
   dcl-s  result   char( 1 );

   result = RESULT_SUCCESSFUL;

   if ( procedurePtr <> *null );

      monitor;

         callback( testSuite );

      on-error;

         message = message_receiveMessage( '*EXCP' );

         if ( message.id = 'CPF9897' ); // TODO replace with IBMiUnit message ID
            result = RESULT_FAILURE;
         else;
            result = RESULT_ERROR;
         endIf;

      endMon;
   endIf;

   return result;

end-proc;

//
// callTestProcedure
//
// Call a callback procedure in the testing code (outside this
// library). Pass the current test case to the procedure.
//
// @return one of the RESULT_xxx value
// @see callProcedure
// @see callSuiteProcedure
//
dcl-proc callTestProcedure;

   dcl-pi *n char( 1 );
      procedurePtr  pointer( *proc )      const;
      testCase      likeds( testCase_t );
   end-pi;

   dcl-pr callback extproc( procedurePtr );
      testCase     likeds( testCase_t )     const;
   end-pr;
   dcl-ds message  likeds( message_t );
   dcl-s  result   char( 1 );

   result = RESULT_SUCCESSFUL;

   if ( procedurePtr <> *null );

      monitor;

         callback( testCase );

      on-error;

         message = message_receiveMessage( '*EXCP' );

         testCase.messageId = message.id;
         testCase.messageKey = message.key;

         if ( message.id = 'CPF9897' ); // TODO replace with IBMiUnit message ID
            result = RESULT_FAILURE;
         else;
            result = RESULT_ERROR;
         endIf;

      endMon;
   endIf;

   return result;

end-proc;

//
// callUiSuite
//
// Call a UI procedure that takes a testSuite_t parameter.
//
dcl-proc callUiSuite;

   dcl-pi *n;
      procedurePtr  pointer( *proc )       const;
      testSuite     likeds( testSuite_t )  const;
   end-pi;

   dcl-pr callUi  extproc( procedurePtr );
      testSuite   likeds( testSuite_t )  const;
   end-pr;

   if ( procedurePtr <> *null );
      callUi( testSuite );
   endIf;

end-proc;

//
// callUiCase
//
// Call a UI procedure that takes a testCase_t parameter.
//
dcl-proc callUiCase;

   dcl-pi *n;
      procedurePtr  pointer( *proc )  const;
      testCase      likeds( testCase_t )  const;
   end-pi;

   dcl-pr callUi  extproc( procedurePtr );
      testCase    likeds( testCase_t )  const;
   end-pr;

   if ( procedurePtr <> *null );
      callUi( testCase );
   endIf;

end-proc;

//
// cleanup
//
// Remove the variables stored in dynamic memory
//
dcl-proc cleanup;

   dcl-pi *n;
      testSuite  likeds( testSuite_t );
   end-pi;

   dcl-s  i             int( 10 );
   dcl-ds testCase      likeds( testCase_t )  based( testCasePtr );
   dcl-s  testCasePtr   pointer;

   // remove any child suites

   if ( arraylist_getSize( testSuite.tests ) > 0 );
      for i = 0 to arraylist_getSize( testSuite.tests ) - 1;

         testCasePtr = arraylist_get( testSuite.tests : i );

         if ( testCase.procedureOrSuite = TEST_SUITE );
            cleanup( testCase.suite );
         endIf;

      endFor;
   endIf;

   // now we can get rid of the tests in the current suite

   arraylist_dispose( testSuite.tests );

end-proc;

//
// formatNumeric
//
// Format a numeric value for proper UI display
//
dcl-proc formatNumeric;

   dcl-pi *n varchar( 80 );
      numeric  packed( 60 : 25 )  const;
   end-pi;

   dcl-s  result  varchar( 80 );

   result = %trim( %editC( numeric : 'J' ) );

   // move any sign to the beginning

   if ( %subst( result : %len( result ) : 1 ) = '-' );
      result = '-' + %subst( result : 1 : %len( result ) - 1 );
   endIf;

   // remove insignificant decimal output

   dow ( %subst( result : %len( result ) : 1 ) = '0' );
      result = %subst( result : 1 : %len( result ) - 1 );
   endDo;

   // remove any trailing decimal point

   if ( %subst( result : %len( result ) : 1 ) = '.' );
      result = %subst( result : 1 : %len( result ) - 1 );
   endIf;

   // need to indicate a number

   if ( %len( result ) = 0 );
      result = '0';
   endIf;

   return result;

end-proc;

//
// loadUi
//
// Load the appropriate UI plug-in.
//
dcl-proc loadUi;

   dcl-pi *n likeds( ui_t );
   end-pi;

   dcl-ds result  likeds( ui_t );
   dcl-pr uiProgram   extPgm( uiPgm );
      dcl-parm setup            pointer( *proc );
      dcl-parm done             pointer( *proc );
      dcl-parm suiteSetup       pointer( *proc );
      dcl-parm suiteTeardown    pointer( *proc );
      dcl-parm suiteDone        pointer( *proc );
      dcl-parm testSetup        pointer( *proc );
      dcl-parm testCall         pointer( *proc );
      dcl-parm testTeardown     pointer( *proc );
      dcl-parm testDone         pointer( *proc );
      dcl-parm isStopRequested  pointer( *proc );
   end-pr;

   result.setup = *null;
   result.done = *null;
   result.suiteSetup = *null;
   result.suiteTeardown = *null;
   result.suiteDone = *null;
   result.testSetup = *null;
   result.testCall = *null;
   result.testTeardown = *null;
   result.testDone = *null;
   result.isStopRequested = *null;

   uiProgram( result.setup : result.done
            : result.suiteSetup : result.suiteTeardown : result.suiteDone
            : result.testSetup : result.testCall : result.testTeardown : result.testDone
            : result.isStopRequested );

   return result;

end-proc;

//
// toUpperCase
//
// Return an upper-case version of the parameter.
//
dcl-proc toUpperCase;

   dcl-pi *n varchar( 1024 );
      source  varchar( 1024 )  const;
   end-pi;

   dcl-c uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   dcl-c lowercase 'abcdefghijklmnopqrstuvwxyz';

   return %xlate( lowercase : uppercase : source );

end-proc;
