# IBMiUnit
RPG unit testing framework 

Dependencies 

https://github.com/OSSILE/OSSILE 
Download and restore the OSSILE library to your system. You can do that in their readme.md on the OSSILE project. 

Upload to your system. 
1.	Create a save file on the IBM i, as follows:
CRTSAVF FILE(IBMiUnit/ IBMiUnit)
2.	Go to a command window on your PC
3.	Go to the location on the PC where the save file is stored.
4.	Enter one of the following:
ftp (ibmi_ip_address)
ftp (ibmi_name)
Note: FTP commands are all lowercase.
5.	Enter your IBM i username and password for that system when prompted.
6.	To ensure the transfer mode is binary (there will be no conversion), enter the following command:
BIN
7.	To go to the library on the IBM i where the save file is stored, enter the following command:
CD IBMiUnit
8.	To transfer the save file from the PC to the empty save file on your IBM i, enter the following command:
PUT IBMiUnit IBMiUnit.savf
9.	When the transfer is complete, enter the following command to exit the FTP session:
QUIT
10.	To close the MS-DOS shell, enter the following command:
EXIT

or 
CRTSAVF QGPL/IBMIUNIT
CPYFRMSTMF FROMSTMF('/home/IBMIUNIT.savf') TOMBR('/qsys.lib/qgpl.lib/IBMIUNIT.file')
MBROPT(*REPLACE) CVTDTA(*NONE) ENDLINFMT(*FIXED) TABEXPN(*NO)
CRTLIB yyy
RSTLIB SAVLIB(IBMIUNIT) DEV(*SAVF) SAVF(QGPL/IBMIUNIT) MBROPT(*ALL) ALWOBJ

