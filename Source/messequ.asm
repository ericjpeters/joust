
        ORG     MESS
OUTCHR  RMB     3
OUTPHR  RMB     3
OUTBCD  RMB     3
OUTC35  RMB     3
OUTP35  RMB     3
OUTB35  RMB     3
TEXT    RMB     3
TEXT35  RMB     3
FONT5   RMB     2
ETEXT   RMB     3
ETEXT35 RMB     3


;**** EQUATES FOR MESSAGE CALLS ****

Message_ThyGameIsOver                           EQU     $00     ; 'THY GAME IS OVER'
Message_250                                     EQU     $01     ; '250'
Message_500                                     EQU     $02     ; '500'
Message_750                                     EQU     $03     ; '750'
Message_1000                                    EQU     $04     ; '1000'
Message_InitialTestsIndicate                    EQU     $05     ; 'INITIAL TESTS INDICATE'
Message_AllSystemsGo                            EQU     $06     ; 'ALL SYSTEMS GO'
Message_RamError                                EQU     $07     ; 'RAM ERROR '
Message_RomError                                EQU     $08     ; 'ROM ERROR '
Message_AllRomsOk                               EQU     $09     ; 'ALL ROMS OK'
Message_RamTestFollows                          EQU     $0A     ; 'RAM TEST FOLLOWS'
Message_PressAdvanceToExit                      EQU     $0B     ; 'PRESS ADVANCE TO EXIT'
Message_RamErrorsDetected                       EQU     $0C     ; ' RAM ERRORS DETECTED'
Message_No                                      EQU     $0D     ; 'NO'
Message_NoCmos                                  EQU     $0E     ; 'NO CMOS'
Message_CmosRamError                            EQU     $0F     ; 'CMOS RAM ERROR'
Message_FromDoorMustBeOpen                      EQU     $10     ; 'FRONT DOOR MUST BE OPEN'
Message_OrTableTopRaisedForTest                 EQU     $11     ; 'OR TABLE TOP RAISED FOR TEST'
Message_WriteProtectFailure                     EQU     $12     ; 'WRITE PROTECT FALIURE'
Message_ColorRamTest                            EQU     $13     ; 'COLOR RAM TEST'
Message_VerticalBarsIndicateError               EQU     $14     ; 'VERTICAL BARS INDICATE ERROR'
Message_SwitchTest                              EQU     $15     ; 'SWITCH TEST'
                                                                  
Messages_StartOfSwitchNames                     EQU     $16     ; INDICATES START OF SWITCH NAMES
                                                                  
Message_SwitchAutoUp                            EQU     $16     ; 'AUTO UP'
Message_SwitchAdvance                           EQU     $17     ; 'ADVANCE'
Message_SwitchRightCoin                         EQU     $18     ; 'RIGHT COIN SWITCH'
Message_SwitchHighScoreReset                    EQU     $19     ; 'HIGH SCORE RESET'
Message_SwitchLeftCoin                          EQU     $1A     ; 'LEFT COIN SWITCH'
Message_SwitchCenterCoin                        EQU     $1B     ; 'CENTER COIN SWITCH'
Message_SwitchSlam                              EQU     $1C     ; 'SLAM SWITCH'
Message_SwitchPlayer1Start                      EQU     $1D     ; 'ONE PLAYER START'
Message_SwitchPlayer2Start                      EQU     $1E     ; 'TWO PLAYER START'
Message_SwitchMoveLeft                          EQU     $1F     ; 'MOVE LEFT'
Message_SwitchMoveRight                         EQU     $20     ; 'MOVE RIGHT'
Message_SwitchFlap                              EQU     $21     ; 'FLAP'
                                                                  
Message_SoundLine                               EQU     $22     ; 'SOUND LINE'
Message_BookkeepingTotals                       EQU     $23     ; 'BOOKKEEPING TOTALS'
                                                                  
Messages_StartOfBookkeepingTotals               EQU     $24     ; START OF BOOKKEEPING MESSAGES
                                                                  
Message_BookkeepingLeftSlotCoins                EQU     $24     ; 'LEFT SLOT COINS'
Message_BookkeepingCenterSlotCoins              EQU     $25     ; 'CENTER SLOT COINS'
Message_BookkeepingRightSlotCoins               EQU     $26     ; 'RIGHT SLOT COINS'
Message_BookkeepingPaidCredits                  EQU     $27     ; 'PAID CREDITS'
Message_BookkeepingFreeMen                      EQU     $28     ; 'FREE MEN'
Message_BookkeepingTotalTimeInMinutes           EQU     $29     ; 'TOTAL TIME IN MINUTES'
Message_BookkeepingTotalMenPlayed               EQU     $2A     ; 'TOTAL MEN PLAYED'
Message_BookkeepingTotalSinglePlayer            EQU     $2B     ; 'TOTAL SINGLE PLAYER'
Message_BookkeepingTotalDualPlayer              EQU     $2C     ; 'TOTAL DUAL PLAYER'
Message_BookkeepingTotalCreditsPlayed           EQU     $2D     ; 'TOTAL CREDITS PLAYED'
Message_BookkeepingAverageTimePerCredit         EQU     $2E     ; 'AVERAGE TIME PER CREDIT'
                                                                  
