**free

ctl-opt bndDir( 'QC2LE' );

//
// Test the behavior of the setup and teardown sub-procedures.
// This is done by remembering the order of each call and
// a verification after the tests are all done. This is not a
// normal way of running tests and should not be used as a
// model for other tests.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'

dcl-s callHistory  varchar( 2000 );


// initialize the test fixtures

callHistory = '';

IBMiUnit_setupSuite( 'iUnit setup/teardown tests'
                   : %pAddr( testSetup )  : %pAddr( testTeardown )
                   : %pAddr( suiteSetup ) : %pAddr( suiteTeardown ) );

IBMiUnit_addTestCase( %pAddr( nothing1 ) : 'nothing1' );
IBMiUnit_addTestCase( %pAddr( nothing2 ) : 'nothing2' );
IBMiUnit_addTestCase( %pAddr( verify ) : 'verify' );

IBMiUnit_teardownSuite();

return;


// setup/teardown sub-procedures

dcl-proc suiteSetup;
   callHistory += 'suiteSetup';
end-proc;

dcl-proc suiteTeardown;
   callHistory += ':suiteTeardown';
end-proc;

dcl-proc testSetup;
   callHistory += ':testSetup';
end-proc;

dcl-proc testTeardown;
   callHistory += ':testTeardown';
end-proc;

// Test cases

dcl-proc nothing1;
   callHistory += ':nothing1';
end-proc;

dcl-proc nothing2;
   callHistory += ':nothing2';
end-proc;

// verify
//
// Make sure the call stack is correct. This assumes a certain
// order in the execution of the tests, namely that they are
// run in the order they are added to the suite.
//
dcl-proc verify;

   assertCharEquals(
        'suiteSetup:testSetup:nothing1:testTeardown:testSetup:nothing2:testTeardown:testSetup'
      : callHistory
      : 'sub-procedure execution order' );

end-proc;
