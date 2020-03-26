# IBMiUnit
An RPGLE unit testing framework 

## Installation

### Clone Git Repository

This is the easiest way to obtain IBMiUnit; everyone has a Git client, right?

1. Clone this repository: `git clone git@github.com:MarinaSchwenk/IBMiUnit.git`
2. Change directory into it: `cd IBMiUnit`
3. Use `gmake` (on yum as `make-gnu.ppc64`) to build IBMiUnit.

You can keep up-to-date with IBMiUnit by pulling from the repository and re-building.

### From Save File (part 1)

1. Create a save file on the IBM i, i.e. `CRTSAVF FILE(xxx/IBMIUNIT)`
1. Download `IBMIUNIT.SAVF` from the IBMiUnit repository
1. Choose one of the transfer options, then continue to part 2

#### Transfer Using CPYFRMSTMF

1. Copy the downloaded `IBMIUNIT.SAVF` to the IFS
1. Copy from the IFS to the \*SAVF, i.e. `CPYFRMSTMF FROMSTMF('/path/to/file/IBMIUNIT.SAVF') TOMBR('/QSYS.LIB/xxx.LIB/IBMIUNIT.FILE') MBROPT(*REPLACE) CVTDTA(*NONE) ENDLINFMT(*FIXED) TABEXPN(*NO)`

#### Transfer Using FTP

1. Go to a command window on your PC
1. Go to the location on the PC where `IBMIUNIT.SAVF` is located
1. Enter one of the following: `ftp (ibmi_ip_address)` or `ftp (ibmi_name)`
1. Enter your IBM i username and password for that system when prompted
1. Ensure the transfer mode is binary (there will be no conversion) with `bin`
1. Go to the library on the IBM i where the save file is stored using something like `cd /QSYS.LIB/xxx.LIB`
1. Transfer the save file from the PC to the empty save file on your IBM i with `put IBMiUnit.savf IBMiUnit.savf`
1. When the transfer is complete, exit FTP with `quit`
1. Close the MS-DOS shell with `exit`

### From Save File (part 2)

1. Create the library for the objects, i.e. `CRTLIB yyy`
1. Restore from the \*SAVF, i.e. `RSTLIB SAVLIB(IBMIUNIT) DEV(*SAVF) SAVF(xxx/IBMIUNIT) RSTLIB(yyy) MBROPT(*ALL) ALWOBJDIF(*ALL)`

## Examples

### Program Source

    ctl-opt bndDir( 'IBMIUNIT/IBMIUNIT' );

    /copy IBMiUnit/QRPGLESRC,IBMiUnit_H

    // test initialization/registration

    IBMiUnit_setupSuite( 'TextUtil Tests' );

    IBMiUnit_addTestCase( %pAddr( toUpperCase_fromLower ) : 'toUpperCase_fromLower' );

    IBMiUnit_teardownSuite();
    return;

    // test cases

    dcl-proc toUpperCase_fromLower;

       assertCharEquals( 'MARINA SCHWENK'
                       : toUpperCase( 'marina schwenk' ) // defined in service program
                       );

    end-proc;

### Running

A successful test example:

    > ibmiunit/rununit qtehdr_t
      All 2 tests ran successfully

A test with a failure:

    > ibmiunit/rununit qtehdr_t                                             
      assertion failure in calculateSurcharges_changeOrder: Number of tariff
        items expected:<1> but was:<2>                                      
      Done: 0 errors, 1 failures, 1 successful test(s)

## FAQ

(TODO)