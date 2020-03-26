**free

//
// Test the behavior of the assert() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertXxx() tests' );

IBMiUnit_addTestSuite( 'TEST_AIND' );
IBMiUnit_addTestSuite( 'TEST_ANULL' );
IBMiUnit_addTestSuite( 'TEST_ACHAR' );
IBMiUnit_addTestSuite( 'TEST_ADATE' );
IBMiUnit_addTestSuite( 'TEST_AFLOA' );
IBMiUnit_addTestSuite( 'TEST_ANUM' );
IBMiUnit_addTestSuite( 'TEST_ATIME' );
IBMiUnit_addTestSuite( 'TEST_ATS' );

IBMiUnit_teardownSuite();

return;
