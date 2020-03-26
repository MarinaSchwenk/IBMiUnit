**free

ctl-opt timFmt( *iso );

//
// Test the behavior of the assertTimeEquals() and assertTimeNotEquals() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertTimeEquals()/assertTimeNotEquals() tests' );

IBMiUnit_addTestCase( %pAddr( assertTimeEquals_earliest )     : 'assertTimeEquals_earliest' );
IBMiUnit_addTestCase( %pAddr( assertTimeEquals_noon )         : 'assertTimeEquals_noon' );
IBMiUnit_addTestCase( %pAddr( assertTimeEquals_latest )       : 'assertTimeEquals_latest' );

IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_earliest )  : 'assertTimeNotEquals_earliest' );
IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_noon )      : 'assertTimeNotEquals_noon' );
IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_latest )    : 'assertTimeNotEquals_latest' );

IBMiUnit_addTestCase( %pAddr( assertTimeEquals_earliestPlusOne )
                           : 'assertTimeEquals_earliestPlusOne' );
IBMiUnit_addTestCase( %pAddr( assertTimeEquals_minuteDiff )
                           : 'assertTimeEquals_minuteDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimeEquals_hourDiff )
                           : 'assertTimeEquals_hourDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimeEquals_latestMinusOne )
                           : 'assertTimeEquals_latestMinusOne' );

IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_earliestPlusOne )
                           : 'assertTimeNotEquals_earliestPlusOne' );
IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_minuteDiff )
                           : 'assertTimeNotEquals_minuteDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_hourDiff )
                           : 'assertTimeNotEquals_hourDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimeNotEquals_latestMinusOne )
                           : 'assertTimeNotEquals_latestMinusOne' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertTimeEquals() with expected and actual
// 00.00.00 values does not throw an exception.
//
dcl-proc assertTimeEquals_earliest;

   assertTimeEquals( t'00.00.00' : t'00.00.00' );

end-proc;

//
// Make sure assertTimeEquals() with expected and actual
// 12.00.00 values does not throw an exception.
//
dcl-proc assertTimeEquals_noon;

   assertTimeEquals( t'12.00.00' : t'12.00.00' );

end-proc;

//
// Make sure assertTimeEquals() with expected and actual
// 23.59.59 values does not throw an exception.
//
dcl-proc assertTimeEquals_latest;

   assertTimeEquals( t'23.59.59' : t'23.59.59' );

end-proc;

//
// Make sure assertTimeNotEquals() with expected and actual
// 00.00.00 values does throw an exception.
//
dcl-proc assertTimeNotEquals_earliest;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeNotEquals( t'00.00.00' : t'00.00.00' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeNotEquals_earliest: ' +
                          'unexpected:<00.00.00>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeNotEquals() with expected and actual
// 12n values does throw an exception.
//
dcl-proc assertTimeNotEquals_noon;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeNotEquals( t'12.00.00' : t'12.00.00' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeNotEquals_noon: unexpected:<12.00.00>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeNotEquals() with expected and actual
// 23.59.59 values does throw an exception.
//
dcl-proc assertTimeNotEquals_latest;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeNotEquals( t'23.59.59' : t'23.59.59' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeNotEquals_latest: ' +
                          'unexpected:<23.59.59>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeEquals() with expected 00.00.00 and actual
// 00.00.01 values does throw an exception.
//
dcl-proc assertTimeEquals_earliestPlusOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeEquals( t'00.00.00' : t'00.00.01' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeEquals_earliestPlusOne: ' +
                          'expected:<00.00.00> but was:<00.00.01>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeEquals() with expected 08.34.19 and actual
// 08.35.19 values does throw an exception.
//
dcl-proc assertTimeEquals_minuteDiff;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeEquals( t'08.34.19' : t'08.35.19' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeEquals_minuteDiff: ' +
                          'expected:<08.34.19> but was:<08.35.19>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeEquals() with expected 13.14.15 and actual
// 16.14.15 values does throw an exception.
//
dcl-proc assertTimeEquals_hourDiff;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeEquals( t'13.14.15' : t'16.14.15' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeEquals_hourDiff: ' +
                          'expected:<13.14.15> but was:<16.14.15>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeEquals() with expected 23.59.59 and actual
// 23.59.58 values does throw an exception.
//
dcl-proc assertTimeEquals_latestMinusOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimeEquals( t'23.59.59' : t'23.59.58' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimeEquals_latestMinusOne: ' +
                          'expected:<23.59.59> but was:<23.59.58>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimeNotEquals() with expected 00.00.00 and actual
// 00.00.01 values does not throw an exception.
//
dcl-proc assertTimeNotEquals_earliestPlusOne;

   assertTimeNotEquals( t'00.00.00' : t'00.00.01' );

end-proc;

//
// Make sure assertTimeNotEquals() with expected 16.15.17 and actual
// 16.18.17 values does not throw an exception.
//
dcl-proc assertTimeNotEquals_minuteDiff;

   assertTimeNotEquals( t'16.15.17' : t'16.18.17' );

end-proc;

//
// Make sure assertTimeNotEquals() with expected 21.20.19 and actual
// 22.20.19 values does not throw an exception.
//
dcl-proc assertTimeNotEquals_hourDiff;

   assertTimeNotEquals( t'21.20.19' : t'22.20.19' );

end-proc;

//
// Make sure assertTimeNotEquals() with expected 23.59.59 and actual
// 23.59.58 values does not throw an exception.
//
dcl-proc assertTimeNotEquals_latestMinusOne;

   assertTimeNotEquals( t'23.59.59' : t'23.59.58' );

end-proc;
