**free

//
// Make sure the numberOfXxx calculations are correct
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'

/define IBMiUi_noMain
/copy '../../main/QRPGLESRC/IBMiUi_h.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit numberOfXxx calculations #1'
                   : *null : *null
				   : *null : %pAddr( checkNumbers ) );

IBMiUnit_addTestSuite( 'TEST_NUM3' );
IBMiUnit_addTestSuite( 'TEST_NUM4' );
IBMiUnit_addTestSuite( 'TEST_NUM5' );

IBMiUnit_teardownSuite();

return;


//
// checkNumbers
//
// Make sure the numberOfXxx numbers are correct.
//
dcl-proc checkNumbers;

   dcl-pi *n;
      testSuite  likeds( testSuite_t )  const;
   end-pi;

   assertNumericEquals( 0 : testSuite.numberOfCases            : 'numberOfCases' );
   assertNumericEquals( 3 : testSuite.numberOfSuites           : 'numberOfSuites' );
   assertNumericEquals( 5 : testSuite.numberOfDescendantCases  : 'numberOfDescendantCases' );
   assertNumericEquals( 0 : testSuite.numberOfDescendantSuites : 'numberOfDescendantSuites' );

end-proc;
