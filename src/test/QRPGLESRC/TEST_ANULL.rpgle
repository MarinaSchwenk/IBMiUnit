**free

//
// Test the behavior of the assertNull() and assertNotNull() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertNull()/assertNotNull() tests' );

IBMiUnit_addTestCase( %pAddr( assertNull_null )       : 'assertNull_null' );
IBMiUnit_addTestCase( %pAddr( assertNull_notNull )    : 'assertNull_notNull' );
IBMiUnit_addTestCase( %pAddr( assertNotNull_null )    : 'assertNotNull_null' );
IBMiUnit_addTestCase( %pAddr( assertNotNull_notNull ) : 'assertNotNull_notNull' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertNull() with *NULL does not throw an exception.
//
dcl-proc assertNull_null;

   assertNull( *null );

end-proc;

//
// Make sure assertNull() with not *NULL does throw an exception.
//
dcl-proc assertNull_notNull;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNull( %addr( exceptionThrown ) );

  on-error;

      // make sure the correct exception was thrown
    
      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNull_notNull' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNotNull() with *NULL does throw an exception.
//
dcl-proc assertNotNull_null;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertNotNull( *null );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertNotNull_null' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertNotNull with not *NULL does not throw an exception.
//
dcl-proc assertNotNull_notNull;

   dcl-s  variable  char( 1 );

   assertNotNull( %addr( variable ) );

end-proc;
