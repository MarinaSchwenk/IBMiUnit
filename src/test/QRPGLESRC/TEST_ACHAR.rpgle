**free

//
// Test the behavior of the assertCharEquals() and assertCharNotEquals() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/message_h.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertCharEquals()/assertCharNotEquals() tests' );

IBMiUnit_addTestCase( %pAddr( assertCharEquals_emptyEmpty )     : 'assertCharEquals_emptyEmpty' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_blankBlank )     : 'assertCharEquals_blankBlank' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_emptyBlank )     : 'assertCharEquals_emptyBlank' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_blankEmpty )     : 'assertCharEquals_blankEmpty' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_trailingBlank )
                           : 'assertCharEquals_trailingBlank' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_trailingBlanks )
                           : 'assertCharEquals_trailingBlanks' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_leadingBlank )   : 'assertCharEquals_leadingBlank' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_caseDifference )
                           : 'assertCharEquals_caseDifference' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_zeroOne )        : 'assertCharEquals_zeroOne' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_prefix )         : 'assertCharEquals_prefix' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_prefixDifference )
                           : 'assertCharEquals_prefixDifference' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_suffix )         : 'assertCharEquals_suffix' );
IBMiUnit_addTestCase( %pAddr( assertCharEquals_suffixDifference )
                           : 'assertCharEquals_suffixDifference' );

// TODO test trailing blanks setting

// TODO test not equals

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertCharEquals() with expected and actual
// empty values does not throw an exception.
//
dcl-proc assertCharEquals_emptyEmpty;

   assertCharEquals( '' : '' );

end-proc;

//
// Make sure assertCharEquals() with expected and actual
// blank values does not throw an exception.
//
dcl-proc assertCharEquals_blankBlank;

   assertCharEquals( ' ' : ' ' );

end-proc;

//
// Make sure assertCharEquals() with expected '' and actual
// ' ' values does throw an exception.
//
dcl-proc assertCharEquals_emptyBlank;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( '' : ' ' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_emptyBlank: ' +
                          'expected:<[]> but was:<[ ]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected ' ' and actual
// '' values does throw an exception.
//
dcl-proc assertCharEquals_blankEmpty;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( ' ' : '' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_blankEmpty: ' +
                          'expected:<[ ]> but was:<[]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc ' and actual
// 'abc  ' values does throw an exception.
//
dcl-proc assertCharEquals_trailingBlanks;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc ' : 'abc  ' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_trailingBlanks: ' +
                          'expected:<abc []> but was:<abc [ ]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc' and actual
// 'abc ' values does throw an exception.
//
dcl-proc assertCharEquals_trailingBlank;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc' : 'abc ' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_trailingBlank: ' +
                          'expected:<abc[]> but was:<abc[ ]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc' and actual
// ' abc' values does throw an exception.
//
dcl-proc assertCharEquals_leadingBlank;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc' : ' abc' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_leadingBlank: ' +
                          'expected:<[]abc> but was:<[ ]abc>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc' and actual
// 'aBc' values does throw an exception.
//
dcl-proc assertCharEquals_caseDifference;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc' : 'aBc' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_caseDifference: ' +
                          'expected:<a[b]c> but was:<a[B]c>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected '1' and actual
// '0' values does throw an exception.
//
dcl-proc assertCharEquals_zeroOne;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( '0' : '1' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_zeroOne: ' +
                          'expected:<[0]> but was:<[1]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected '123' and actual
// 'abc123' values does throw an exception.
//
dcl-proc assertCharEquals_prefix;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( '123' : 'abc123' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_prefix: ' +
                          'expected:<[]123> but was:<[abc]123>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc123' and actual
// 'def123' values does throw an exception.
//
dcl-proc assertCharEquals_prefixDifference;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc123' : 'def123' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_prefixDifference: ' +
                          'expected:<[abc]123> but was:<[def]123>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc' and actual
// 'abc123' values does throw an exception.
//
dcl-proc assertCharEquals_suffix;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc' : 'abc123' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_suffix: ' +
                          'expected:<abc[]> but was:<abc[123]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertCharEquals() with expected 'abc123' and actual
// 'abc456' values does throw an exception.
//
dcl-proc assertCharEquals_suffixDifference;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertCharEquals( 'abc123' : 'abc456' );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( MESSAGE_TYPE_EXCEPTION );

      if ( message.text = 'assertion failure in assertCharEquals_suffixDifference: ' +
                          'expected:<abc[123]> but was:<abc[456]>' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;
