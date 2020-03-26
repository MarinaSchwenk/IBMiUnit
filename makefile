TGTLIB=IBMIUNIT
OBJOWN=QPGMR
SYSTEMOPT=-s

DBGVIEW=*SOURCE
TARGET=V7R2M0

TESTFILES:=$(notdir $(shell ls src/test/QRPGLESRC/*.rpgle))
TESTS:= $(patsubst %.rpgle,%.test,$(TESTFILES))

help:
	@echo ""
	@echo "Build help for IBMiUnit."
	@echo ""
	@echo "\tgmake all                 - Build all objects into IBMIUNIT"
	@echo "\tgmake tests               - Build all tests into IBMIUNIT"
	@echo "\tgmake clean               - Clear IBMIUNIT library and clean temp files"
	@echo ""
	@echo "\tgmake all TGTLIB=MYLIB    - Build IBMiUNIT into MYLIB library"
	@echo "\tgmake all TARGET=V7R2M0   - Specifify target object version."
	@echo ""

all: $(TGTLIB).lib IBMIUNIT.srvpgm IBMIUNIT.bnddir RUNTEST.rpglepgm IBMIUIDSP.rpglepgm IBMIUIINT.rpglepgm
	@echo "Application built!"

IBMIUNIT.srvpgm: IBMIUNIT.rpglemod ARRAYLIST.rpglemod MESSAGE.rpglemod

MESSAGE.srvpgm: MESSAGE.rpglemod

IBMIUNIT.bnddir: IBMIUNIT.entry MESSAGE.entry

RUNTEST.rpglepgm: RUNTEST.cmd IBMIUNIT.bnddir

## General targets

%.rpglemod: src/main/QRPGLESRC/%.rpgle
	system $(SYSTEMOPT) "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1252)"
	system $(SYSTEMOPT) "CRTRPGMOD MODULE($(TGTLIB)/$*) SRCSTMF('$<') TGTRLS($(TARGET)) DBGVIEW($(DBGVIEW))"
	touch $@

%.srvpgm:
	$(eval modules := $(patsubst %,$(TGTLIB)/%,$(basename $(filter %.rpglemod,$(notdir $^)))))
	system $(SYSTEM_PARMS) "CRTSRVPGM SRVPGM($(TGTLIB)/$*) MODULE($(modules)) EXPORT(*ALL)"
	touch $@

%.pgm:
	$(eval modules := $(patsubst %,$(TGTLIB)/%,$(basename $(filter %.rpgle %.sqlrpgle,$(notdir $^)))))
	system $(SYSTEMOPT) "CRTPGM PGM($(TGTLIB)/$*) MODULE($(modules)) ENTMOD(*PGM) ACTGRP(*NEW) BNDDIR($(TGTLIB)/IBMIUNIT)"
	touch $@
	
%.rpglepgm: src/main/QRPGLESRC/%.rpgle
	system $(SYSTEMOPT) "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1252)"
	system $(SYSTEMOPT) "CRTBNDRPG PGM($(TGTLIB)/$*) SRCSTMF('$<') TGTRLS($(TARGET)) DBGVIEW($(DBGVIEW)) BNDDIR($(TGTLIB)/IBMIUNIT) DFTACTGRP(*NO)"
	touch $@
  
%.cmd: src/main/QCMDSRC/%.cmd
	-system -q "CRTSRCPF FILE($(TGTLIB)/QCMDSRC) RCDLEN(112)"
	system $(SYSTEM_PARMS) "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(TGTLIB).lib/QCMDSRC.file/$*.mbr') MBROPT(*REPLACE)"
	system $(SYSTEM_PARMS) "CRTCMD CMD($(TGTLIB)/$*) SRCFILE($(TGTLIB)/QCMDSRC) PGM($(TGTLIB)/$*)"
	touch $@
  
%.bnddir:
	-system -q "CRTBNDDIR BNDDIR($(TGTLIB)/$*)"
	-system -q "CHGOBJOWN OBJ($(TGTLIB)/$*) OBJTYPE(*BNDDIR) NEWOWN($(OBJOWN)) CUROWNAUT(*SAME)"
	-system -q "ADDBNDDIRE BNDDIR($(TGTLIB)/$*) OBJ($(patsubst %.entry,($(TGTLIB)/% *SRVPGM *IMMED),$^))"
	@touch $@

%.entry:
	# Basically do nothing..
	@echo ""
	@touch $@
	
%.lib:
	-system $(SYSTEMOPT) "CRTLIB $(TGTLIB)"
	system $(SYSTEMOPT) "CHGOBJOWN OBJ(QSYS/$(TGTLIB)) OBJTYPE(*LIB) NEWOWN($(OBJOWN)) CUROWNAUT(*SAME)"
	@touch $@

%.test: src/test/QRPGLESRC/%.rpgle
	@echo "Building $(TGTLIB)/$*"
	system $(SYSTEMOPT) "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1252)"
	system $(SYSTEMOPT) "CRTBNDRPG PGM($(TGTLIB)/$*) SRCSTMF('$<') TGTRLS($(TARGET)) DBGVIEW($(DBGVIEW)) BNDDIR($(TGTLIB)/IBMIUNIT) DFTACTGRP(*NO)"
	touch $@

tests:  $(TESTS)
	@echo "Tests built!"

clean:
	rm -rf ./*.bnddir ./*.entry ./*.cmd ./*.lib ./*.pgm ./*.srvpgm ./*.rpglemod ./*.test
	-system $(SYSTEMOPT) "CLRLIB $(TGTLIB)"