Message_GameAdjustments                         EQU     $2F     ; 'GAME ADJUSTMENTS'
                                                                  
Messages_StartOfAdjustmentMessages              EQU     $30     ; START OF ADJUSTMENT MESSAGES
                                                                  
Message_AdjustmentsExtraManEvery                EQU     $30     ; 'EXTRA MAN EVERY'
Message_AdjustmentsMenFor1CreditGame            EQU     $31     ; 'MEN FOR 1 CREDIT GAME'
Message_AdjustmentsHighScoreToDateAllowed       EQU     $32     ; 'HIGH SCORE TO DATE ALLOWED'
Message_AdjustmentsPricingSelection             EQU     $33     ; 'PRICING SELECTION'
Message_AdjustmentsPricingLeftSlotUnits         EQU     $34     ; '    LEFT SLOT UNITS'
Message_AdjustmentsPricingCenterSlotUnits       EQU     $35     ; '    CENTER SLOT UNITS'
Message_AdjustmentsPricingRightSlotUnits        EQU     $36     ; '    RIGHT SLOT UNITS'
Message_AdjustmentsPricingUnitsPerCredit        EQU     $37     ; '    UNITS REQUIRED FOR CREDIT'
Message_AdjustmentsPricingUnitsPerBonus         EQU     $38     ; '    UNITS REQUIRED FOR BONUS CREDIT'
Message_AdjustmentsPricingMinimumCredits        EQU     $39     ; '    MINIMUM CREDITS FOR ANY CREDIT'
Message_AdjustmentsDifficultyOfPlay             EQU     $3A     ; 'DIFICULTY OF PLAY'
Message_AdjustmentsLettersForHighestScore       EQU     $3B     ; 'LETTERS FOR HIGHEST SCORE'
Message_AdjustmentsRestoreFactorySettings       EQU     $3C     ; 'RESTORE FACTORY SETTINGS'
Message_AdjustmentsClearBookkeepingTotals       EQU     $3D     ; 'CLEAR BOOKKEEPING TOTALS'
Message_AdjustmentsHighScoreTableReset          EQU     $3E     ; 'HIGH SCORE TABLE RESET'
Message_AdjustmentsAutoCycle                    EQU     $3F     ; 'AUTO CYCLE'
Message_AdjustmentsSetAttractMessage            EQU     $40     ; 'SET ATTRACT MODE MESSAGE'
Message_AdjustmentsSetHighestScoreName          EQU     $41     ; 'SET HIGHEST SCORE NAME'
Message_AdjustmentsUsePlayer1MoveToSelect       EQU     $42     ; 'USE 'PLAYER 1 MOVE' TO SELECT '
Message_AdjustmentsUsePlayer2MoveToChange       EQU     $43     ; 'USE 'PLAYER 2 MOVE' TO CHANGE THE VALUE'
Message_AdjustmentsYes                          EQU     $44     ; 'YES'
Message_AdjustmentsAdjustment                   EQU     $45     ; 'ADJUSTMENT'
Message_AdjustmentsLetter                       EQU     $46     ; 'LETTER'
Message_AdjustmentsUsePlayer1FlapToEnter        EQU     $47     ; 'USE 'PLAYER 1 FLAP' TO ENTER LETTER'

