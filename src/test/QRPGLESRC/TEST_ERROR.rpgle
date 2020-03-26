**free

ctl-opt bndDir( 'QC2LE' );

//
// Make sure IBMiUnit catches sub-procedure errors.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'

/define IBMiUi_noMain
/copy '../../main/QRPGLESRC/IBMiUi_h.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit error catching'
                   : *null : %pAddr( checkCaseResult )
                   : *null : %pAddr( checkSuiteResult ) );

IBMiUnit_addTestSuite( 'TEST_XYZ' );

IBMiUnit_addTestCase( %pAddr( error_divideByZero )     : 'error_divideByZero' );
IBMiUnit_addTestCase( %pAddr( error_indexOutOfBounds ) : 'error_indexOutOfBounds' );
IBMiUnit_addTestCase( %pAddr( error_tooSmall )         : 'error_tooSmall' );

IBMiUnit_teardownSuite();

return;


// test framework call-backs

//
// checkCaseResult
//
// Make sure the case result status is correct.
//
dcl-proc checkCaseResult;

   dcl-pi *n;
      testCase  likeds( testCase_t );
   end-pi;

   assertCharEquals( RESULT_ERROR : testCase.result );

   // if we got here all is well; remove the message and reset the status

   message_removeMessageByKey( testCase.messageKey );

   testCase.result = RESULT_SUCCESSFUL;

end-proc;

//
// checkSuiteResult
//
// Make sure the suite result status is correct.
//
dcl-proc checkSuiteResult;

   dcl-pi *n;
      testSuite  likeds( testSuite_t );
   end-pi;

   assertCharEquals( RESULT_ERROR : testSuite.result );

   // if we got here all is well; reset the status

   testSuite.result = RESULT_SUCCESSFUL;

end-proc;


// test cases

//
// Try to divide by zero.
//
dcl-proc error_divideByZero;

   dcl-s divisor  packed( 5 : 2 );
   dcl-s result   packed( 5 : 2 );

   divisor = 0;
   result = 100 / divisor;

end-proc;

//
// Access an array element that does not exist.
//
dcl-proc error_indexOutOfBounds;

   dcl-s array   like( result )  dim( 12 );
   dcl-s i       int( 5 );
   dcl-s result  packed( 5 : 2 );

   i = 13;
   result = array( i );

end-proc;

//
// Calculate a result that is too large for the receiver variable.
//
dcl-proc error_tooSmall;

   dcl-s result packed( 5 : 2 );

   result = 65432.1 * 2;

end-proc;
