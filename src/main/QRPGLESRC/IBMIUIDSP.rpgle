**free

//
// IBMiUnit UI plug-in that uses DSPLY for all messages.
//

ctl-opt  dftActGrp( *no );

// plug-in definition is done by the main-line code

dcl-pr main extPgm( 'IBMIUIDSP' );
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

/copy IBMIUNIT/QRPGLESRC,IBMiUi_h

setup         = %pAddr( IBMiUnitui_setup );
done          = %pAddr( IBMiUnitui_done );
suiteSetup    = %pAddr( IBMiUnitui_suiteSetup );
suiteTeardown = %pAddr( IBMiUnitui_suiteTeardown );
suiteDone     = %pAddr( IBMiUnitui_suiteDone );
testSetup     = %pAddr( IBMiUnitui_testSetup );
testCall      = %pAddr( IBMiUnitui_testCall );
testTeardown  = %pAddr( IBMiUnitui_testTeardown );
testDone      = %pAddr( IBMiUnitui_testDone );

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

   dcl-s  message         char( 52 );

   message = '  setup';

   dsply message;

end-proc;

//
// IBMiUnitui_done
//
// Wrap up, cleanup and do whatever is necessary to
// finalize the UI. This is called as the last step
// before the testing ends. This procedure takes a
// testSuite_t parameter.
//
dcl-proc IBMiUnitui_done export;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   dcl-s  message         char( 52 );

   message = 'Done: ' + %char( testSuite.numberOfErrorTests ) + ' errors, '
                      + %char( testSuite.numberOfFailureTests ) + ' failures, '
                      + %char( testSuite.numberOfSuccessfulTests ) + ' successful test(s)';

   dsply message;

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

   dcl-s  message         char( 52 );

   message = testSuite.result + ' suiteSetup: ' + testSuite.name;

   dsply message;

end-proc;

//
// IBMiUnitui_suiteTeardown
//
// The test suite has finished running tests and is about
// finished. This procedure is called before the suite's
// teardown procedure.
//
// Note: This procedure is NOT called if the suite setup
// procedure returned an exception (failure or error).
//
dcl-proc IBMiUnitui_suiteTeardown export;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   dcl-s  message         char( 52 );

   message = testSuite.result + ' suiteTeardown: ' + testSuite.name;

   dsply message;

end-proc;

//
// IBMiUnitui_suiteDone
//
// The test suite is complete; all tests and teardown
// has finished.
//
// Note: This procedure is ALWAYS called regardless of any
// exception thrown by the suite setup procedure.
//
dcl-proc IBMiUnitui_suiteDone export;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   dcl-s  message         char( 52 );

   message = testSuite.result + ' suiteDone: ' + testSuite.name;

   dsply message;

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

   dcl-s  message         char( 52 );

   message = testCase.result + ' testSetup: ' + testCase.name;

   dsply message;

end-proc;

//
// IBMiUnitui_testCall
//
// A case is going to be called. This is called after
// calling any case setup procedure.
//
dcl-proc IBMiUnitui_testCall export;

   dcl-pi *n;
      testCase  likeds( testCase_t )  const;
   end-pi;

   dcl-s  message         char( 52 );

   message = testCase.result + ' testCall: ' + testCase.name;

   dsply message;

end-proc;

//
// IBMiUnitui_testTeardown
//
// The test case has finished running and is about
// finished. This procedure is called before the case's
// teardown procedure.
//
// Note: This procedure is NOT called if the case setup
// procedure returned an exception (failure or error).
//
dcl-proc IBMiUnitui_testTeardown export;

   dcl-pi *n;
      testCase  likeds( testCase_t )  const;
   end-pi;

   dcl-s  message         char( 52 );

   message = testCase.result + ' testTeardown: ' + testCase.name;

   dsply message;

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

   dcl-s  message         char( 52 );

   message = testCase.result + ' testDone: ' + testCase.name;

   dsply message;

end-proc;