MSFAIL  EQU     $48     ;' FAILURE'
MSRFAC  EQU     $49     ;'FACTORY SETTINGS RESTORED'
MSOPEN  EQU     $4A     ;'BY OPENING FRONT DOOR OR TABLE TOP'
MSONOF  EQU     $4B     ;'AND TURNING GAME ON AND OFF'
MSCLRD  EQU     $4C     ;' CLEARED'
MSHSR   EQU     $4D     ;'HIGH SCORE TABLE RESET'
DLBUZ   EQU     $4E     ;'DAILY BUZZARDS'
JCHAMP  EQU     $4F     ;'JOUST CHAMPIONS'
MSCRED  EQU     $50     ;'CREDITS '
MSPCEN  EQU     $51     ;'USE 'PLAYER 1 MOVE' TO CENTER'
MSAENT  EQU     $52     ;'ENTER LINE BY USING ADVANCE'
MSW00   EQU     $53     ;'PREPARE TO JOUST...'
MSW01   EQU     $54     ;'BUZZARD BAIT!'
MSW02   EQU     $55     ;'TEAM WAVE'
MSW03   EQU     $56     ;'BONUS AWARDED FOR TEAM PLAY'
MSW04   EQU     $57     ;'OSTRICH CONFLICT - NO BONUS AWARDED'
MSW05   EQU     $58     ;'OSTRICH CO-OPERATION - EACH PLAYER 3000 POINTS'
MSW06   EQU     $59     ;'WAVE '
MSW07   EQU     $5A     ;'BEWARE OF THE "UNBEATABLE?" PTERODACTYL'
MSW08   EQU     $5B     ;'GLADIATOR WAVE'
MSW09   EQU     $5C     ;'3000 POINT BOUNTY'
MSW21   EQU     $5D     ;'FOR DISMOUNTING FIRST OSTRICH'
MSW22   EQU     $5E     ;'NO BOUNTY AWARDED'
MSNEW1  EQU     $5F     ;'THIS IS JOUST'
MSNEW2  EQU     $60     ;'DESIGNED BY WILLIAMS ELECTROINCS INC.'
MSNEW3  EQU     $61     ;'ALL RIGHTS RESERVED'
AM18    EQU     $62     ;'PRESS '
AM17    EQU     $63     ;'"SINGLE PLAY"'
MSGTH3  EQU     $64     ;'3000'
MSP1    EQU     $65     ;'PLAYER 1'
MSP2    EQU     $66     ;'PLAYER 2'
MSGOD   EQU     $67     ;'ENTER THY NAME MY LORD!'
MSPEON  EQU     $68     ;'ENTER YOUR INITIALS'
MSBZB   EQU     $69     ;'NICE JOUSTING!'
ONLY5M  EQU     $6A     ;'MAX. 5 ENTRIES PER PLAYER'
MSENT3  EQU     $6B     ;'USE -MOVE- TO SELECT LETTER    -FLAP- TO ENTER LETTER'
MSCOPY  EQU     $6C     ;'(C) 1982 WILLIAMS ELECTRONICS INC.'
MSGAMO  EQU     $6D     ;'GAME OVER'
MSFRPLY EQU     $6E     ;'  FREE PLAY'
AM0     EQU     $6F     ;'WELCOME TO JOUST'
AM1     EQU     $70     ;'TO SURVIVE A JOUST'
AM2     EQU     $71     ;'THE HIGHEST LANCE WINS'
AM3     EQU     $72     ;'IN A COLLISION'
AM4     EQU     $73     ;'PICK UP THE EGGS'
AM5     EQU     $74     ;'BEFORE THEY HATCH'
AM6     EQU     $75     ;'TO FLY,'
AM7     EQU     $76     ;'REPEATEDLY PRESS THE 'FLAP' BUTTON'
AM8     EQU     $77     ;'MEET THY ENEMIES'
AM9     EQU     $78     ;'BOUNDER (500)'
AM10    EQU     $79     ;'HUNTER (750)'
AM11    EQU     $7A     ;'SHADOW LORD (1500)'
AM12    EQU     $7B     ;' TO START'
AM13    EQU     $7C     ;'OR'
AM14    EQU     $7D     ;'INSERT ADDITIONAL COINS FOR'
AM15    EQU     $7E     ;'"DUAL PLAY"'
AM16    EQU     $7F     ;'READY FOR '

;* TIME TO GO BACKWARDS
; I'm not EXACTLY sure why these are "backwards" ($FF to $80 instead of continuing from $7F to $80-$FF)
; but I suspect it has to do with the high-bit being interpreted as a numerical negative.  maybe.

MSW16   EQU     $FF     ;'NO SURVIVAL POINTS AWARDED'  DON'T ASK
MSW15   EQU     $FE     ;'COLLECT 3000 SURVIVAL POINTS'
MSW14   EQU     $FD     ;'SURVIVAL WAVE'
MSW13   EQU     $FC     ;'EGG WAVE'
MSW12   EQU     $FB     ;'COLLECT 3000 BOUNTY'
MSW20   EQU     $FA     ;'LAVA TROLL'
MSW19   EQU     $F9     ;'HOME OF THE'
MSW18   EQU     $F8     ;',000 POINTS'
MSW17   EQU     $F7     ;'EXTRA MOUNT EVERY '
MSW11   EQU     $F6     ;'NO BOUNTY AWARDED'
MSW10   EQU     $F5     ;'FOR DISMOUNTING FIRST OSTRICH'