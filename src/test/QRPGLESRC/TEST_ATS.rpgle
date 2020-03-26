**free

ctl-opt datFmt( *iso ) timFmt( *iso );

//
// Test the behavior of the assertTimestampEquals() and assertTimestampNotEquals() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertTimestampEquals()/assertTimestampNotEquals() tests' );

IBMiUnit_addTestCase( %pAddr( assertTimestampEquals_earliest )     
                           : 'assertTimestampEquals_earliest' );
IBMiUnit_addTestCase( %pAddr( assertTimestampEquals_latest )       
                           : 'assertTimestampEquals_latest' );

IBMiUnit_addTestCase( %pAddr( assertTimestampNotEquals_earliest )  
                           : 'assertTimestampNotEquals_earliest' );
IBMiUnit_addTestCase( %pAddr( assertTimestampNotEquals_latest )    
                           : 'assertTimestampNotEquals_latest' );

IBMiUnit_addTestCase( %pAddr( assertTimestampEquals_earliestPlusOne )
                           : 'assertTimestampEquals_earliestPlusOne' );
IBMiUnit_addTestCase( %pAddr( assertTimestampEquals_minuteDiff )
                           : 'assertTimestampEquals_minuteDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimestampEquals_hourDiff )
                           : 'assertTimestampEquals_hourDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimestampEquals_latestMinusOne )
                           : 'assertTimestampEquals_latestMinusOne' );

IBMiUnit_addTestCase( %pAddr( assertTimestampNotEquals_earliestPlusOne )
                           : 'assertTimestampNotEquals_earliestPlusOne' );
IBMiUnit_addTestCase( %pAddr( assertTimestampNotEquals_minuteDiff )
                           : 'assertTimestampNotEquals_minuteDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimestampNotEquals_hourDiff )
                           : 'assertTimestampNotEquals_hourDiff' );
IBMiUnit_addTestCase( %pAddr( assertTimestampNotEquals_latestMinusOne )
                           : 'assertTimestampNotEquals_latestMinusOne' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertTimestampEquals() with expected and actual
// 0001-01-01-00.00.00.000000 values does not throw an exception.
//
dcl-proc assertTimestampEquals_earliest;

   assertTimestampEquals( z'0001-01-01-00.00.00.000000' : z'0001-01-01-00.00.00.000000' );

end-proc;

//
// Make sure assertTimestampEquals() with expected and actual
// 9999-12-31-23.59.59.999999 values does not throw an exception.
//
dcl-proc assertTimestampEquals_latest;

   assertTimestampEquals( z'9999-12-31-23.59.59.999999' : z'9999-12-31-23.59.59.999999' );

end-proc;

//
// Make sure assertTimestampNotEquals() with expected and actual
// 0001-01-01-00.00.00.000000 values does throw an exception.
//
dcl-proc assertTimestampNotEquals_earliest;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimestampNotEquals( z'0001-01-01-00.00.00.000000' : z'0001-01-01-00.00.00.000000' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimestampNotEquals_earliest: ' +
                          'unexpected:<0001-01-01-00.00.00.000000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimestampNotEquals() with expected and actual
// 9999-12-31-23.59.59.999999 values does throw an exception.
//
dcl-proc assertTimestampNotEquals_latest;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimestampNotEquals( z'9999-12-31-23.59.59.999999' : z'9999-12-31-23.59.59.999999' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimestampNotEquals_latest: ' +
                          'unexpected:<9999-12-31-23.59.59.999999>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimestampEquals() with expected 0001-01-01-00.00.00.000000 and actual
// 00.00.010001-01-01-00.00.00.000001 values does throw an exception.
//
dcl-proc assertTimestampEquals_earliestPlusOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimestampEquals( z'0001-01-01-00.00.00.000000' : z'0001-01-01-00.00.00.000001' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimestampEquals_earliestPlusOne: ' +
                'expected:<0001-01-01-00.00.00.000000> but was:<0001-01-01-00.00.00.000001>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimestampEquals() with expected 2019-11-11-08.34.19 and actual
// 2019-11-11-08.35.19 values does throw an exception.
//
dcl-proc assertTimestampEquals_minuteDiff;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimestampEquals( z'2019-11-11-08.34.19.000000' : z'2019-11-11-08.35.19.000000' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimestampEquals_minuteDiff: ' +
                'expected:<2019-11-11-08.34.19.000000> but was:<2019-11-11-08.35.19.000000>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimestampEquals() with expected 2010-11-12-13.14.15.161718 and actual
// 2010-11-12-16.14.15.161718 values does throw an exception.
//
dcl-proc assertTimestampEquals_hourDiff;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimestampEquals( z'2010-11-12-13.14.15.161718' : z'2010-11-12-16.14.15.161718' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimestampEquals_hourDiff: ' +
                'expected:<2010-11-12-13.14.15.161718> but was:<2010-11-12-16.14.15.161718>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimestampEquals() with expected 9999-12-31-23.59.59.999999 and actual
// 9999-12-31-23.59.59.999998 values does throw an exception.
//
dcl-proc assertTimestampEquals_latestMinusOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertTimestampEquals( z'9999-12-31-23.59.59.999999' : z'9999-12-31-23.59.59.999998' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertTimestampEquals_latestMinusOne: ' +
                'expected:<9999-12-31-23.59.59.999999> but was:<9999-12-31-23.59.59.999998>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertTimestampNotEquals() with expected 0001-01-01-00.00.00.000000 and actual
// 0001-01-01-00.00.00.000001 values does not throw an exception.
//
dcl-proc assertTimestampNotEquals_earliestPlusOne;

   assertTimestampNotEquals( z'0001-01-01-00.00.00.000000' : z'0001-01-01-00.00.00.000001' );

end-proc;

//
// Make sure assertTimestampNotEquals() with expected 2011-12-13-16.15.17.181920 and actual
// 2011-12-13-16.18.17.181920 values does not throw an exception.
//
dcl-proc assertTimestampNotEquals_minuteDiff;

   assertTimestampNotEquals( z'2011-12-13-16.15.17.181920' : z'2011-12-13-16.18.17.181920' );

end-proc;

//
// Make sure assertTimestampNotEquals() with expected 2002-03-22-21.20.19.181716 and actual
// 2002-03-22-22.20.19.181716 values does not throw an exception.
//
dcl-proc assertTimestampNotEquals_hourDiff;

   assertTimestampNotEquals( z'2002-03-22-21.20.19.181716' : z'2002-03-22-22.20.19.181716' );

end-proc;

//
// Make sure assertTimestampNotEquals() with expected 9999-12-31-23.59.59.999999 and actual
// 9999-12-31-23.59.59.999998 values does not throw an exception.
//
dcl-proc assertTimestampNotEquals_latestMinusOne;

   assertTimestampNotEquals( z'9999-12-31-23.59.59.999999' : z'9999-12-31-23.59.59.999998' );

end-proc;
