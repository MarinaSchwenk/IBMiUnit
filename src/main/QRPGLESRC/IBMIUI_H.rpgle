**free

/if not defined ( IBMiui_H )
/define IBMiUi_H

//
// Definitions for the IBMiUnit user interface plug-in.
//
// You do not need this file to test your programs. This file identifies
// the sub-procedures that must be available in a UI plug-in. Several
// UIs are already provided and the appropriate one is loaded dynamically
// at run-time.
//


//
// values for testCase_t.procedureOrSuite
//
dcl-c TEST_PROCEDURE 'P';
dcl-c TEST_SUITE     'S';

//
// values for testSuite_t.result and testCase_t.result
//
dcl-c RESULT_UNKNOWN      '?';
dcl-c RESULT_SUCCESSFUL   'S';
dcl-c RESULT_FAILURE      'F';
dcl-c RESULT_ERROR        'E';
dcl-c RESULT_INTERRUPTED  'I';

dcl-ds testSuite_t qualified template;
   name                      varchar(   256 );
   programName               varchar( 10 );
   programLibrary            varchar( 10 );
   result                    char( 1 );
   numberOfCases             int( 10 );
   numberOfSuites            int( 10 );
   numberOfDescendantCases   int( 10 );
   numberOfDescendantSuites  int( 10 );
   numberOfSuccessfulTests   int( 10 );
   numberOfFailureTests      int( 10 );
   numberOfErrorTests        int( 10 );
   testSetupProcedure        pointer( *proc );
   testTeardownProcedure     pointer( *proc );
   suiteSetupProcedure       pointer( *proc );
   suiteTeardownProcedure    pointer( *proc );
   tests                     pointer;
end-ds;

dcl-ds testCase_t qualified template;
   procedureOrSuite     char( 1 );
   result               char( 1 );
   messageId            char( 7 );
   messageKey           char( 4 );
   name                 varchar(   256 );
   procedure            pointer( *proc );
   suite                likeds( testSuite_t );
end-ds;

/if not defined ( IBMiUi_noMain )

//
// UI program parameter definition.
//
// You only need to initialize the callbacks you use
// (i.e. you can leave the others alone or set them
// to *NULL).
//
dcl-pi main;

   //
   // setup
   //
   // Initialize UI for the test environment.
   // This will be called before any test or test/suite setup procedures.
   // This procedure takes a testSuite_t parameter that represents the
   // top-level, or all, tests that will be run.
   //
   dcl-parm setup  pointer( *proc );

   //
   // done
   //
   // Wrap up, cleanup and do whatever is necessary to
   // finalize the UI. This is called as the last step
   // before the testing ends. This procedure takes a
   // testSuite_t parameter.
   //
   dcl-parm done  pointer( *proc );

   //
   // suiteSetup
   //
   // A new suite has just been started. This is called before
   // calling any suite setup procedure. This procedure takes
   // a testSuite_t parameter.
   //
   dcl-parm suiteSetup  pointer( *proc );

   //
   // suiteTeardown
   //
   // The test suite has finished running tests and is about
   // finished. This procedure is called before the suite's
   // teardown procedure and takes a testSuite_t parameter.
   //
   // Note: This procedure is NOT called if the suite setup
   // procedure returned an exception (failure or error).
   //
   dcl-parm suiteTeardown  pointer( *proc );

   //
   // suiteDone
   //
   // The test suite is complete; all tests and teardown
   // has finished. This procedure takes a testSuite_t parameter.
   //
   // Note: This procedure is ALWAYS called regardless of any
   // exception thrown by the suite setup procedure.
   //
   dcl-parm suiteDone  pointer( *proc );

   //
   // testSetup
   //
   // A new case has just been started. This is called before
   // calling any case setup procedure. This procedure takes
   // a testCase_t parameter.
   //
   dcl-parm testSetup  pointer( *proc );

   //
   // testCall
   //
   // A case is going to be called. This is called after
   // calling any case setup procedure. This procedure takes
   // a testCase_t parameter.
   //
   dcl-parm testCall  pointer( *proc );

   //
   // testTeardown
   //
   // The test case has finished running and is about
   // finished. This procedure is called before the case's
   // teardown procedure and takes a testCase_t parameter.
   //
   // Note: This procedure is NOT called if the case setup
   // procedure returned an exception (failure or error).
   //
   dcl-parm testTeardown  pointer( *proc );

   //
   // testDone
   //
   // The test case is complete; the call and any teardown
   // has finished. This procedure takes a testCase_t parameter.
   //
   // Note: This procedure is ALWAYS called regardless of any
   // exception thrown by the case setup procedure.
   //
   dcl-parm testDone  pointer( *proc );

   //
   // isStopRequested
   //
   // Return *ON if the testing should be stopped. This provides
   // a graceful way for the UI to interrupt the tests and exit
   // as soon as possible. This procedure takes no parameters and
   // returns an indicator.
   //
   dcl-parm isStopRequested  pointer( *proc );

end-pi;

/endif
/endif
