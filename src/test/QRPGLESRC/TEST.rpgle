**free

//
// Test the behavior of the IBMiUnit library.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit tests' );

IBMiUnit_addTestSuite( 'TEST_SETUP' );
IBMiUnit_addTestSuite( 'TEST_NUM0' );
IBMiUnit_addTestSuite( 'TEST_ERROR' );
IBMiUnit_addTestSuite( 'TEST_FAIL' );
IBMiUnit_addTestSuite( 'TEST_ASSER' );

// IBMiUnit_addTestCase( %pAddr( fail_withMessage )   : 'fail_withMessage'  );
// IBMiUnit_addTestCase( %pAddr( error_divideByZero ) : 'error_divideByZero'  );

IBMiUnit_teardownSuite();

return;


//
// fail_withMessage
//
// Always fail with a message so we can see what the UI does with it.
//
dcl-proc fail_withMessage;

   fail( 'this is only a test' );

end-proc;

//
// error_divideByZero
//
// Always throw an exception so we can see what the UI does with it.
//
dcl-proc error_divideByZero;

   dcl-s  divisor  int( 5 );
   dcl-s  result   int( 5 );

   divisor = 0;
   result = 100 / divisor;

end-proc;