**free

//
// Test the behavior of the assertOn() and assertOff() sub-procedures.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit assertOn()/assertOff() tests' );

IBMiUnit_addTestCase( %pAddr( assertOn_on )   : 'assertOn_on' );
IBMiUnit_addTestCase( %pAddr( assertOn_off )  : 'assertOn_off' );
IBMiUnit_addTestCase( %pAddr( assertOff_on )  : 'assertOff_on' );
IBMiUnit_addTestCase( %pAddr( assertOff_off ) : 'assertOff_off' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure assertOn() with *on does not throw an exception.
//
dcl-proc assertOn_on;

   assertOn( *on );

end-proc;

//
// Make sure assertOn() with *off does throw an exception.
//
dcl-proc assertOn_off;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertOn( *off );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertOn_off' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertOff() with *on does throw an exception.
//
dcl-proc assertOff_on;

   dcl-s  exceptionThrown  ind;
   dcl-ds message      likeds( message_t );

   exceptionThrown = *off;

   monitor;

      assertOff( *on );

  on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text = 'assertion failure in assertOff_on' );
         exceptionThrown = *on;
         message_removeMessageByKey( message.key );
      endIf;

   endMon;

   if not( exceptionThrown );
      fail( 'exception not properly thrown' );
   endIf;

end-proc;

//
// Make sure assertOff() with *off does not throw an exception.
//
dcl-proc assertOff_off;

   assertOff( *off );

end-proc;
