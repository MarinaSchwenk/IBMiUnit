**free
ctl-opt bndDir( 'TEXTUTILS' : 'IBMIUNIT/IBMIUNIT' : 'OSSILE/OSSILE' );

// Test TEXTUTILS
//
// Modification History
//
// 2/25/19..Stevers
//   1. New program, copied from UTILS_TEST.
//   2. Use IBMiUnit framework.
//   3. Add tests for removeAccents and removeUnprintable
// 6/13/19..Stevers
//   1. Removed failTest.
//   2. Added some tests for parseDate.
//-------------------------------------------------------------------------------------------------

 /copy TextUtil_H
 /copy IBMiUnit/QRPGLESRC,IBMiUnit_H
 /copy ArrayLst_H

 dcl-s arrayList pointer;

 IBMiUnit_setupSuite( 'TextUtil Tests'
                 : %pAddr( beforeTest ) : %pAddr( afterTest ) );

 IBMiUnit_addTestCase( %pAddr( toUpperCase_fromLower          ) : 'toUpperCase_fromLower' );
 IBMiUnit_addTestCase( %pAddr( toUpperCase_fromMixed          ) : 'toUpperCase_fromMixed' );
 IBMiUnit_addTestCase( %pAddr( toUpperCase_withBlanks         ) : 'toUpperCase_withBlanks' );
 IBMiUnit_addTestCase( %pAddr( toLowerCase_fromUpper          ) : 'toLowerCase_fromUpper' );
 IBMiUnit_addTestCase( %pAddr( toLowerCase_fromMixed          ) : 'toLowerCase_fromMixed' );
 IBMiUnit_addTestCase( %pAddr( toLowerCase_withBlanks         ) : 'toLowerCase_withBlanks' );

 IBMiUnit_addTestCase( %pAddr( trimAndUpperCase_fromLower     ) : 'trimAndUpperCase_fromLower' );
 IBMiUnit_addTestCase( %pAddr( trimAndUpperCase_leadingSpaces )
                             : 'trimAndUpperCase_leadingSpaces' );
 IBMiUnit_addTestCase( %pAddr( trimAndUpperCase_bothSpaces    ) : 'trimAndUpperCase_bothSpaces' );
 IBMiUnit_addTestCase( %pAddr( trimAndLowerCase_fromMixed     ) : 'trimAndLowerCase_fromMixed' );
 IBMiUnit_addTestCase( %pAddr( trimAndLowerCase_leadingSpaces )
                             : 'trimAndLowerCase_leadingSpaces' );
 IBMiUnit_addTestCase( %pAddr( trimAndLowerCase_bothSpaces    ) : 'trimAndLowerCase_bothSpaces' );

 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_null         ) : 'toStringJsonArray_null' );
 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_zeroElements )
                             : 'toStringJsonArray_zeroElements' );
 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_oneElement   ) : 'toStringJsonArray_oneElement' );
 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_twoElements  ) : 'toStringJsonArray_twoElements' );
 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_doubleQuotes )
                              : 'toStringJsonArray_doubleQuotes' );
 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_singleQuotes )
                              : 'toStringJsonArray_singleQuotes' );
 IBMiUnit_addTestCase( %pAddr( toStringJsonArray_paddedValues )
                              : 'toStringJsonArray_paddedValues' );

 IBMiUnit_addTestCase( %pAddr( scanReverse_from25             ) : 'scanReverse_from25' );
 IBMiUnit_addTestCase( %pAddr( scanReverse_from30             ) : 'scanReverse_from30' );
 // TODO: Shelly: copy remaining _textutil_ tests from UTILS_TEST
 IBMiUnit_addTestCase( %pAddr( scanReverse_from25to0          ) : 'scanReverse_from25to0' );
 IBMiUnit_addTestCase( %pAddr( scanReverse_fromEndToStart     ) : 'scanReverse_fromEndToStart' );
 IBMiUnit_addTestCase( %pAddr( scanReverse_fromEndTo56        ) : 'scanReverse_fromEndTo56' );
 IBMiUnit_addTestCase( %pAddr( scanReverse_fromEndToComma     ) : 'scanReverse_fromEndToComma' );

