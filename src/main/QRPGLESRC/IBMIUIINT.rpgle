**free

//
// IBMiUnit UI plug-in that uses the status line for
// feedback during the testing.
//

ctl-opt  dftActGrp( *no );

// plug-in definition is done by the main-line code

dcl-pr main extPgm( 'IBMIUIINT' );
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

dcl-c MAX_PROGRESS_BAR_LENGTH 40;

dcl-c PROGRESS_BAR_UNKNOWN    '.';
dcl-c PROGRESS_BAR_SUCCESSFUL ':';
dcl-c PROGRESS_BAR_FAILED     'F';
dcl-c PROGRESS_BAR_ERROR      'E';

dcl-s progressBar      varchar( MAX_PROGRESS_BAR_LENGTH );
dcl-s currentTestCase  int( 10 );
dcl-s totalTestCases   int( 10 );
dcl-s suiteName        varchar( 10 );

/copy IBMiUi_h
/copy 'MESSAGE_H.rpgle'

setup         = %pAddr( IBMiUnitui_setup );
done          = %pAddr( IBMiUnitui_done );
suiteSetup    = %pAddr( IBMiUnitui_suiteSetup );
testSetup     = %pAddr( IBMiUnitui_testSetup );
testDone      = %pAddr( IBMiUnitui_testDone );

// This sub-procedure doesn't do anything but sleep a bit.
// Only use it when you want to slow down the UI updates.

//testCall = %pAddr( IBMiUnitui_testCall );

return;

//
// IBMiUnitui_setup
//
// Initialize UI for the test environment.
// This will be called before any test or test/suite setup procedures.
// This procedure takes a testSuite_t parameter that represents the
// top-level, or all, tests that will be run.
//
dcl-proc IBMiUnitui_setup export;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   dcl-s  i                  int( 5 );
   dcl-s  progressBarLength  int( 5 );

   // initialize some counters

   currentTestCase = 0;
   totalTestCases = testSuite.numberOfCases + testSuite.numberOfDescendantCases;

   // build the progress bar

   if ( totalTestCases > MAX_PROGRESS_BAR_LENGTH );
      progressBarLength = MAX_PROGRESS_BAR_LENGTH;
   else;
      progressBarLength = totalTestCases;
   endIf;

   progressBar = '';
   for i = 1 to progressBarLength;
      progressBar += PROGRESS_BAR_UNKNOWN;
   endFor;

end-proc;

//
// IBMiUnitui_done
//
// Wrap up the test by sending a completion message that summarizes
// the number of successful, failed and error test cases.
//
dcl-proc IBMiUnitui_done export;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   dcl-s  message  varchar( 80 );

   if ( testSuite.result = RESULT_SUCCESSFUL );

      message = 'All ' + %trim( %editc( testSuite.numberOfSuccessfulTests : '1' ))
                       + ' tests ran successfully';

      message_sendCompletionMessage( message );

   else;

      message = 'Done: ' + %char( testSuite.numberOfErrorTests ) + ' errors, '
                         + %char( testSuite.numberOfFailureTests ) + ' failures, '
                         + %char( testSuite.numberOfSuccessfulTests ) + ' successful test(s)';

      message_sendEscapeMessageAboveControlBody( message );

   endIf;

end-proc;

//
// IBMiUnitui_suiteSetup
//
// A new suite has just been started. This is called before
// calling any suite setup procedure.
//
dcl-proc IBMiUnitui_suiteSetup export;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   suiteName = testSuite.programName;

end-proc;

//
// IBMiUnitui_testSetup
//
// A new case has just been started. This is called before
// calling any case setup procedure.
//
dcl-proc IBMiUnitui_testSetup export;

   dcl-pi *n;
      testCase  likeds( testCase_t )  const;
   end-pi;

   dcl-s  statusText  varchar( 80 );

   currentTestCase += 1;

   statusText = getNumericProgress() + ' ' + progressBar + ' ';

   if ( suiteName <> '' );
      statusText += suiteName + '.';
   endIf;

   statusText += testCase.name;
   message_sendStatusMessage( statusText );

end-proc;

//
// IBMiUnitui_testCall
//
// Delay the process a bit to slow down the UI.
//
dcl-proc IBMiUnitui_testCall export;

   dcl-pi *n;
      testCase  likeds( testCase_t )  const;
   end-pi;

   dcl-pr  sleep  extProc( 'usleep' );
      microseconds  uns( 10 ) value;
   end-pr;

   sleep( 250000 );

end-proc;

//
// IBMiUnitui_testDone
//
// The test case is complete; the call and any teardown
// has finished.
//
// Note: This procedure is ALWAYS called regardless of any
// exception thrown by the case setup procedure.
//
dcl-proc IBMiUnitui_testDone export;

   dcl-pi *n;
      testCase  likeds( testCase_t )  const;
   end-pi;

   dcl-s  currentSpotValue     char(     1 );
   dcl-s  newSpotValue         varchar(  1 );
   dcl-s  progressBarPosition  int(      5 );
   dcl-s  statusText           varchar( 80 );

   progressBarPosition = ( currentTestCase - 1 ) * %len( progressBar ) / totalTestCases + 1;
   currentSpotValue = %subst( progressBar : progressBarPosition : 1 );
   newSpotValue = '';

   select;
      when ( testCase.result = RESULT_ERROR );
         newSpotValue = PROGRESS_BAR_ERROR;

      when ( testCase.result = RESULT_FAILURE ) and ( currentSpotValue <> PROGRESS_BAR_ERROR );
         newSpotValue = PROGRESS_BAR_FAILED;

      when ( testCase.result = RESULT_SUCCESSFUL ) and ( currentSpotValue = PROGRESS_BAR_UNKNOWN );
         newSpotValue = PROGRESS_BAR_SUCCESSFUL;

   endSl;

   if ( newSpotValue <> '' );
      %subst( progressBar : progressBarPosition : 1 ) = newSpotValue;
   endIf;

   // we don't really need to update the status line at the end of most tests
   // since the next test will immediately change it to something else. The
   // exception is the last test.

   if ( currentTestCase = totalTestCases );

      statusText = getNumericProgress() + ' ' + progressBar;
      message_sendStatusMessage( statusText );

   endIf;

end-proc;

//
// Internal sub-procedures
//

//
// getNumericProgress
//
// Return a string that shows the current test number and the
// total number of tests. This will be the same length for all
// tests in this run.
//

dcl-proc getNumericProgress;

   dcl-pi *n varchar( 20 );
   end-pi;

   dcl-s  maxLength  int(     10 );
   dcl-s  result     varchar( 20 );

   result = %char( totalTestCases );
   maxLength = %len( result );

   result = %char( currentTestCase ) + '/' + result;

   dow ( %len( result ) < maxLength + maxLength + 1 );
      result = ' ' + result;
   endDo;

   return result;

end-proc;