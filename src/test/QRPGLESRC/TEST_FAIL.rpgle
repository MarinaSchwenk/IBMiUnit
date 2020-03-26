**free

ctl-opt bndDir( 'QC2LE' );

//
// Test the behavior of the fail() sub-procedures.
//
// Note that this program tests the very foundation of IBMiUnit, namely the
// ability to trigger a failure. Thus this program is monitoring for
// certain exceptions and ending abnormally as soon as a deviation from
// this core behavior is detected. This is not normal testing behavior
// and should not be done by any other test over this library.
//

/copy '../../main/QRPGLESRC/IBMiUnit_h.rpgle'
/copy '../../main/QRPGLESRC/MESSAGE_H.rpgle'


// initialize the test fixtures

IBMiUnit_setupSuite( 'IBMiUnit fail() tests' );

IBMiUnit_addTestCase( %pAddr( fail_noMessage ) : 'fail_noMessage' );
IBMiUnit_addTestCase( %pAddr( fail_message )   : 'fail_message' );

IBMiUnit_teardownSuite();

return;


// test cases

//
// Make sure fail() w/o any message throws an exception.
//
dcl-proc fail_noMessage;

   dcl-c  PROCEDURE_NAME 'fail_noMessage';
   dcl-ds message      likeds( message_t );

   monitor;

      fail();

      // if we get here we have major problems!

      message_sendEscapeMessageAboveControlBody(
              'exception not thrown by fail() in ' + PROCEDURE_NAME );

   on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text <> 'assertion failure in fail_noMessage' );

         // another big problem

         message_sendEscapeMessageAboveControlBody(
                 'exception thrown by fail() in ' + PROCEDURE_NAME +
                 ' did not have proper text' );

      else;

         message_removeMessageByKey( message.key );

      endIf;

   endMon;

end-proc;

//
// Make sure fail() with a message throws an exception.
//
dcl-proc fail_message;

   dcl-c  PROCEDURE_NAME  'fail_message';
   dcl-c  FAILURE_MESSAGE 'hello out there!';

   dcl-ds message      likeds( message_t );

   monitor;

      fail( FAILURE_MESSAGE );

      // if we get here we have major problems!

      message_sendEscapeMessageAboveControlBody(
              'exception not thrown by fail() in ' + PROCEDURE_NAME );

   on-error;

      // make sure the correct exception was thrown

      message = message_receiveMessage( '*EXCP' );

      if ( message.text <> 'assertion failure in fail_message: ' + FAILURE_MESSAGE );

         // another big problem

         message_sendEscapeMessageAboveControlBody(
                 'exception thrown by fail() in ' + PROCEDURE_NAME +
                 ' did not have proper text' );

      else;

         message_removeMessageByKey( message.key );

      endIf;

   endMon;

end-proc;
