**free

ctl-opt datFmt( *iso );

//
// Test the behavior of the assertDateEquals() and assertDateNotEquals() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertDateEquals()/assertDateNotEquals() tests' );

IBMiUnit_addTestCase( %pAddr( assertDateEquals_earliest )     : 'assertDateEquals_earliest' );
IBMiUnit_addTestCase( %pAddr( assertDateEquals_century )      : 'assertDateEquals_century' );
IBMiUnit_addTestCase( %pAddr( assertDateEquals_leapDay )      : 'assertDateEquals_leapDay' );
IBMiUnit_addTestCase( %pAddr( assertDateEquals_latest )       : 'assertDateEquals_latest' );

IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_earliest )  : 'assertDateNotEquals_earliest' );
IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_century )   : 'assertDateNotEquals_century' );
IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_leapDay )   : 'assertDateNotEquals_leapDay' );
IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_latest )    : 'assertDateNotEquals_latest' );

IBMiUnit_addTestCase( %pAddr( assertDateEquals_earliestPlusOne )
                           : 'assertDateEquals_earliestPlusOne' );
IBMiUnit_addTestCase( %pAddr( assertDateEquals_monthDiff )
                           : 'assertDateEquals_monthDiff' );
IBMiUnit_addTestCase( %pAddr( assertDateEquals_yearDiff )
                           : 'assertDateEquals_yearDiff' );
IBMiUnit_addTestCase( %pAddr( assertDateEquals_latestMinusOne )
                           : 'assertDateEquals_latestMinusOne' );

IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_earliestPlusOne )
                           : 'assertDateNotEquals_earliestPlusOne' );
IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_monthDiff )
                           : 'assertDateNotEquals_monthDiff' );
IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_yearDiff )
                           : 'assertDateNotEquals_yearDiff' );
IBMiUnit_addTestCase( %pAddr( assertDateNotEquals_latestMinusOne )
                           : 'assertDateNotEquals_latestMinusOne' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertDateEquals() with expected and actual
// 0001-01-01 values does not throw an exception.
//
dcl-proc assertDateEquals_earliest;

   assertDateEquals( d'0001-01-01' : d'0001-01-01' );

end-proc;

//
// Make sure assertDateEquals() with expected and actual
// 2000-01-01 values does not throw an exception.
//
dcl-proc assertDateEquals_century;

   assertDateEquals( d'2000-01-01' : d'2000-01-01' );

end-proc;

//
// Make sure assertDateEquals() with expected and actual
// 2020-02-29 values does not throw an exception.
//
dcl-proc assertDateEquals_leapDay;

   assertDateEquals( d'2020-02-29' : d'2020-02-29' );

end-proc;

//
// Make sure assertDateEquals() with expected and actual
// 9999-12-31 values does not throw an exception.
//
dcl-proc assertDateEquals_latest;

   assertDateEquals( d'9999-12-31' : d'9999-12-31' );

end-proc;

//
// Make sure assertDateNotEquals() with expected and actual
// 0001-01-01 values does throw an exception.
//
dcl-proc assertDateNotEquals_earliest;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateNotEquals( d'0001-01-01' : d'0001-01-01' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateNotEquals_earliest: ' +
                          'unexpected:<0001-01-01>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateNotEquals() with expected and actual
// 2000-01-01 values does throw an exception.
//
dcl-proc assertDateNotEquals_century;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateNotEquals( d'2000-01-01' : d'2000-01-01' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateNotEquals_century: ' +
                          'unexpected:<2000-01-01>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateNotEquals() with expected and actual
// 2020-02-29 values does throw an exception.
//
dcl-proc assertDateNotEquals_leapDay;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateNotEquals( d'2020-02-29' : d'2020-02-29' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateNotEquals_leapDay: ' +
                          'unexpected:<2020-02-29>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateNotEquals() with expected and actual
// 9999-12-31 values does throw an exception.
//
dcl-proc assertDateNotEquals_latest;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateNotEquals( d'9999-12-31' : d'9999-12-31' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateNotEquals_latest: ' +
                          'unexpected:<9999-12-31>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateEquals() with expected 0001-01-01 and actual
// 0001-01-02 values does throw an exception.
//
dcl-proc assertDateEquals_earliestPlusOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateEquals( d'0001-01-01' : d'0001-01-02' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateEquals_earliestPlusOne: ' +
                          'expected:<0001-01-01> but was:<0001-01-02>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateEquals() with expected 2018-11-26 and actual
// 2018-10-26 values does throw an exception.
//
dcl-proc assertDateEquals_monthDiff;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateEquals( d'2018-11-26' : d'2018-10-26' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateEquals_monthDiff: ' +
                          'expected:<2018-11-26> but was:<2018-10-26>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateEquals() with expected 2018-11-26 and actual
// 2019-11-26 values does throw an exception.
//
dcl-proc assertDateEquals_yearDiff;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateEquals( d'2018-11-26' : d'2019-11-26' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateEquals_yearDiff: ' +
                          'expected:<2018-11-26> but was:<2019-11-26>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateEquals() with expected 9999-12-31 and actual
// 9999-12-30 values does throw an exception.
//
dcl-proc assertDateEquals_latestMinusOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertDateEquals( d'9999-12-31' : d'9999-12-30' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertDateEquals_latestMinusOne: ' +
                          'expected:<9999-12-31> but was:<9999-12-30>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertDateNotEquals() with expected 0001-01-01 and actual
// 0001-01-02 values does not throw an exception.
//
dcl-proc assertDateNotEquals_earliestPlusOne;

   assertDateNotEquals( d'0001-01-01' : d'0001-01-02' );

end-proc;

//
// Make sure assertDateNotEquals() with expected 2018-11-26 and actual
// 2018-10-26 values does not throw an exception.
//
dcl-proc assertDateNotEquals_monthDiff;

   assertDateNotEquals( d'2018-11-26' : d'2018-10-26' );

end-proc;

//
// Make sure assertDateNotEquals() with expected 2018-11-26 and actual
// 2019-11-26 values does not throw an exception.
//
dcl-proc assertDateNotEquals_yearDiff;

   assertDateNotEquals( d'2018-11-26' : d'2019-11-26' );

end-proc;

//
// Make sure assertDateNotEquals() with expected 9999-12-31 and actual
// 9999-12-30 values does not throw an exception.
//
dcl-proc assertDateNotEquals_latestMinusOne;

   assertDateNotEquals( d'9999-12-31' : d'9999-12-30' );

end-proc;
