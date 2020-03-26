**free

//
// Test the behavior of the assertNumericEquals()/assertNumericNotEquals() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertNumericEquals()/assertNumericNotEquals() tests' );

IBMiUnit_addTestCase( %pAddr( assertNumericEquals_zero )        : 'assertNumericEquals_zero' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_one )         : 'assertNumericEquals_one' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_negativeOne )
                           : 'assertNumericEquals_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_min )         : 'assertNumericEquals_min' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_max )         : 'assertNumericEquals_max' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_smallest )    : 'assertNumericEquals_smallest' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_negativeSmallest )
                           : 'assertNumericEquals_negativeSmallest' );

IBMiUnit_addTestCase( %pAddr( assertNumericEquals_zero_one )
                           : 'assertNumericEquals_zero_one' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_zero_negativeOne )
                           : 'assertNumericEquals_zero_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_one_negativeOne )
                           : 'assertNumericEquals_one_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertNumericEquals_min_max )
                           : 'assertNumericEquals_min_max' );

IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_zero_zero )
                           : 'assertNumericNotEquals_zero_zero' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_one_one )
                           : 'assertNumericNotEquals_one_one' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_negativeOne_negativeOne )
                           : 'assertNumericNotEquals_negativeOne_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_min_min )
                           : 'assertNumericNotEquals_min_min' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_max_max )
                           : 'assertNumericNotEquals_max_max' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_zero_max )
                           : 'assertNumericNotEquals_zero_max' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_one_zero )
                           : 'assertNumericNotEquals_one_zero' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_negativeOne_zero )
                           : 'assertNumericNotEquals_negativeOne_zero' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_min_zero )
                           : 'assertNumericNotEquals_min_zero' );
