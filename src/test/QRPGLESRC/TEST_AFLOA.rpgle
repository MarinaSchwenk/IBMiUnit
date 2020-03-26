**free

//
// Test the behavior of the assertFloatEquals() and assertFloatNotEquals() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertFloatEquals()/assertFloatNotEquals() tests' );

IBMiUnit_addTestCase( %pAddr( assertFloatEquals_zero )         : 'assertFloatEquals_zero' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_plusZero_minusZero )
                           : 'assertFloatEquals_plusZero_minusZero' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_one )          : 'assertFloatEquals_one' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_negativeOne )  : 'assertFloatEquals_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_min4 )         : 'assertFloatEquals_min4' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_max4 )         : 'assertFloatEquals_max4' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_min8 )         : 'assertFloatEquals_min8' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_max8 )         : 'assertFloatEquals_max8' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_smallest8 )    : 'assertFloatEquals_smallest8' );

IBMiUnit_addTestCase( %pAddr( assertFloatEquals_underPositiveDelta )
                           : 'assertFloatEquals_underPositiveDelta' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_underNegativeDelta )
                           : 'assertFloatEquals_underNegativeDelta' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_overPositiveDelta )
                           : 'assertFloatEquals_overPositiveDelta' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_overNegativeDelta )
                           : 'assertFloatEquals_overNegativeDelta' );

IBMiUnit_addTestCase( %pAddr( assertFloatEquals_zero_one )     : 'assertFloatEquals_zero_one' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_zero_negativeOne )
                            :'assertFloatEquals_zero_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_one_negativeOne )
                            :'assertFloatEquals_one_negativeOne' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_min4_max4 )    : 'assertFloatEquals_min4_max4' );
IBMiUnit_addTestCase( %pAddr( assertFloatEquals_min8_max8 )    : 'assertFloatEquals_min8_max8' );

IBMiUnit_addTestCase( %pAddr( assertFloatNotEquals_zero_zero ) : 'assertFloatNotEquals_zero_zero' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertFloatEquals() with expected and actual
// zero values does not throw an exception.
//
dcl-proc assertFloatEquals_zero;

   assertFloatEquals( +0 : +0 : 0.00000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected +0 and actual -0
// values does not throw an exception.
//
dcl-proc assertFloatEquals_plusZero_minusZero;

   assertFloatEquals( +0 : -0 : 0.00000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// one (1) values does not throw an exception.
//
dcl-proc assertFloatEquals_one;

   assertFloatEquals( +1 : +1 : 0.00000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// negative one (-1) values does not throw an exception.
//
dcl-proc assertFloatEquals_negativeOne;

   assertFloatEquals( -1 : -1 : 0.00000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// min 4-byte float (-3.4028235E38) values does not throw an exception.
//
dcl-proc assertFloatEquals_min4;

   assertFloatEquals( -3.4028235E38 : -3.4028235E38 : 0.00000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// max 4-byte float (3.4028235E38) values does not throw an exception.
//
dcl-proc assertFloatEquals_max4;

   assertFloatEquals( +3.4028235E38 : +3.4028235E38 : 0.00000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// min 8-byte float (-1.797693134862315E+308) values does not throw an exception.
//
dcl-proc assertFloatEquals_min8;

   assertFloatEquals( -1.797693134862315E+308 : -1.797693134862315E+308 : 0.000000000000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// max 8-byte float (1.797693134862315E+308) values does not throw an exception.
//
dcl-proc assertFloatEquals_max8;

   assertFloatEquals( +1.797693134862315E+308 : +1.797693134862315E+308 : 0.000000000000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected 0 and actual
// smallest 8-byte float (1.797693134862315E+308) values does not throw an exception.
//
dcl-proc assertFloatEquals_smallest8;

   assertFloatEquals( +0 : +2.2250738585072013E-308 : 0.000000000000001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// under a positive delta does not throw an exception.
//
dcl-proc assertFloatEquals_underPositiveDelta;

   assertFloatEquals( +1.23400001 : +1.235 : +0.001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// under a negative delta does not throw an exception.
//
dcl-proc assertFloatEquals_underNegativeDelta;

   assertFloatEquals( +1.23400001 : +1.235 : -0.001 );

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// over a positive delta does throw an exception.
//
dcl-proc assertFloatEquals_overPositiveDelta;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( +1.234 : +1.236 : +0.001 );

   on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_overPositiveDelta: ' +
                          'expected:<+1.234000000000000E+000> but was:<+1.236000000000000E+000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertFloatEquals() with expected and actual
// over a positive delta does throw an exception.
//
dcl-proc assertFloatEquals_overNegativeDelta;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( +1.234 : +1.236 : +0.001 );

   on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_overNegativeDelta: ' +
                          'expected:<+1.234000000000000E+000> but was:<+1.236000000000000E+000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertFloatEquals() with expected zero and actual 1
// does throw an exception.
//
dcl-proc assertFloatEquals_zero_one;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( +0 : +1 : 0.00000001 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_zero_one: ' +
                          'expected:<+0.000000000000000E+000> but was:<+1.000000000000000E+000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertFloatEquals() with expected zero and actual -1
// does throw an exception.
//
dcl-proc assertFloatEquals_zero_negativeOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( +0 : -1 : 0.00000001 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_zero_negativeOne: ' +
                          'expected:<+0.000000000000000E+000> but was:<-1.000000000000000E+000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;
//
// Make sure assertFloatEquals() with expected 1 and actual -1
// does throw an exception.
//
dcl-proc assertFloatEquals_one_negativeOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( +1 : -1 : 0.00000001 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_one_negativeOne: ' +
                          'expected:<+1.000000000000000E+000> but was:<-1.000000000000000E+000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertFloatEquals() with expected minimum (-3.4028235E38)
// and actual maximum (3.4028235E38) 4-byte float does throw an exception.
//
dcl-proc assertFloatEquals_min4_max4;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( -3.4028235E38 : 3.4028235E38 : 0.00000001 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_min4_max4: ' +
                          'expected:<-3.402823500000000E+038> but was:<+3.402823500000000E+038>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertFloatEquals() with minimum and maximum
// _comparison_ values 8-bit float does throw an exception.
// Note that these extremes need to be half of the actual limits
// to avoid a floating point overflow condition.
//
dcl-proc assertFloatEquals_min8_max8;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatEquals( -8.988465674311573E+307 : +8.988465674311573E+307 : 0.000000000000001 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatEquals_min8_max8: ' +
                          'expected:<-8.988465674311573E+307> but was:<+8.988465674311573E+307>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertFloatNotEquals() with expected and actual values of 0
// does throw an exception.
//
dcl-proc assertFloatNotEquals_zero_zero;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertFloatNotEquals( +0 : +0 : 0.00000001 );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertFloatNotEquals_zero_zero: ' +
                          'unexpected:<+0.000000000000000E+000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;
