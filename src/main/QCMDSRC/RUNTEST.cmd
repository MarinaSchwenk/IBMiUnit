             CMD        PROMPT('Run IBMiUnit Tests')

             PARM       KWD(SUITE) TYPE(Q1) MIN(1) PROMPT('Suite')

             PARM       KWD(UI) TYPE(*CHAR) LEN(10) RSTD(*YES) DFT(*INT) +
                          SPCVAL((*INT IBMiUIINT) (*DSPLY IBMiUIDSP)) +
                          PROMPT('User interface')

 Q1:         QUAL       TYPE(*NAME)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*LIBL) (*CURLIB)) +
                          PROMPT('Library') 