IBMiUnit_addTestCase( %pAddr( assertNumericNotEquals_min_max )
                           : 'assertNumericNotEquals_min_max' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertNumericEquals() with expected and actual
// zero values does not throw an exception.
//
dcl-proc assertNumericEquals_zero;

   assertNumericEquals( 0 : 0 );

end-proc;

//
// Make sure assertNumericEquals() with expected and actual
// one (1) values does not throw an exception.
//
dcl-proc assertNumericEquals_one;

   assertNumericEquals( 1 : 1 );

end-proc;

//
// Make sure assertNumericEquals() with expected and actual
// negative one (-1) values does not throw an exception.
//
dcl-proc assertNumericEquals_negativeOne;

   assertNumericEquals( -1 : -1 );

end-proc;

//
// Make sure assertNumericEquals() with expected and actual
// minimum values does not throw an exception.
//
dcl-proc assertNumericEquals_min;

   assertNumericEquals( -99999999999999999999999999999999999.9999999999999999999999999
                      : -99999999999999999999999999999999999.9999999999999999999999999 );

end-proc;

//
// Make sure assertNumericEquals() with expected and actual
// maximum values does not throw an exception.
//
dcl-proc assertNumericEquals_max;

   assertNumericEquals( +99999999999999999999999999999999999.9999999999999999999999999
                      : +99999999999999999999999999999999999.9999999999999999999999999 );

end-proc;

//
// Make sure assertNumericEquals() with expected and actual
// smallest (0.0000000000000000000000001) values does not throw an exception.
//
dcl-proc assertNumericEquals_smallest;

   assertNumericEquals( 0.0000000000000000000000001 : 0.0000000000000000000000001 );

end-proc;

//
// Make sure assertNumericEquals() with expected and actual
// smallest (-0.0000000000000000000000001) values does not throw an exception.
//
dcl-proc assertNumericEquals_negativeSmallest;

   assertNumericEquals( -0.0000000000000000000000001 : -0.0000000000000000000000001 );

end-proc;

//
// Make sure assertNumericEquals() with expected zero and actual 1
// does throw an exception.
//
dcl-proc assertNumericEquals_zero_one;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericEquals( 0 : 1 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericEquals_zero_one: ' +
                          'expected:<0> but was:<1>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericEquals() with expected zero and actual -1
// does throw an exception.
//
dcl-proc assertNumericEquals_zero_negativeOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericEquals( 0 : -1 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericEquals_zero_negativeOne: ' +
                          'expected:<0> but was:<-1>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertIntEquals() with expected 1 and actual -1
// does throw an exception.
//
dcl-proc assertNumericEquals_one_negativeOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericEquals( 1 : -1 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericEquals_one_negativeOne: ' +
                          'expected:<1> but was:<-1>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericEquals() with expected minimum and actual maximum
// does throw an exception.
//
dcl-proc assertNumericEquals_min_max;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericEquals( -99999999999999999999999999999999999.9999999999999999999999999
                         : +99999999999999999999999999999999999.9999999999999999999999999 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericEquals_min_max: ' +
                      'expected:<-99,999,999,999,999,999,999,999,999,999,999,999' +
                                           '.9999999999999999999999999> ' +
                      'but was:<99,999,999,999,999,999,999,999,999,999,999,999' +
                                           '.9999999999999999999999999>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericNotEquals() with expected and actual values of 0
// does throw an exception.
//
dcl-proc assertNumericNotEquals_zero_zero;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericNotEquals( 0 : 0 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericNotEquals_zero_zero: ' +
                          'unexpected:<0>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericNotEquals() with expected and actual values of 1
// does throw an exception.
//
dcl-proc assertNumericNotEquals_one_one;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericNotEquals( 1 : 1 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericNotEquals_one_one: ' +
                          'unexpected:<1>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericNotEquals() with expected and actual values of -1
// does throw an exception.
//
dcl-proc assertNumericNotEquals_negativeOne_negativeOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericNotEquals( -1 : -1 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericNotEquals_negativeOne_negativeOne: ' +
                          'unexpected:<-1>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericNotEquals() with expected and actual values of minimum numeric
// does throw an exception.
//
dcl-proc assertNumericNotEquals_min_min;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericNotEquals( -99999999999999999999999999999999999.9999999999999999999999999
                            : -99999999999999999999999999999999999.9999999999999999999999999 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericNotEquals_min_min: unexpected:<' +
                          '-99,999,999,999,999,999,999,999,999,999,999,999' +
                                           '.9999999999999999999999999>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericNotEquals() with expected and actual values of maximum numeric
// does throw an exception.
//
dcl-proc assertNumericNotEquals_max_max;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNumericNotEquals( 99999999999999999999999999999999999.9999999999999999999999999
                            : 99999999999999999999999999999999999.9999999999999999999999999 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNumericNotEquals_max_max: unexpected:<' +
                          '99,999,999,999,999,999,999,999,999,999,999,999' +
                                           '.9999999999999999999999999>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNumericNotEquals() with expected zero and actual 'max' values
// does not throw an exception.
//
dcl-proc assertNumericNotEquals_zero_max;

   assertNumericNotEquals( 0 : 99999999999999999999999999999999999.9999999999999999999999999 );

end-proc;

//
// Make sure assertNumericNotEquals() with expected one and actual zero values
// does not throw an exception.
//
dcl-proc assertNumericNotEquals_one_zero;

   assertNumericNotEquals( 1 : 0 );

end-proc;

//
// Make sure assertNumericNotEquals() with expected -1 and actual 0 values
// does not throw an exception.
//
dcl-proc assertNumericNotEquals_negativeOne_zero;

   assertNumericNotEquals( -1 : 0 );

end-proc;

//
// Make sure assertNumericNotEquals() with expected 'min' and actual 0 values
// does not throw an exception.
//
dcl-proc assertNumericNotEquals_min_zero;

   assertNumericNotEquals( -99999999999999999999999999999999999.9999999999999999999999999 : 0 );

end-proc;

//
// Make sure assertNumericNotEquals() with expected 'min' and actual 'max' values
// does not throw an exception.
//
dcl-proc assertNumericNotEquals_min_max;

   assertNumericNotEquals( -99999999999999999999999999999999999.9999999999999999999999999
                         : +99999999999999999999999999999999999.9999999999999999999999999 );

end-proc;
