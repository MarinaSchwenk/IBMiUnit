**free

//
// Run some IBMiUnit tests
//
// This is the top-level controller; all tests should be run
// through this program.
//

//------------------------------------------
// input parameters

dcl-pi runTest;
   dcl-parm suite  char( 20 );
   dcl-parm ui     char( 10 );
end-pi;

// variable definitions

dcl-pr externalProgram      extPgm( externalProgramName );
end-pr;
dcl-s  externalProgramName  char( 21 );

// register the user interface plug-in

dcl-pr IBMiUnit_registerUi;
   ui     char( 10 )  const;
end-pr;

IBMiUnit_registerUi( ui );

// run the suite

externalProgramName = toUpperCase( %trim( %subst( suite : 11 : 10 ) ) +
                                   '/' +
                                   %trim( %subst( suite : 1  : 10 ) ) );
callP externalProgram();

return;

//
// toUpperCase
//
// Return an upper-case version of the parameter.
//
dcl-proc toUpperCase;

   dcl-pi *n varchar( 1024 );
      source  varchar( 1024 )  const;
   end-pi;

   dcl-c uppercase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   dcl-c lowercase 'abcdefghijklmnopqrstuvwxyz';

   return %xlate( lowercase : uppercase : source );

end-proc;