// IBMiUnit_addTestCase( %pAddr( toYN_singleCap                 ) : 'toYN_singleCap' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordMixed                 ) : 'toYN_wordMixed' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordLower                 ) : 'toYN_wordLower' );
// IBMiUnit_addTestCase( %pAddr( toYN_singleSpcCap              ) : 'toYN_singleSpcCap' );
// IBMiUnit_addTestCase( %pAddr( toYN_numSpaces                 ) : 'toYN_numSpaces' );
// IBMiUnit_addTestCase( %pAddr( toYN_word2Mixed                ) : 'toYN_word2Mixed' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordSglQte                ) : 'toYN_wordSglQte' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordDblQte                ) : 'toYN_wordDblQte' );
// IBMiUnit_addTestCase( %pAddr( toYN_singleCap2                ) : 'toYN_singleCap2' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordMixed2                ) : 'toYN_wordMixed2' );
// IBMiUnit_addTestCase( %pAddr( toYN_singleSpcCap2             ) : 'toYN_singleSpcCap2' );
// IBMiUnit_addTestCase( %pAddr( toYN_numSpaces2                ) : 'toYN_numSpaces' );
// IBMiUnit_addTestCase( %pAddr( toYN_numSpaces2                ) : 'toYN_numSpaces' );
// IBMiUnit_addTestCase( %pAddr( toYN_word3Mixed                ) : 'toYN_word3Mixed' );
// IBMiUnit_addTestCase( %pAddr( toYN_word3Mixed                ) : 'toYN_word3Mixed' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordSglQte2               ) : 'toYN_wordSglQte2' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordDblQte2               ) : 'toYN_wordDblQte2' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordLower2                ) : 'toYN_wordLower2' );
// IBMiUnit_addTestCase( %pAddr( toYN_blank                     ) : 'toYN_blank' );
// IBMiUnit_addTestCase( %pAddr( toYN_blankSpaces               ) : 'toYN_blankSpaces' );
// IBMiUnit_addTestCase( %pAddr( toYN_wordSglQte3               ) : 'toYN_wordSglQte3' );
// IBMiUnit_addTestCase( %pAddr( toYN_singleLower               ) : 'toYN_singleLower' );
// Shelly - end

 IBMiUnit_addTestCase( %pAddr( removeAccents_nothing          ) : 'removeAccents_nothing' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_a                ) : 'removeAccents_a' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_b                ) : 'removeAccents_b' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_c                ) : 'removeAccents_c' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_e                ) : 'removeAccents_e' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_i                ) : 'removeAccents_i' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_n                ) : 'removeAccents_n' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_o                ) : 'removeAccents_o' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_u                ) : 'removeAccents_u' );
 IBMiUnit_addTestCase( %pAddr( removeAccents_y                ) : 'removeAccents_y' );

 IBMiUnit_addTestCase( %pAddr( removeUnprintable_nothing      ) : 'removeUnprintable_nothing' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex0         ) : 'removeUnprintable_hex0' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex1         ) : 'removeUnprintable_hex1' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex2         ) : 'removeUnprintable_hex2' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex3         ) : 'removeUnprintable_hex3' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex4         ) : 'removeUnprintable_hex4' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex5         ) : 'removeUnprintable_hex5' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex6         ) : 'removeUnprintable_hex6' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex7         ) : 'removeUnprintable_hex7' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex8         ) : 'removeUnprintable_hex8' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hex9         ) : 'removeUnprintable_hex9' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hexA         ) : 'removeUnprintable_hexA' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hexB         ) : 'removeUnprintable_hexB' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hexC         ) : 'removeUnprintable_hexC' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hexD         ) : 'removeUnprintable_hexD' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hexE         ) : 'removeUnprintable_hexE' );
 IBMiUnit_addTestCase( %pAddr( removeUnprintable_hexF         ) : 'removeUnprintable_hexF' );

 IBMiUnit_addTestCase( %pAddr( parseDate_slashMdcy            ) : 'parseDate_slashMdcy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slashMdy             ) : 'parseDate_slashMdy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slashMd99            ) : 'parseDate_slashMd99' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashMdcy             ) : 'parseDate_dashMdcy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashMdy              ) : 'parseDate_dashMdy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashMd99             ) : 'parseDate_dashMd99' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dotDmcy              ) : 'parseDate_dotDmcy' );

 IBMiUnit_addTestCase( %pAddr( parseDate_slashMdcyTime        ) : 'parseDate_slashMdcyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slashMdyTime         ) : 'parseDate_slashMdyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slashMd99Time        ) : 'parseDate_slashMd99Time' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashMdcyTime         ) : 'parseDate_dashMdcyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashMdyTime          ) : 'parseDate_dashMdyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashMd99Time         ) : 'parseDate_dashMd99Time' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dotDmcyTime          ) : 'parseDate_dotDmcyTime' );

 IBMiUnit_addTestCase( %pAddr( parseDate_slash0Mdcy           ) : 'parseDate_slash0Mdcy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slash0Mdy            ) : 'parseDate_slash0Mdy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slash0Md99           ) : 'parseDate_slash0Md99' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dash0Mdcy            ) : 'parseDate_dash0Mdcy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dash0Mdy             ) : 'parseDate_dash0Mdy' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dash0Md99            ) : 'parseDate_dash0Md99' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dot0Dmcy             ) : 'parseDate_dot0Dmcy' );

 IBMiUnit_addTestCase( %pAddr( parseDate_slash0MdcyTime       ) : 'parseDate_slash0MdcyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slash0MdyTime        ) : 'parseDate_slash0MdyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_slash0Md99Time       ) : 'parseDate_slash0Md99Time' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dash0MdcyTime        ) : 'parseDate_dash0MdcyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dash0MdyTime         ) : 'parseDate_dash0MdyTime' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dash0Md99Time        ) : 'parseDate_dash0Md99Time' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dot0DmcyTime         ) : 'parseDate_dot0DmcyTime' );

 IBMiUnit_addTestCase( %pAddr( parseDate_dashIso              ) : 'parseDate_dashIso' );
 IBMiUnit_addTestCase( %pAddr( parseDate_dashIsoTime          ) : 'parseDate_dashIsoTime' );

 IBMiUnit_teardownSuite();
 return;

 // support methods

 dcl-proc beforeTest;

    arrayList = *null;

 end-proc;

 dcl-proc afterTest;

    if ( arrayList <> *null );
       arraylist_dispose( arrayList );
    endIf;

 end-proc;

 // test cases

 dcl-proc toUpperCase_fromLower;

    assertCharEquals( 'MARINA SCHWENK'
                    : toUpperCase( 'marina schwenk' )
                    );

 end-proc;

 dcl-proc toUpperCase_fromMixed;

    assertCharEquals( 'WINTERS COMING'
                    : toUpperCase( 'Winters coming' )
                    );

 end-proc;

 dcl-proc toUpperCase_withBlanks;

    assertCharEquals( ' HA! '
                    : toUpperCase( ' Ha! ' )
                    );

 end-proc;

 dcl-proc toLowerCase_fromUpper;

    assertCharEquals( 'its dark outside'
                    : toLowerCase( 'ITS DARK OUTSIDE' )
                    );

 end-proc;

 dcl-proc toLowerCase_fromMixed;

    assertCharEquals( 'its warm outside'
                    : toLowerCase( 'ITS warm OUTSIDE' )
                    );

 end-proc;

 dcl-proc toLowerCase_withBlanks;

    assertCharEquals( '  (hello?)  '
                    : toLowerCase( '  (Hello?)  ' )
                    );

 end-proc;

 dcl-proc trimAndUpperCase_fromLower;

    assertCharEquals( 'WE HAVE ALOT TO DO'
                    : trimAndUpperCase( 'we have alot to do     ' )
                    );

 end-proc;

 dcl-proc trimAndUpperCase_leadingSpaces;

    assertCharEquals( 'SPACES AT THE BEGINNING'
                    : trimAndUpperCase( '   spaces at the beginning' )
                    );

 end-proc;

 dcl-proc trimAndUpperCase_bothSpaces;

    assertCharEquals( 'BOTH'
                    : trimAndUpperCase( '   both  ' )
                    );

 end-proc;

 dcl-proc trimAndLowerCase_fromMixed;

    assertCharEquals( 'its storming outside'
                    : trimAndLowerCase( 'ITs Storming Outside   ' )
                    );

 end-proc;

 dcl-proc trimAndLowerCase_leadingSpaces;

    assertCharEquals( 'more starting spaces'
                    : trimAndLowerCase( '   MoRe Starting sPaCeS' )
                    );

 end-proc;

 dcl-proc trimAndLowerCase_bothSpaces;

    assertCharEquals( 'spaces everywhere!'
                    : trimAndLowerCase( '       SPACES EVERYWHERE!   ' )
                    );

 end-proc;

 dcl-proc toStringJsonArray_null;

    assertCharEquals( ''
                    : toStringJsonArray( *null )
                    );

 end-proc;

 dcl-proc toStringJsonArray_zeroElements;

    arrayList = arraylist_create();

    assertCharEquals( '[]'
                    : toStringJsonArray( arrayList )
                    );

 end-proc;

 dcl-proc toStringJsonArray_oneElement;

    arrayList = arraylist_create();
    arraylist_addString( arrayList : 'ABC' );

    assertCharEquals( '["ABC"]'
                    : toStringJsonArray( arrayList )
                    );

 end-proc;

 dcl-proc toStringJsonArray_twoElements;

    arrayList = arraylist_create();
    arraylist_addString( arrayList : 'ABC' );
    arraylist_addString( arrayList : '123' );

    assertCharEquals( '["ABC","123"]'
                    : toStringJsonArray( arrayList )
                    );

 end-proc;

 dcl-proc toStringJsonArray_doubleQuotes;

    arrayList = arraylist_create();
    arraylist_addString( arrayList : '"Quoted" Text' );

    assertCharEquals( '["\"Quoted\" Text"]'
                    : toStringJsonArray( arrayList )
                    );

 end-proc;

 dcl-proc toStringJsonArray_singleQuotes;

    arrayList = arraylist_create();
    arraylist_addString( arrayList : 'Everbrite''s' );

    assertCharEquals( '["Everbrite''s"]'
                    : toStringJsonArray( arrayList )
                    );

 end-proc;

 dcl-proc toStringJsonArray_paddedValues;

    arrayList = arraylist_create();
    arraylist_addString( arrayList : '0' );
    arraylist_addString( arrayList : ' 1 ' );
    arraylist_addString( arrayList : '  2  ' );

    assertCharEquals( '["0"," 1 ","  2  "]'
                    : toStringJsonArray( arrayList )
                    );

 end-proc;

 dcl-proc scanReverse_from25;

    assertNumericEquals( 22
                       : scanReverse( 'Gollumn does not like nasty hobbit bread, ' +
                                      'he wants fish and only fish'
                                    : ' ' : 25 )
                       );

 end-proc;

 dcl-proc scanReverse_from30;

    assertNumericEquals( 28
                       : scanReverse( 'Gollumn does not like nasty hobbit bread, ' +
                                      'he wants fishbecausefishisreallygood'
                                    : ' ' : 30 )
                       );

 end-proc;

 dcl-proc scanReverse_from25to0;

    assertNumericEquals( 0
                       : scanReverse( 'Gollumndoesnotlikebreadhewantsfishandonlyfish'
                                    : ' ' : 25 )
                       );

 end-proc;

 dcl-proc scanReverse_fromEndToStart;

    assertNumericEquals( 0
                       : scanReverse( 'Gollumndoesnotlikebreadhewantsfishandonlyfish'
                                    : ' ' )
                       );

 end-proc;

 dcl-proc scanReverse_fromEndTo56;

    assertNumericEquals( 56
                       : scanReverse( 'Why do Java programmers wear glasses, because they cant C#'
                                    : ' ' )
                       );

 end-proc;

 dcl-proc scanReverse_fromEndToComma;

    assertNumericEquals( 13
                       : scanReverse( 'Programming , is fun!'
                                    : ',' )
                       );

 end-proc;

 // TODO: Shelly: copy remaining _textutil_ tests from UTILS_TEST

 dcl-proc toYN_singleCap;

    assertCharEquals( 'Y'
                    : toYN( 'Y' )  );


 end-proc;

 dcl-proc removeAccents_nothing;

    assertCharEquals( ' this String is_FINE! '
                    : removeAccents( ' this String is_FINE! ' )
                    );

 end-proc;

 // the accented characters in the following sub-procedure are listed in EBCDIC sequence

 dcl-proc removeAccents_a;

    assertCharEquals( 'aaaaaaAAAAAA'
                    : removeAccents( '‚‰‡·„Â¬ƒ¿¡√≈' )
                    );

 end-proc;

 dcl-proc removeAccents_b;

    assertCharEquals( 'ss'
                    : removeAccents( 'ﬂ' )
                    );

 end-proc;

 dcl-proc removeAccents_c;

    assertCharEquals( 'cC'
                    : removeAccents( 'Á«' )
                    );

 end-proc;

 dcl-proc removeAccents_e;

    assertCharEquals( 'eeeeEEEE'
                    : removeAccents( 'ÈÍÎË… À»' )
                    );

 end-proc;

 dcl-proc removeAccents_i;

    assertCharEquals( 'iiiiIIII'
                    : removeAccents( 'ÌÓÔÏÕŒœÃ' )
                    );

 end-proc;

 dcl-proc removeAccents_n;

    assertCharEquals( 'nN'
                    : removeAccents( 'Ò—' )
                    );

 end-proc;

 dcl-proc removeAccents_o;

    assertCharEquals( 'oooooOOOOO'
                    : removeAccents( 'ÙˆÚÛı‘÷“”’' )
                    );

 end-proc;

 dcl-proc removeAccents_u;

    assertCharEquals( 'uuuuUUUU'
                    : removeAccents( '˚¸˘˙€‹Ÿ⁄' )
                    );

 end-proc;

 dcl-proc removeAccents_y;

    assertCharEquals( 'yYyY'
                    : removeAccents( '˝›ˇ' )
                    );

 end-proc;

 dcl-proc removeUnprintable_nothing;

    assertCharEquals( ' this String is_FINE! '
                    : removeUnprintable( ' this String is_FINE! ' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex0;

    assertCharEquals( ''
                    : removeUnprintable( x'000102030405060708090A0B0C0D0E0F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex1;

    assertCharEquals( ''
                    : removeUnprintable( x'101112131415161718191A1B1C1D1E1F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex2;

    assertCharEquals( x'20'
                    : removeUnprintable( x'202122232425262728292A2B2C2D2E2F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex3;

    assertCharEquals( ''
                    : removeUnprintable( x'303132333435363738393A3B3C3D3E3F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex4;

    assertCharEquals( ' ‚‰‡·„ÂÁÒ.<(+|'
                    : removeUnprintable( x'404142434445464748494A4B4C4D4E4F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex5;

    assertCharEquals( '&ÈÍÎËÌÓÔÏﬂ!$*);¨'
                    : removeUnprintable( x'505152535455565758595A5B5C5D5E5F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex6;

    assertCharEquals( '-/¬ƒ¿¡√≈«—,%_>?'
                    : removeUnprintable( x'606162636465666768696A6B6C6D6E6F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex7;

    assertCharEquals( '¯… À»ÕŒœÃ`:#@''="'
                    : removeUnprintable( x'707172737475767778797A7B7C7D7E7F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex8;

    assertCharEquals( 'ÿabcdefghi˝'
                    : removeUnprintable( x'808182838485868788898A8B8C8D8E8F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hex9;

    assertCharEquals( 'jklmnopqrÊ∆'
                    : removeUnprintable( x'909192939495969798999A9B9C9D9E9F' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hexA;

    assertCharEquals( '~stuvwxyz›'
                    : removeUnprintable( x'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hexB;

    assertCharEquals( '^£•[]'
                    : removeUnprintable( x'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hexC;

    assertCharEquals( '{ABCDEFGHIÙˆÚÛı'
                    : removeUnprintable( x'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hexD;

    assertCharEquals( '}JKLMNOPQR˚¸˘˙ˇ'
                    : removeUnprintable( x'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hexE;

    assertCharEquals( '\STUVWXYZ‘÷“”’'
                    : removeUnprintable( x'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF' )
                    );

 end-proc;

 dcl-proc removeUnprintable_hexF;

    assertCharEquals( '0123456789€‹Ÿ⁄' + x'FF'
                    : removeUnprintable( x'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF' )
                    );

 end-proc;

 dcl-proc parseDate_slashMdcy;

    assertDateEquals( d'2003-01-02' : parseDate( '1/2/2003' ) );

 end-proc;

 dcl-proc parseDate_slashMdy;

    assertDateEquals( d'2003-01-02' : parseDate( '1/2/03' ) );

 end-proc;

 dcl-proc parseDate_slashMd99;

    assertDateEquals( d'1999-01-02' : parseDate( '1/2/99' ) );

 end-proc;

 dcl-proc parseDate_dashMdcy;

    assertDateEquals( d'2003-01-02' : parseDate( '1-2-2003' ) );

 end-proc;

 dcl-proc parseDate_dashMdy;

    assertDateEquals( d'2003-01-02' : parseDate( '1-2-03' ) );

 end-proc;

 dcl-proc parseDate_dashMd99;

    assertDateEquals( d'1999-01-02' : parseDate( '1-2-99' ) );

 end-proc;

 dcl-proc parseDate_dotDmcy;

    assertDateEquals( d'2003-01-02' : parseDate( '2.1.2003' ) );

 end-proc;

 dcl-proc parseDate_slashMdcyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '1/2/2003T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_slashMdyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '1/2/3T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_slashMd99Time;

    assertDateEquals( d'1999-01-02' : parseDate( '1/2/99T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dashMdcyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '1-2-2003T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dashMdyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '1-2-3T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dashMd99Time;

    assertDateEquals( d'1999-01-02' : parseDate( '1-2-99T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dotDmcyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '2.1.2003T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_slash0Mdcy;

    assertDateEquals( d'2003-01-02' : parseDate( '01/02/2003' ) );

 end-proc;

 dcl-proc parseDate_slash0Mdy;

    assertDateEquals( d'2003-01-02' : parseDate( '01/02/03' ) );

 end-proc;

 dcl-proc parseDate_slash0Md99;

    assertDateEquals( d'1999-01-02' : parseDate( '01/02/99' ) );

 end-proc;

 dcl-proc parseDate_dash0Mdcy;

    assertDateEquals( d'2003-01-02' : parseDate( '01-02-2003' ) );

 end-proc;

 dcl-proc parseDate_dash0Mdy;

    assertDateEquals( d'2003-01-02' : parseDate( '01-02-03' ) );

 end-proc;

 dcl-proc parseDate_dash0Md99;

    assertDateEquals( d'1999-01-02' : parseDate( '01-02-99' ) );

 end-proc;

 dcl-proc parseDate_dot0Dmcy;

    assertDateEquals( d'2003-01-02' : parseDate( '02.01.2003' ) );

 end-proc;

 dcl-proc parseDate_slash0MdcyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '01/02/2003T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_slash0MdyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '01/02/03T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_slash0Md99Time;

    assertDateEquals( d'1999-01-02' : parseDate( '01/02/99T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dash0MdcyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '01-02-2003T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dash0MdyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '01-02-03T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dash0Md99Time;

    assertDateEquals( d'1999-01-02' : parseDate( '01-02-99T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dot0DmcyTime;

    assertDateEquals( d'2003-01-02' : parseDate( '02.01.2003T04:05:06' ) );

 end-proc;

 dcl-proc parseDate_dashIso;

    assertDateEquals( d'2003-01-02' : parseDate( '2003-01-02' ) );

 end-proc;

 dcl-proc parseDate_dashIsoTime;

    assertDateEquals( d'2003-01-02' : parseDate( '2003-01-02T04:05:06' ) );

 end-proc;

