# Joust
A source code rewrite to the 1982 arcade game

Source code rewrite by SynaMax, started January 25th, 2024; complete ROM set rebuilt for the first time on January 29, 2024

****

Game Designer: John Newcomer

Main Programmer: Bill Pfutzenreuter

Other Programmers: Cary Kolker and Ken Lantz

Sound ROM (VSNDRM4) main programmers: John Kotlarik and Tim Murphy

****

The original source code for the game can be found at https://github.com/historicalsource/joust/

For the first time ever, the source code for the sound ROM is included with the game code.  The original sound ROM source can be found here: https://github.com/historicalsource/williams-soundroms/blob/main/VSNDRM4.SRC

****

<!-- vim-markdown-toc GFM -->

* [Important Milestones](#important-milestones)
* [Build Instructions](#build-instructions)
  	* [Game code](#game-code)
  	* [Sound ROM](#sound-rom)
  	* [Decoder ROMs 4 & 6](#decoder-roms-4--6)
* [Overview](#overview)
* [Rewriting the source code](#rewriting-the-source-code)
 	* [Local labels](#local-labels)
  * [Invalid symbols](#invalid-symbols)
  * [BSO Syntax](#bso-syntax)
  * [Common fixes](#common-fixes)
  * [Inconsistent label names](#inconsistent-label-names)
<!-- vim-markdown-toc -->

****


## Important milestones

* 06/24/2024 - I recently discovered that back in February, Macro Assembler {AS} version 1.42 Build 262 changed the way it handles 6809 instructions that use an empty first argument on indexed address expressions (i.e. using LDA  X instead of LDA  ,X). This syntax is used extensively throughout the codebase and now results in errors when trying to build the game. A new instruction specific to AS has been inserted in the MAKE.ASM file to fix this issue.
* 02/08/2024 - The first mod for Joust has been added!  Originally written in 2008 and found on [Coinoplove.com](http://coinoplove.com/romhack/romhack.htm), this is a pause mod that allows the player 1 button to act as a pause button during gameplay.  Thanks to braedel for bringing this cool hack to my attention.  To enable the mod, simply remove the semi-colon in front of the ```PauseMod EQU 1``` define in ```make.ASM```.
* 01/30/2024 - After MONTHS of trying to figure out how to get Tim Murphy's Walsh Function Sound Machine macros to work, I finally succeeded in producing the correct binary data that matches up with the sound ROM.  This is huge as this also applies to Sinistar's sound ROM as well.  In layman's terms, this means we can accurately rebuild the data for the "Pterodactyl Scream" and "Ostrich Skid" sound effects ***exactly*** as how it was done in 1982!  
* 01/29/2024 (Cont'd) - ROM 12 and Video Sound ROM 4 are complete!  The entire game is completely rebuildable now!
* 01/29/2024 - ROMs 1 through 11 ($0000-$EFFF) for Joust now match up perfectly!  All that remains is the sound rom and Test ROM ($F000).
* 01/27/2024 - The rewritten code now assembles up to address $5ED0 and matches up perfectly with the first six ROMs for the game.  This includes all the sprite images for every game object, the message display routines, font sprites, and all the strings.   The game program itself is up next and exists entirely in one file that's over 8000 lines of code.  This is going to take a while to rewrite.  It's going to be a bit of a challenge without any pre-existing equates listing but I have a disassembly of the    game to help out.
* 01/25/2024 - Starting rewriting Joust's code today.  Already got all the sprites to assemble with Macroassembler {AS}...that's almost the first four ROMs!

## Build Instructions

This source code was rewritten to target [Macro Assembler {AS}](http://john.ccac.rwth-aachen.de:8000/as/index.html).  

### Game code

To build Joust, place the ASL and P2BIN executables in the same directory with all the source files from the repository.

Then, open a command prompt and type in:

```sh
asl make.asm -o joust.p
```
Once the ```joust.p``` file is generated, we can use the ```BURN.BAT``` file to create the 12 separate ROM files that make up Joust.

Address|ROM #|MAME ROM set Filename
| --- | --- | --- |
0000-0FFF|ROM 1|joust_rom_1b_3006-13.e4
1000-1FFF|ROM 2|joust_rom_2b_3006-14.c4
2000-2FFF|ROM 3|joust_rom_3b_3006-15.a4
3000-3FFF|ROM 4|joust_rom_4b_3006-16.e5
4000-4FFF|ROM 5|joust_rom_5b_3006-17.c5
5000-5FFF|ROM 6|joust_rom_6b_3006-18.a5
6000-6FFF|ROM 7|joust_rom_7b_3006-19.e6
7000-7FFF|ROM 8|joust_rom_8b_3006-20.c6
8000-8FFF|ROM 9|joust_rom_9b_3006-21.a6
9000-CFFF| |(SPACE RESERVED FOR RAM)
D000-DFFF|ROM 10|joust_rom_10b_3006-22.a7
E000-EFFF|ROM 11|joust_rom_11b_3006-23.c7
F000-FFFF|ROM 12|joust_rom_12b_3006-24.e7

If it's not possible to use ```BURN.BAT```, this can be typed into a command prompt instead:

```sh
p2bin joust.p joust_rom_1b_3006-13.e4 -l 00 -r $0000-$0FFF
p2bin joust.p joust_rom_2b_3006-14.c4 -l 00 -r $1000-$1FFF
p2bin joust.p joust_rom_3b_3006-15.a4 -l 00 -r $2000-$2FFF
p2bin joust.p joust_rom_4b_3006-16.e5 -l 00 -r $3000-$3FFF
p2bin joust.p joust_rom_5b_3006-17.c5 -l 00 -r $4000-$4FFF
p2bin joust.p joust_rom_6b_3006-18.a5 -l 00 -r $5000-$5FFF
p2bin joust.p joust_rom_7b_3006-19.e6 -l 00 -r $6000-$6FFF
p2bin joust.p joust_rom_8b_3006-20.c6 -l 00 -r $7000-$7FFF
p2bin joust.p joust_rom_9b_3006-21.a6 -l 00 -r $8000-$8FFF
p2bin joust.p joust_rom_10b_3006-22.a7 -l 00 -r $D000-$DFFF
p2bin joust.p joust_rom_11b_3006-23.c7 -l 00 -r $E000-$EFFF
p2bin joust.p joust_rom_12b_3006-24.e7 -l 00 -r $F000-$FFFF
```

### Sound ROM

Building Video Sound Rom 4 (VSNDRM4) just requires two commands:

```sh
asl VSNDRM4.ASM -o vsndrm4.p
```
Then use P2BIN to generate the binary ROM file:

```sh
p2bin vsndrm4.p video_sound_rom_4_std_780.ic12 -l 00 -r $F000-$FFFF
```

### Decoder ROMs 4 & 6

This is probably a little bit overkill but I also included code that builds the required decoder ROMs needed for the game to run.  MAME will refuse to launch the game if these files are not included so I added a [new source file](decoder_roms.asm), even though it's fairly easy to find these files online.  Regardless, I added them for completeness sake.

## Overview

Following [Defender](https://github.com/mwenge/defender), [Robotron](https://github.com/mwenge/robotron), and [Sinistar](https://github.com/synamaxmusic/sinistar), Joust is the latest Williams Electronics arcade game to have its source code retargeted for a newer assembler.  Because Sinistar and Joust's codebases contain a lot of similarities, I am reusing Macroassembler {AS} as the new assembler to build this game.  It appears that the same Boston System Office (BSO) assembler used for Sinistar, was previously utilized for Joust as well.

Sinistar's codebase - while more complex and featuring way more source files - also came with ```EQU``` and ```SET``` files that were extremely helpful in mapping out all the symbols and their addresses.  We don't have this luxury with Joust's code unfortunately.  To get around this, a disassembly of the game was generated from MAME and used whenever I was stuck.

Fortunately, the code for the game is fairly straight-forward as it doesn't heavily rely on macros (unlike Sinistar) and required much less rewriting.  For example, Sinistar took a little over 3 months to figure out, while rewriting Joust took just 4 days (though a lot of that time during the Sinistar rewrite was attributed to figuring out how to change the old syntax and expressions over to the newer assembler).

I also chose not to rewrite the original three previous versions of Joust, even though they are included in the original codebase.  Maybe I'll get to them one day, but for now it's not as important as getting the final version of the game up and running.

## Rewriting the source code

Whenever possible, any changes to the code are marked by comments to the right that say ```;;Fixme was:``` followed by the original instructions.

```
    IF PNBR-* > 0			      ;;Fixme was: IFGT  PNBR-*
```

### Local labels

{AS}  has some quirks with local labels so I had to redo them.  For example, here's what local labels look like for the BSO assembler:

```
1$	lda	lol
	jmp	2$
2$	lda	lmao
```

This is what this code would look like rewritten for {AS}:

```
.1S	lda	lol
	jmp	.2S
.2S	lda	lmao
```

Not all local label changes have been marked with ```;;Fixme was:``` comments as it would be too many to add and can clutter up the code.

### Invalid symbols

There are several symbols in both Sinistar and Joust that use dollar signs.  ```$``` are reserved for hex numbers only in {AS} so these labels/symbols have been renamed, by replacing the ```$``` with an ```S```.  

### BSO Syntax

Thankfully, I found some [documentation](https://www.pagetable.com/docs/cbmasm/cy6502.txt) for another [missing BSO assembler](https://www.pagetable.com/?p=1538#fn:1) that explains some of the syntax and expressions used in the original source code.  Here are some important ones to point out:

```

        UNARY:  +       Identity
                -       Negation
                >       High byte
                <       Low byte
                !N      Logical one's complement

        BINARY: +       Addition
                -       Subtraction
                *       Multiplication
                /       Division.  Any remainder is discarded.
                !.      Logical AND
                !+      Logical OR
                !X      Logical Exclusive OR

     Expressions will be evaluated according to the following operator
     precedence, and from left to right when of equal precedence:


                1)  Unary +, unary -, !N, <, >
                2)  *, /, !., !+, !X
                3)  Binary +, binary -
```

```

          Pseudo-     Syntax                Condition tested
            op

          .IF       .IF logical expr      true 
          .IF       .IF expr              expr <> 0
          .IFE      .IFE expr             expr = 0
          .IFN      .IFN expr             expr <> 0
          .IFLT     .IFLT expr            expr < 0
          .IFGT     .IFGT expr            expr > 0
          .IFLE     .IFLE expr            expr <= 0
          .IFGE     .IFGE expr            expr >= 0
          .IFDEF    .IFDEF sym            sym is a defined symbol
          .IFNDEF   .IFNDEF sym           sym is an undefined symbol
          .IFB      .IFB <string>         string is blank
          .IFNB     .IFNB <string>        string is not blank
          .IFIDN    .IFIDN <str1>,<str2>  str1 and str2 are identical
                                          character strings
          .IFNIDN   .IFNIDN <str1>,<str2> str1 and str2 are not 
                                          identical
```
These conditional pseudo-ops get used a lot so having this guide was extremely important for getting macros to work with Macroassembler {AS}. 

Interestingly, there are a couple of new expressions that don't appear here that do show up in the codebase:

```
FCB  WAIT,!HCALL,!WCALL,MINUS-*,ZERO-*,PLUS-*,FLYVEL
```

```!H``` was used for separating the high byte of a word, while ```!W``` is used for the lower byte of a word.  The first one does show up occasionally in Sinistar's codebase but ```!W``` is a new one that I haven't encountered before.

### Common fixes

* Exclusive OR ```!X``` are now just ```!```.
* Bit shift operators ```!<``` and ```!>``` are now ```<<``` and ```>>```.
* ```#!N4``` is a value used a lot for fixing a DMA bug for the blitter graphic chip.  This value has been replaced with ```#~$4```.
* Binary AND ```!.``` are now just ```&```
* Binary OR ```!+``` are now ```|```
* ```*``` asterisks were used to denote comments at the start of a new line.  These have now have semi-colons in front of them (```;*``` ) to tell the assembler this is a comment.  ```*``` is now exclusively used as the current value of the program counter.

### Inconsistent label names

Sinistar's codebase contains a plethora of inconsistent label names thanks to the small symbol table size of the BSO assembler.  Fortunately, there is only one occurrence of this issue, where ```TBRIDGE``` was truncated to ```TBRIDG```.  The original define in JOUSTRV4.ASM now reflects the full name.

# Eric's Notes:

## Build Everything:

### Compile
* asl make.asm -o joust.p
* asl decoder_roms.asm -o decoder.p
* asl VSNDRM4.ASM -o vsndrm4.p*

### Convert to ROM files.
* p2bin joust.p joust_rom_1b_3006-13.e4 -l 00 -r $0000-$0FFF
* p2bin joust.p joust_rom_2b_3006-14.c4 -l 00 -r $1000-$1FFF
* p2bin joust.p joust_rom_3b_3006-15.a4 -l 00 -r $2000-$2FFF
* p2bin joust.p joust_rom_4b_3006-16.e5 -l 00 -r $3000-$3FFF
* p2bin joust.p joust_rom_5b_3006-17.c5 -l 00 -r $4000-$4FFF
* p2bin joust.p joust_rom_6b_3006-18.a5 -l 00 -r $5000-$5FFF
* p2bin joust.p joust_rom_7b_3006-19.e6 -l 00 -r $6000-$6FFF
* p2bin joust.p joust_rom_8b_3006-20.c6 -l 00 -r $7000-$7FFF
* p2bin joust.p joust_rom_9b_3006-21.a6 -l 00 -r $8000-$8FFF
* p2bin joust.p joust_rom_10b_3006-22.a7 -l 00 -r $D000-$DFFF
* p2bin joust.p joust_rom_11b_3006-23.c7 -l 00 -r $E000-$EFFF
* p2bin joust.p joust_rom_12b_3006-24.e7 -l 00 -r $F000-$FFFF
* p2bin decoder.p decoder_rom_4.3g -r $0000-$01FF
* p2bin decoder.p decoder_rom_6.3c -r $0200-$03FF
* p2bin vsndrm4.p video_sound_rom_4_std_780.ic12 -l 00 -r $F000-$FFFF

## Hardware info:

## 6809

* A accumulator register is 8-bits
* B accumulator register is 8-bits
* D accumulator register is (A << 8) | B -- 16 bits
* CC is the condition code register:
    * E = Entire Flag -> Regular/Fast Interrupt flag (Entire registers pushed)
    * F = FIRQ Mask	-> Fast Interrupt mask (1=Fast interrupts disabled)
    * H = Half Carry -> Bit 3/4 carry for BCD
    * I = IRQ Mask -> 1 = interrupts disabled.
    * N = Negative -> 1 = negative
    * Z = Zero -> 1 = true
    * V = oVerflow -> 1= overflow
    * C = Carry -> 1 = Add one, or Subtract one with ADC/SBC
* X is a 16 bit indirect register
* Y is a 16 bit indirect register
* U is a 16 bit user stack (pointer?)
* S is a 16 bit stack (pointer?)
* PC is a 16 bit "program counter" (pointer?)
* DP is a 8 bit page pointer to the relocatable "zero page" or "direct page"
* CPU is Big-Endian.  For 16-bit value $0123 stored at $1000, we get:
    * $1000: $01
    * $1001: $23

### DECODER MEMORY MAP (CPU 6809 RADIX 16)
* $0000-$01FF -- decoder_roms.asm (Decoder ROM 4)
* $0200-$03FF -- decoder_roms.asm (Decoder ROM 6)

### GAME MEMORY MAP (CPU 6809)
* Source Files:
    * INCLUDE JOUSTI.ASM      ;;Sprite Images
    * INCLUDE TB12REV3.ASM    ;;CMOS and High score routines
    * INCLUDE RAMDEF.ASM  
    * INCLUDE EQU.ASM     
    * INCLUDE MESSEQU.ASM 
    * INCLUDE MESSEQU2.ASM
    * INCLUDE MESSAGE.ASM     ;;Message display routines and phrase strings
    * INCLUDE PHRASE.ASM
    * INCLUDE ATT.ASM         ;;Ken Lantz's attract screen
    * INCLUDE SYSTEM.ASM
    * INCLUDE JOUSTRV4.ASM    ;;Game program (version 4 - final release)
    * INCLUDE T12REV3.ASM     ;;Test Rom
    * INCLUDE joust_mods.asm

* Memory Map:
    * $0000-$0FFF
        * $0000-$0001: Pointer to _CLIF1L ($003C -- Cliff 1 Left)
        * $0002-$0003: Pointer to _CLIF1R ($00E1 -- Cliff 1 Right)
        * $0004-$0005: Pointer to _CLIF2 ($01DF -- Cliff 2)
        * $0006-$0007: Pointer to _CLIF3U
        * $0008-$0009: Pointer to _CLIF3L
        * $000A-$000B: Pointer to _CLIF3R
        * $000C-$000D: Pointer to _CLIF4
        * $000E-$000F: Pointer to _CLIF5 -- BOTTOM CLIFF
        * $0010-$0011: Pointer to _TRANS1 -- TRANSPORTER #1
        * $0012-$0013: Pointer to _TRANS2 -- TRANSPORTER #2
        * $0014-$0015: Pointer to _TRANS3 -- TRANSPORTER #3
        * $0016-$0017: Pointer to _TRANS4 -- TRANSPORTER #4
        * $0018-$0019: Pointer to _OSTRICH
        * $001A-$001B: Pointer to _BUZARD
        * $001C-$001D: Pointer to _STORK -- TOP AREA BIRD
        * $001E-$001F: Pointer to _PLYR1 -- THE LEFT & RIGH PLAYER #1 IMAGE
        * $0020-$0021: Pointer to _PLYR2 -- THE LEFT & RIGH PLAYER #2 IMAGE
        * $0022-$0023: Pointer to _PLYR3 -- THE LEFT & RIGH PLAYER #3 IMAGE
        * $0024-$0025: Pointer to _PLYR4 -- THE LEFT & RIGH PLAYER #4 IMAGE
        * $0026-$0027: Pointer to _PLYR5 -- THE LEFT & RIGH PLAYER #5 IMAGE
        * $0028-$0029: Pointer to _EGGI -- EGG STILLS & HATCHING
        * $002A-$002B: Pointer to _ILAVAT -- LAVA TROLL HANDS
        * $002C-$002D: Pointer to _IFLAME -- LAVA FLAMES
        * $002E-$002F: Pointer to _POOF1 -- PLAYER POOF DEATH
        * $0030-$0031: Pointer to _POOF2 -- PLAYER POOF DEATH
        * $0032-$0033: Pointer to _POOF3 -- PLAYER POOF DEATH
        * $0034-$0035: Pointer to _IPTERO -- PTERODACTYL LEFT/RIGHT 3 FRAME ANAIMATION
        * $0036-$0037: Pointer to _COMCL5 -- THE COMPACTED CLIFF5
        * $0038-$0039: Pointer to _ASH1R -- A DISOULVING PTERODACTYL
        * $003A-$003B: Pointer to _ASH1L -- A DISOULVING PTERODACTYL
        * $003C-$0049: _CLIF1L
        * $004A-$00C0: CSRC1L -- The raster data for Cliff 1 Left (17x7)
        * $00C1-$00E0: CCLF1L
        * $00E1-$00EE: _CLIF1R
        * $00EF-$0196: CSRC1L -- The raster data for Cliff 1 Right (24x7)
        * $0197-$019A: CCLF1R
        * $019B-$01B6: CREEN
        * $01B7-$01DE: 'JOUST (C) 1982 WILLIAMS ELECTRONICS INC.'
        * $01DF-$01EC: _CLIF2
        * $01ED-$0378: CSRC2
        * $0379-$03A0: CCLF2
        * $03A1-$03AE: _CLIF3L
        * $03AF-$04AE: CSRC3L
        * $04AF- +36 bytes : CCLF3L
        * +14 bytes : _CLIF3U
        * +((15+14)*11) bytes : CSRC3U 
        * +14 bytes : _CLIF3R
        * +(12*2*7) bytes : CSRC3R
        * +(4*17) bytes : CCLF3R
        * +14 bytes : _CLIF4
        * +(16*16) bytes : CSRC4
        * +(9*4) bytes : CCLF4
        * +(13*2) bytes : _CLIF5 
        * +(8*13) bytes : CSRC5R
        * +(8*14) bytes : CSRC5L
        * +((13*6*2) + (15*2)) bytes : CSRC5
        * +(4*20) bytes : CCLF5
        * +(1 + (6 * (681-536)) bytes : _COMCL5
        * +(14*3) bytes : TRASRC
        * +8 bytes : _TRANS1
        * +8 bytes : _TRANS2
        * +8 bytes : _TRANS3
        * +8 bytes : _TRANS4 
        * +0 bytes : _OSTRICH EQU *
        * +12bytes : ORSKID
        * +12bytes : ORSTND
        * +12bytes : ORRUN1
        * +12bytes : ORRUN2
        * +12bytes : ORRUN3
        * +12bytes : ORRUN4
        * +12bytes : ORFLAP
        * +12bytes : ORFLOP
        * +12bytes : ORFLIP
        * + (6 * 18) bytes : _STORK
        * +0 bytes : CWNG1R EQU *
        * +0 bytes : CWNG2R EQU *
        * + (4 * 15) bytes : CWNG3R
        * +0 bytes : CWNG1L EQU *
        * +0 bytes : CWNG2L EQU *
        * +(4 * 15) bytes : CWNG3L
        * +(21 * 4) bytes : CSKIDR
        * +(21 * 4) bytes : CSTN1R
        * +40 bytes : 'JOUST (C) 1982 WILLIAMS ELECTRONICS INC.'
        * +(21 * 4) bytes : CSTN2R
        * +(21 * 4) bytes : CSTN3R
        * +(21 * 4) bytes : CSTN4R
        * +(21 * 4) bytes : CSKIDL
        * +(21 * 4) bytes : CSTN1L
        * +(21 * 4) bytes : CSTN2L
        * +(21 * 4) bytes : CSTN3L
        * +(21 * 4) bytes : CSTN4L
        * +((20 * 9) + 2) bytes: SRUN1R
        * +((20 * 9) + 2) bytes: SRUN2R
        * +((20 * 9) + 2) bytes: SRUN3R
        * +((20 * 9) + 2) bytes: SRUN4R
        * +((19 * 8) + 2) bytes: SRUNSR
        * +((14 * 9) + 2) bytes: SFLY1R
        * +((13 * 9) + 2) bytes: SFLY3R
        * +((20 * 9) + 2) bytes: SRUN1L
        * +((20 * 8) + 2) bytes: SRUN2L
        * +((20 * 8) + 2) bytes: SRUN3L
        * +((20 * 8) + 2) bytes: SRUN4L
        * +((19 * 7) + 2) bytes: SRUNSL
        * +((14 * 8) + 2) bytes: SFLY1L
        * +((13 * 9) + 2) bytes: SFLY3L
        * +((20 * 8) + 2) bytes: ORUN1R 
        * +((20 * 8) + 2) bytes: ORUN2R
        * +((20 * 8) + 2) bytes: ORUN3R
        * +((20 * 8) + 2) bytes: ORUN4R 
        * +((18 * 8) + 2) bytes: ORUNSR
        * +((13 * 9) + 2) bytes: OFLY1R
        * +40 bytes : 'JOUST (C) 1982 WILLIAMS ELECTRONICS INC.'
        * +((13 * 9) + 2) bytes: OFLY3R
        * +((20 * 8) + 2) bytes: ORUN1L
        * +((20 * 7) + 2) bytes: ORUN2L
        * +((20 * 7) + 2) bytes: ORUN3L
        * +((20 * 8) + 2) bytes: ORUN4L
        * +((18 * 8) + 2) bytes: ORUNSL
        * +((13 * 8) + 2) bytes: OFLY1L
        * +((13 * 9) + 2) bytes: OFLY3L
        * +0 bytes _BUZARD EQU     *
        * +12 bytes: BRSKID
        * +12 bytes: BRSTND
        * +12 bytes: BRRUN1
        * +12 bytes: BRRUN2
        * +12 bytes: BRRUN3
        * +12 bytes: BRRUN4
        * +12 bytes: BRFLAP
        * +12 bytes: BRFLOP
        * +12 bytes: BRFLIP

BWNG1R
BWNG2R
BWNG3R  FDB     7+COFF,9+COFF
        FDB     7+COFF,9+COFF
        FDB     7+COFF,8+COFF
        FDB     6+COFF,10+COFF
        FDB     6+COFF,17+COFF
        FDB     6+COFF,10+COFF
        FDB     5+COFF,11+COFF
        FDB     4+COFF,14+COFF
        FDB     3+COFF,14+COFF
        FDB     4+COFF,14+COFF
        FDB     5+COFF,13+COFF
        FDB     5+COFF,12+COFF
        FDB     5+COFF,13+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100     ;1 EXTRA END OF POINTER ENTRY
;*
BWNG1L
BWNG2L
BWNG3L  FDB     10+COFF,12+COFF
        FDB     10+COFF,12+COFF
        FDB     11+COFF,12+COFF
        FDB     9+COFF,13+COFF
        FDB     2+COFF,13+COFF
        FDB     9+COFF,13+COFF
        FDB     8+COFF,14+COFF
        FDB     5+COFF,15+COFF
        FDB     5+COFF,16+COFF
        FDB     5+COFF,15+COFF
        FDB     6+COFF,14+COFF
        FDB     7+COFF,14+COFF
        FDB     6+COFF,14+COFF
        FDB     $8100,$8100     ;1 EXTRA END OF POINTER ENTRY
;*
BSKIDR  FDB     $8000,$8000     ;NO COLISION ON THIS LINE
        FDB     $8000,$8000     ;NO COLISION ON THIS LINE
        FDB     7+COFF,9+COFF
        FDB     7+COFF,9+COFF
        FDB     7+COFF,8+COFF
        FDB     6+COFF,10+COFF
        FDB     6+COFF,10+COFF
        FDB     6+COFF,10+COFF
        FDB     6+COFF,11+COFF
        FDB     5+COFF,11+COFF
        FDB     5+COFF,11+COFF
        FDB     3+COFF,11+COFF
        FDB     3+COFF,11+COFF
        FDB     3+COFF,11+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100     ;1 EXTRA END OF POINTER ENTRY
;*
BSTNDR  FDB     7+COFF,9+COFF
        FDB     7+COFF,9+COFF
        FDB     7+COFF,8+COFF
        FDB     6+COFF,10+COFF
        FDB     6+COFF,17+COFF
        FDB     7+COFF,10+COFF
        FDB     6+COFF,14+COFF
        FDB     5+COFF,14+COFF
        FDB     4+COFF,14+COFF
        FDB     3+COFF,14+COFF
        FDB     3+COFF,14+COFF
        FDB     2+COFF,14+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100     ;1 EXTRA END OF POINTER ENTRY
;*
BSKIDL  FDB     $8000,$8000     ;NO COLISION ON THIS LINE
        FDB     $8000,$8000     ;NO COLISION ON THIS LINE
        FDB     10+COFF,12+COFF
        FDB     10+COFF,12+COFF
        FDB     11+COFF,12+COFF
        FDB     9+COFF,13+COFF
        FDB     9+COFF,13+COFF
        FDB     9+COFF,13+COFF
        FDB     8+COFF,13+COFF
        FDB     8+COFF,14+COFF
        FDB     8+COFF,14+COFF
        FDB     8+COFF,16+COFF
        FDB     8+COFF,16+COFF
        FDB     8+COFF,16+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100     ;1 EXTRA END OF POINTER ENTRY
;*
BSTNDL  FDB     10+COFF,12+COFF
        FDB     10+COFF,12+COFF
        FDB     11+COFF,12+COFF
        FDB     9+COFF,13+COFF
        FDB     2+COFF,13+COFF
        FDB     9+COFF,12+COFF
        FDB     5+COFF,13+COFF
        FDB     5+COFF,14+COFF
        FDB     5+COFF,15+COFF
        FDB     5+COFF,16+COFF
        FDB     5+COFF,16+COFF
        FDB     5+COFF,17+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100     ;1 EXTRA END OF POINTER ENTRY
;*
;*      VULTURE IMAGES
;*               (RIGHT)
;*
;*      BUZZARD RIGHT FACED IMAGES
;*
;*AAFF0A0E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN1R  FDB     $090E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$B6,$60,$00,$0F,$F8,$00
        FCB     $00,$00,$06,$33,$31,$D0,$0F,$55,$50
        FCB     $00,$00,$6B,$33,$3B,$1B,$0E,$F0,$50
        FCB     $00,$0B,$0B,$BD,$B1,$1D,$08,$F0,$00
        FCB     $00,$B0,$BB,$32,$BB,$1F,$FF,$80,$00
        FCB     $0B,$6B,$B3,$33,$BD,$D8,$F8,$00,$00
        FCB     $00,$0B,$3B,$BB,$88,$00,$00,$00,$00
        FCB     $00,$BB,$00,$0F,$F0,$00,$00,$00,$00
        FCB     $00,$00,$00,$8F,$FF,$00,$00,$00,$00
        FCB     $00,$00,$00,$F8,$08,$80,$00,$00,$00
        FCB     $00,$00,$00,$F0,$00,$F0,$00,$00,$00
        FCB     $00,$00,$00,$F8,$00,$F0,$00,$00,$00
        FCB     $00,$00,$00,$8F,$80,$00,$00,$00,$00
        FCB     $00,$00,$00,$0E,$FF,$E0,$00,$00,$00
;*AAFF090E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN2R  FDB     $090E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$0B,$36,$60,$00,$FF,$80,$00
        FCB     $00,$00,$6B,$33,$31,$DE,$F5,$55,$00
        FCB     $00,$06,$B3,$33,$BB,$DE,$EF,$05,$00
        FCB     $00,$6B,$0B,$3D,$B1,$18,$8F,$00,$00
        FCB     $00,$B0,$B3,$32,$3B,$FF,$FF,$00,$00
        FCB     $03,$6B,$B3,$33,$BD,$8F,$FE,$00,$00
        FCB     $00,$0B,$B3,$8B,$88,$00,$00,$00,$00
        FCB     $00,$3B,$3B,$8F,$F0,$00,$00,$00,$00
        FCB     $00,$BB,$00,$FF,$F0,$00,$00,$00,$00
        FCB     $00,$00,$0F,$F0,$FF,$FF,$80,$00,$00
        FCB     $00,$00,$0F,$00,$00,$0F,$F8,$00,$00
        FCB     $00,$00,$0F,$80,$00,$80,$0F,$00,$00
        FCB     $00,$00,$00,$F8,$00,$00,$00,$00,$00
        FCB     $00,$00,$00,$EF,$FE,$00,$00,$00,$00
;*AAFF090E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN3R  FDB     $090E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$0B,$36,$60,$00,$FF,$80,$00
        FCB     $00,$00,$63,$33,$B1,$DE,$F5,$55,$00
        FCB     $00,$06,$BB,$33,$3D,$DE,$EF,$05,$00
        FCB     $00,$6B,$03,$3D,$B1,$18,$8F,$00,$00
        FCB     $00,$B0,$BB,$23,$BC,$FF,$FF,$00,$00
        FCB     $03,$BB,$B3,$3B,$BD,$8F,$FE,$00,$00
        FCB     $00,$0B,$33,$8B,$88,$00,$00,$00,$00
        FCB     $00,$3B,$3B,$88,$F8,$00,$00,$00,$00
        FCB     $00,$BB,$0F,$FE,$FF,$E0,$00,$00,$00
        FCB     $00,$00,$8F,$E0,$0F,$F0,$00,$00,$00
        FCB     $00,$00,$FE,$00,$00,$8F,$00,$00,$00
        FCB     $00,$00,$FE,$00,$00,$08,$F0,$00,$00
        FCB     $00,$00,$8F,$80,$00,$0E,$FF,$00,$00
        FCB     $00,$00,$EF,$F8,$00,$08,$08,$F0,$00
;*AAFF0A0E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN4R  FDB     $090E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$0B,$36,$60,$00,$0F,$F8,$00
        FCB     $00,$00,$63,$33,$31,$D0,$0F,$55,$50
        FCB     $00,$06,$B3,$33,$3B,$1C,$0E,$F0,$50
        FCB     $00,$6B,$03,$3D,$B1,$1F,$08,$F0,$00
        FCB     $00,$B0,$BB,$32,$BB,$1F,$FF,$80,$00
        FCB     $03,$BB,$BB,$3B,$BD,$D8,$F8,$00,$00
        FCB     $00,$0B,$33,$8E,$88,$00,$00,$00,$00
        FCB     $03,$3B,$EF,$88,$FE,$00,$00,$00,$00
        FCB     $0B,$BE,$F8,$EF,$80,$00,$00,$00,$00
        FCB     $00,$0F,$80,$0F,$E0,$00,$00,$00,$00
        FCB     $00,$00,$F0,$08,$F0,$00,$00,$00,$00
        FCB     $00,$00,$FF,$00,$0F,$00,$00,$00,$00
        FCB     $00,$0F,$00,$F0,$EF,$FE,$00,$00,$00
        FCB     $00,$00,$00,$00,$80,$FF,$00,$00,$00
;*AAFF090D78B4FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUNSR  FDB     $090D!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$0B,$22,$36,$00,$0F,$F8,$00,$00
        FCB     $00,$32,$33,$BB,$B0,$0F,$55,$50,$00
        FCB     $00,$B0,$30,$66,$6B,$08,$F0,$50,$00
        FCB     $00,$00,$0B,$66,$31,$D0,$88,$00,$00
        FCB     $00,$BB,$BB,$B3,$3B,$1E,$8F,$00,$00
        FCB     $03,$30,$BB,$BD,$31,$1F,$F8,$00,$00
        FCB     $06,$3B,$B3,$32,$BD,$D8,$E0,$00,$00
        FCB     $00,$00,$63,$38,$8D,$80,$00,$00,$00
        FCB     $00,$00,$00,$E8,$FF,$E8,$00,$00,$00
        FCB     $00,$00,$00,$00,$E8,$FE,$80,$00,$00
        FCB     $00,$00,$00,$00,$00,$F8,$E8,$00,$00
        FCB     $00,$00,$00,$00,$00,$0F,$8E,$80,$00
        FCB     $00,$00,$00,$00,$00,$E8,$EF,$E8,$00
;*AAFF0A0878B5FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BFLY1R  FDB     $0908!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$06,$B3,$6B,$60,$00,$00,$00
        FCB     $00,$00,$62,$63,$36,$B6,$8F,$80,$00
        FCB     $00,$0B,$32,$36,$6B,$B6,$8F,$55,$00
        FCB     $00,$63,$3B,$3B,$BB,$B3,$88,$05,$00
        FCB     $00,$33,$33,$B6,$B3,$BB,$36,$00,$00
        FCB     $03,$3B,$0B,$0B,$30,$33,$B3,$B0,$00
        FCB     $00,$6B,$EE,$E0,$B3,$03,$30,$33,$00
        FCB     $00,$00,$E8,$8E,$0B,$30,$23,$02,$30
;*AAFF0A0D78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BFLY3R  FDB     $090D!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $03,$03,$B0,$00,$00,$00,$00,$00,$00
        FCB     $03,$20,$3B,$00,$00,$00,$00,$00,$00
        FCB     $0B,$33,$BB,$00,$00,$00,$00,$00,$00
        FCB     $02,$03,$3B,$B0,$00,$00,$00,$00,$00
        FCB     $0B,$30,$BB,$66,$00,$00,$00,$00,$00
        FCB     $03,$B3,$3B,$B6,$BE,$00,$00,$00,$00
        FCB     $00,$2B,$33,$B6,$6B,$BE,$00,$00,$00
        FCB     $00,$03,$3B,$BB,$BB,$DB,$E8,$F8,$00
        FCB     $00,$00,$63,$3B,$BB,$BD,$88,$F5,$50
        FCB     $00,$0B,$06,$36,$B0,$11,$FF,$E0,$50
        FCB     $03,$B3,$B0,$EE,$BB,$0D,$8E,$00,$00
        FCB     $0B,$B6,$E8,$8E,$EE,$8E,$00,$00,$00
        FCB     $00,$60,$E8,$EE,$0E,$00,$80,$00,$00
;*
;*               (LEFT)
;*
;*AAFF0A0E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN1L  FDB     $090E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$8F,$F0,$00,$06,$6B,$00,$00,$00
        FCB     $05,$55,$F0,$0D,$13,$33,$60,$00,$00
        FCB     $05,$0F,$E0,$B1,$B3,$33,$B6,$00,$00
        FCB     $00,$0F,$80,$D1,$1B,$DB,$B0,$B0,$00
        FCB     $00,$08,$FF,$F1,$BB,$23,$BB,$0B,$00
        FCB     $00,$00,$8F,$8D,$DB,$33,$3B,$B6,$B0
        FCB     $00,$00,$00,$00,$88,$BB,$B3,$B0,$00
        FCB     $00,$00,$00,$00,$0F,$F0,$00,$BB,$00
        FCB     $00,$00,$00,$00,$FF,$F8,$00,$00,$00
        FCB     $00,$00,$00,$08,$80,$8F,$00,$00,$00
        FCB     $00,$00,$00,$0F,$00,$0F,$00,$00,$00
        FCB     $00,$00,$00,$0F,$00,$8F,$00,$00,$00
        FCB     $00,$00,$00,$00,$08,$F8,$00,$00,$00
        FCB     $00,$00,$00,$0E,$FF,$E0,$00,$00,$00
;*AAFF090E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN2L  FDB     $080E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $08,$FF,$00,$06,$63,$B0,$00,$00
        FCB     $55,$5F,$ED,$13,$33,$B6,$00,$00
        FCB     $50,$FE,$ED,$BB,$33,$3B,$60,$00
        FCB     $00,$F8,$81,$1B,$D3,$B0,$B6,$00
        FCB     $00,$FF,$FF,$B3,$23,$3B,$0B,$00
        FCB     $00,$EF,$F8,$DB,$33,$3B,$B6,$30
        FCB     $00,$00,$00,$88,$B8,$3B,$B0,$00
        FCB     $00,$00,$00,$0F,$F8,$B3,$B3,$00
        FCB     $00,$00,$00,$0F,$FF,$00,$BB,$00
        FCB     $00,$08,$FF,$FF,$0F,$F0,$00,$00
        FCB     $00,$8F,$F0,$00,$00,$F0,$00,$00
        FCB     $00,$F0,$08,$00,$08,$F0,$00,$00
        FCB     $00,$00,$00,$00,$8F,$00,$00,$00
        FCB     $00,$00,$00,$EF,$FE,$00,$00,$00
;*AAFF090E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN3L  FDB     $080E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $08,$FF,$00,$06,$63,$B0,$00,$00
        FCB     $55,$5F,$ED,$1B,$33,$36,$00,$00
        FCB     $50,$FE,$ED,$D3,$33,$BB,$60,$00
        FCB     $00,$F8,$81,$1B,$D3,$30,$B6,$00
        FCB     $00,$FF,$FF,$CB,$32,$BB,$0B,$00
        FCB     $00,$EF,$F8,$DB,$B3,$3B,$BB,$30
        FCB     $00,$00,$00,$88,$B8,$33,$B0,$00
        FCB     $00,$00,$00,$8F,$88,$B3,$B3,$00
        FCB     $00,$00,$0E,$FF,$EF,$F0,$BB,$00
        FCB     $00,$00,$0F,$F0,$0E,$F8,$00,$00
        FCB     $00,$00,$F8,$00,$00,$EF,$00,$00
        FCB     $00,$0F,$80,$00,$00,$EF,$00,$00
        FCB     $00,$FF,$E0,$00,$08,$F8,$00,$00
        FCB     $0F,$80,$80,$00,$8F,$FE,$00,$00
;*AAFF0A0E78B6FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUN4L  FDB     $090E!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$8F,$F0,$00,$06,$63,$B0,$00,$00
        FCB     $05,$55,$F0,$0D,$13,$33,$36,$00,$00
        FCB     $05,$0F,$E0,$C1,$B3,$33,$3B,$60,$00
        FCB     $00,$0F,$80,$F1,$1B,$D3,$30,$B6,$00
        FCB     $00,$08,$FF,$F1,$BB,$23,$BB,$0B,$00
        FCB     $00,$00,$8F,$8D,$DB,$B3,$BB,$BB,$30
        FCB     $00,$00,$00,$00,$88,$E8,$33,$B0,$00
        FCB     $00,$00,$00,$00,$EF,$88,$FE,$B3,$30
        FCB     $00,$00,$00,$00,$08,$FE,$8F,$EB,$B0
        FCB     $00,$00,$00,$00,$0E,$F0,$08,$F0,$00
        FCB     $00,$00,$00,$00,$0F,$80,$0F,$00,$00
        FCB     $00,$00,$00,$00,$F0,$00,$FF,$00,$00
        FCB     $00,$00,$00,$EF,$FE,$0F,$00,$F0,$00
        FCB     $00,$00,$00,$FF,$08,$00,$00,$00,$00
;*AAFF090D78B4FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BRUNSL  FDB     $080D!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$8F,$F0,$00,$63,$22,$B0,$00
        FCB     $05,$55,$F0,$0B,$BB,$33,$23,$00
        FCB     $05,$0F,$80,$B6,$66,$03,$0B,$00
        FCB     $00,$88,$0D,$13,$66,$B0,$00,$00
        FCB     $00,$F8,$E1,$B3,$3B,$BB,$BB,$00
        FCB     $00,$8F,$F1,$13,$DB,$BB,$03,$30
        FCB     $00,$0E,$8D,$DB,$23,$3B,$B3,$60
        FCB     $00,$00,$08,$D8,$83,$36,$00,$00
        FCB     $00,$00,$8E,$FF,$8E,$00,$00,$00
        FCB     $00,$08,$EF,$8E,$00,$00,$00,$00
        FCB     $00,$8E,$8F,$00,$00,$00,$00,$00
        FCB     $08,$E8,$F0,$00,$00,$00,$00,$00
        FCB     $8E,$FE,$8E,$00,$00,$00,$00,$00
;*AAFF0A0878B5FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BFLY1L  FDB     $0908!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$06,$B6,$3B,$60,$00,$00
        FCB     $00,$08,$F8,$6B,$63,$36,$26,$00,$00
        FCB     $00,$55,$F8,$6B,$B6,$63,$23,$B0,$00
        FCB     $00,$50,$88,$3B,$BB,$B3,$B3,$36,$00
        FCB     $00,$00,$63,$BB,$3B,$6B,$33,$33,$00
        FCB     $00,$0B,$3B,$33,$03,$B0,$B0,$B3,$30
        FCB     $00,$33,$03,$30,$3B,$0E,$EE,$B6,$00
        FCB     $03,$20,$32,$03,$B0,$E8,$8E,$00,$00
;*AAFF0A0D78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E81490CD111FA40A67
BFLY3L  FDB     $090D!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$00,$00,$0B,$30,$30
        FCB     $00,$00,$00,$00,$00,$00,$B3,$02,$30
        FCB     $00,$00,$00,$00,$00,$00,$BB,$33,$B0
        FCB     $00,$00,$00,$00,$00,$0B,$B3,$30,$20
        FCB     $00,$00,$00,$00,$00,$66,$BB,$03,$B0
        FCB     $00,$00,$00,$00,$EB,$6B,$B3,$3B,$30
        FCB     $00,$00,$00,$EB,$B6,$6B,$33,$B2,$00
        FCB     $00,$8F,$8E,$BD,$BB,$BB,$B3,$30,$00
        FCB     $05,$5F,$88,$DB,$BB,$B3,$36,$00,$00
        FCB     $05,$0E,$FF,$11,$0B,$63,$60,$B0,$00
        FCB     $00,$00,$E8,$D0,$BB,$EE,$0B,$3B,$30
        FCB     $00,$00,$00,$E8,$EE,$E8,$8E,$6B,$B0
        FCB     $00,$00,$08,$00,$E0,$EE,$8E,$06,$00
;*
;*      PLAYER 1'S POINTERS
;*
_PLYR1  FDB     0,$02EF,PLY1R   ;RIDER ON SKIDDING HORSE
        FDB     0,$00EF,PLY1L
        FDB     0,$02ED,PLY1R   ;RIDER NORMALLY ON HORSE
        FDB     0,$00ED,PLY1L
;*
;*
;*      RIDER FACEING RIGHT SIDE
;*
PLY1R   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$55,$50,$00,$00,$00,$00
        FCB     $00,$57,$70,$00,$00,$00,$00
        FCB     $00,$55,$00,$00,$00,$00,$00
        FCB     $05,$55,$55,$00,$00,$00,$00
        FCB     $05,$55,$55,$75,$55,$55,$50
        FCB     $05,$55,$55,$00,$00,$00,$00
        FCB     $00,$55,$55,$50,$00,$00,$00
;*
;*      RIDER FACEING LEFT SIDE
;*
PLY1L   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$05,$55,$00
        FCB     $00,$00,$00,$00,$07,$75,$00
        FCB     $00,$00,$00,$00,$00,$55,$00
        FCB     $00,$00,$00,$00,$55,$55,$50
        FCB     $05,$55,$55,$57,$55,$55,$50
        FCB     $00,$00,$00,$00,$55,$55,$50
        FCB     $00,$00,$00,$05,$55,$55,$00
;*
;*      PLAYER 2'S POINTERS
;*
_PLYR2  FDB     0,$02EF,PLY2R   ;RIDER ON SKIDDING HORSE
        FDB     0,$00EF,PLY2L
        FDB     0,$02ED,PLY2R   ;RIDER NORMALLY ON HORSE
        FDB     0,$00ED,PLY2L
;*
;*      RIDER FACEING RIGHT
;*
PLY2R   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$77,$70,$00,$00,$00,$00
        FCB     $00,$75,$50,$00,$00,$00,$00
        FCB     $00,$77,$00,$00,$00,$00,$00
        FCB     $07,$77,$77,$00,$00,$00,$00
        FCB     $07,$77,$77,$57,$77,$77,$70
        FCB     $07,$77,$77,$00,$00,$00,$00
        FCB     $00,$77,$77,$70,$00,$00,$00
;*
;*      RIDER FACEING LEFT SIDE
;*
PLY2L   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$07,$77,$00
        FCB     $00,$00,$00,$00,$05,$57,$00
        FCB     $00,$00,$00,$00,$00,$77,$00
        FCB     $00,$00,$00,$00,$77,$77,$70
        FCB     $07,$77,$77,$75,$77,$77,$70
        FCB     $00,$00,$00,$00,$77,$77,$70
        FCB     $00,$00,$00,$07,$77,$77,$00
;*
;*
;*      PL7YER 3'S POINTERS
;*
_PLYR3  FDB     0,$02EF,PLY3R   ;RIDER ON SKIDDING HORSE
        FDB     0,$00EF,PLY3L
        FDB     0,$02ED,PLY3R   ;RIDER NORMALLY ON HORSE
        FDB     0,$00ED,PLY3L
        FDB     CEGGMN,$00F5,PLY3S
;*
;*      RIDER FACEING RIGHT SIDE
;*
PLY3R   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$44,$40,$00,$00,$00,$00
        FCB     $00,$49,$90,$00,$00,$00,$00
        FCB     $00,$44,$00,$00,$00,$00,$00
        FCB     $04,$44,$44,$00,$00,$00,$00
        FCB     $04,$41,$11,$11,$11,$11,$10
        FCB     $04,$44,$44,$00,$00,$00,$00
        FCB     $00,$44,$44,$40,$00,$00,$00
;*
;*      RIDER FACEING LEFT SIDE
;*
PLY3L   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$04,$44,$00
        FCB     $00,$00,$00,$00,$09,$94,$00
        FCB     $00,$00,$00,$00,$00,$44,$00
        FCB     $00,$00,$00,$00,$44,$44,$40
        FCB     $01,$11,$11,$11,$11,$14,$40
        FCB     $00,$00,$00,$00,$44,$44,$40
        FCB     $00,$00,$00,$04,$44,$44,$00
;*
;*      RIDER STANDING (LEFT & RIGHT)
;*
;*AAFF050C78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
PLY3S   FDB     $050C!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$01,$00
        FCB     $00,$E4,$4E,$01,$00
        FCB     $00,$49,$9E,$01,$00
        FCB     $00,$E4,$4E,$01,$00
        FCB     $04,$44,$40,$4D,$00
        FCB     $4E,$E4,$40,$44,$00
        FCB     $00,$E4,$46,$6D,$00
        FCB     $00,$44,$4E,$61,$00
        FCB     $00,$4E,$E4,$61,$00
        FCB     $0E,$4E,$E4,$61,$00
        FCB     $08,$80,$04,$81,$00
        FCB     $88,$80,$E8,$81,$00
;*
;*
;*      PLAYER 4'S POINTERS
;*
_PLYR4  FDB     0,$02EF,PLY4R   ;RIDER ON SKIDDING HORSE
        FDB     0,$00EF,PLY4L
        FDB     0,$02ED,PLY4R   ;RIDER NORMALLY ON HORSE
        FDB     0,$00ED,PLY4L
        FDB     CEGGMN,$00F5,PLY4S
;*
;*      RIDER FACEING RIGHT SIDE
;*
PLY4R   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$DD,$D0,$00,$00,$00,$00
        FCB     $00,$D4,$40,$00,$00,$00,$00
        FCB     $00,$DD,$00,$00,$00,$00,$00
        FCB     $0D,$DD,$DD,$00,$00,$00,$00
        FCB     $0D,$D1,$11,$11,$11,$11,$10
        FCB     $0D,$DD,$DD,$00,$00,$00,$00
        FCB     $00,$DD,$DD,$D0,$00,$00,$00
;*
;*      AND THE EVER POPULAR COPYRIGHT MESSAGE
;*
        FCC     'JOUST (C) 1982 WILLIAMS ELECTRONICS INC.'
;*
;*      RIDER FACEING LEFT SIDE
;*
PLY4L   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$0D,$DD,$00
        FCB     $00,$00,$00,$00,$04,$4D,$00
        FCB     $00,$00,$00,$00,$00,$DD,$00
        FCB     $00,$00,$00,$00,$DD,$DD,$D0
        FCB     $01,$11,$11,$11,$11,$1D,$D0
        FCB     $00,$00,$00,$00,$DD,$DD,$D0
        FCB     $00,$00,$00,$0D,$DD,$DD,$00
;*
;*      PLAYER STANDING (LEFT & RIGHT)
;*
;*AAFF040C7DB0FFF4FFF4FFF4FFF4FFF4
;*00FF704D0F3F41ED14904D111FA40A67
PLY4S   FDB     $050C!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$01,$00
        FCB     $00,$9D,$D9,$01,$00
        FCB     $00,$D4,$4E,$01,$00
        FCB     $00,$ED,$D6,$01,$00
        FCB     $0D,$DD,$D9,$DA,$00
        FCB     $D9,$6D,$D9,$DD,$00
        FCB     $00,$6D,$D6,$6A,$00
        FCB     $00,$DD,$DE,$61,$00
        FCB     $00,$D9,$9D,$61,$00
        FCB     $09,$DE,$ED,$61,$00
        FCB     $03,$30,$0D,$31,$00
        FCB     $33,$30,$93,$31,$00
;*
;*
;*      PLAYER 5'S POINTERS
;*
_PLYR5  FDB     0,$02EF,PLY5R   ;RIDER ON SKIDDING HORSE
        FDB     0,$00EF,PLY5L
        FDB     0,$02ED,PLY5R   ;RIDER NORMALLY ON HORSE
        FDB     0,$00ED,PLY5L
        FDB     CEGGMN,$00F5,PLY5S
;*
;*      RIDER FACEING RIGHT SIDE
;*
PLY5R   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$99,$90,$00,$00,$00,$00
        FCB     $00,$95,$50,$00,$00,$00,$00
        FCB     $00,$99,$00,$00,$00,$00,$00
        FCB     $09,$99,$99,$00,$00,$00,$00
        FCB     $09,$91,$11,$11,$11,$11,$10
        FCB     $09,$99,$99,$00,$00,$00,$00
        FCB     $00,$99,$99,$90,$00,$00,$00
;*
;*      RIDER FACEING LEFT SIDE
;*
PLY5L   FDB     $0707!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$09,$99,$00
        FCB     $00,$00,$00,$00,$05,$59,$00
        FCB     $00,$00,$00,$00,$00,$99,$00
        FCB     $00,$00,$00,$00,$99,$99,$90
        FCB     $01,$11,$11,$11,$11,$19,$90
        FCB     $00,$00,$00,$00,$99,$99,$90
        FCB     $00,$00,$00,$09,$99,$99,$00
;*
;*      RIDER STANDING (LEFT & RIGHT)
;*AAFF050C78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
PLY5S   FDB     $050C!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$01,$00
        FCB     $00,$E9,$9E,$01,$00
        FCB     $00,$95,$5E,$01,$00
        FCB     $00,$E9,$9E,$01,$00
        FCB     $09,$99,$90,$9D,$00
        FCB     $9E,$E9,$90,$99,$00
        FCB     $00,$E9,$96,$6D,$00
        FCB     $00,$99,$9E,$61,$00
        FCB     $00,$96,$69,$61,$00
        FCB     $0E,$9E,$E9,$61,$00
        FCB     $03,$30,$09,$31,$00
        FCB     $33,$30,$E3,$31,$00
;*
;*      EGG STILLS & HATCHING
;*
_EGGI   FDB     CEGGUP,$00FA,EGGUP
        FDB     CEGGLF,$00FB,EGGLF
        FDB     CEGGRT,$00FB,EGGRT
        FDB     CEGGUP,$00FB,EGGB1
        FDB     CEGGMN,$FFF6,EGGB2
        FDB     CEGGMN,$FEF5,EGGB3
        FDB     CEGGMN,$00F5,PLY4S
;*
CEGGUP
        FDB     3+COFF,6+COFF
        FDB     2+COFF,7+COFF
        FDB     2+COFF,7+COFF
        FDB     2+COFF,7+COFF
        FDB     2+COFF,7+COFF
        FDB     2+COFF,7+COFF
        FDB     3+COFF,6+COFF
        FDB     $8100,$8100
CEGGLF
        FDB     $8000,$8000
        FDB     2+COFF,6+COFF
        FDB     1+COFF,7+COFF
        FDB     1+COFF,7+COFF
        FDB     1+COFF,7+COFF
        FDB     2+COFF,7+COFF
        FDB     3+COFF,6+COFF
        FDB     $8100,$8100
CEGGRT
        FDB     $8000,$8000
        FDB     3+COFF,6+COFF
        FDB     2+COFF,7+COFF
        FDB     1+COFF,7+COFF
        FDB     1+COFF,7+COFF
        FDB     1+COFF,6+COFF
        FDB     2+COFF,5+COFF
        FDB     $8100,$8100     ;ENDING TERMINATOR
CEGGMN
        FDB     3+COFF,6+COFF
        FDB     3+COFF,6+COFF
        FDB     3+COFF,6+COFF
        FDB     2+COFF,4+COFF
        FDB     1+COFF,4+COFF
        FDB     3+COFF,8+COFF
        FDB     3+COFF,8+COFF
        FDB     3+COFF,6+COFF
        FDB     3+COFF,6+COFF
        FDB     2+COFF,7+COFF
        FDB     1+COFF,8+COFF
        FDB     $8100,$8100     ;ENDING TERMINATOR
;*
;*
;*      EGG FALLING SEQUENCE
;*
;*AAFF050778B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
EGGUP   FDB     $0407!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$B2,$2B,$00
        FCB     $0B,$21,$12,$B0
        FCB     $02,$11,$11,$20
        FCB     $02,$15,$15,$20
        FCB     $02,$51,$55,$20
        FCB     $03,$25,$52,$30
        FCB     $00,$32,$23,$00
;*AAFF050678B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
EGGRT   FDB     $0406!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$25,$52,$00
        FCB     $02,$51,$15,$B0
        FCB     $32,$11,$11,$30
        FCB     $35,$11,$52,$B0
        FCB     $B2,$55,$23,$00
        FCB     $0B,$33,$30,$00
;*AAFF050678B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
EGGLF   FDB     $0406!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $02,$55,$20,$00
        FCB     $B5,$11,$52,$00
        FCB     $31,$11,$12,$30
        FCB     $B2,$51,$15,$30
        FCB     $03,$25,$52,$B0
        FCB     $00,$33,$3B,$00
;*AAFF060678B074F774F67476F4F67474
;*00FF70580F3F51E814905D111FA40A67
EGGB1   FDB     $0506!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $02,$00,$63,$53,$00
        FCB     $25,$36,$4E,$52,$30
        FCB     $51,$5E,$63,$51,$30
        FCB     $21,$52,$E2,$15,$30
        FCB     $32,$12,$35,$22,$00
        FCB     $0B,$22,$32,$3B,$00
;*AAFF080B78B074F774F67476F4F67474
;*00FF70580F3F51E814905D111FA40A67
EGGB2   FDB     $080B!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$63,$36,$00,$00,$00,$00
        FCB     $00,$00,$B6,$46,$00,$00,$00,$00
        FCB     $55,$00,$B3,$3E,$00,$00,$00,$00
        FCB     $32,$03,$33,$E0,$80,$00,$05,$00
        FCB     $00,$B0,$E3,$B0,$00,$00,$23,$00
        FCB     $00,$00,$0B,$B3,$35,$30,$00,$00
        FCB     $02,$30,$06,$6E,$31,$30,$00,$00
        FCB     $01,$03,$36,$63,$23,$00,$00,$00
        FCB     $01,$15,$36,$E0,$00,$00,$05,$00
        FCB     $02,$11,$23,$E0,$21,$03,$11,$00
        FCB     $00,$22,$22,$E2,$12,$33,$23,$00
;*AAFF0A0C78B074F774F67476F4F67474
;*00FF70580F3F51E814905D111FA40A67
EGGB3   FDB     $0A0C!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$00,$01,$00,$00,$00,$00
        FCB     $15,$00,$00,$6D,$D6,$01,$00,$00,$00,$00
        FCB     $32,$00,$00,$34,$43,$01,$00,$00,$05,$00
        FCB     $00,$00,$00,$ED,$D3,$01,$00,$00,$52,$00
        FCB     $00,$00,$03,$3D,$D0,$DD,$00,$00,$00,$00
        FCB     $00,$00,$DE,$63,$D0,$2D,$00,$00,$00,$00
        FCB     $00,$00,$00,$63,$36,$6D,$00,$00,$00,$00
        FCB     $05,$00,$00,$32,$3E,$61,$00,$00,$00,$00
        FCB     $03,$20,$00,$D6,$63,$61,$00,$00,$01,$00
        FCB     $00,$00,$03,$3E,$E2,$61,$00,$00,$12,$00
        FCB     $00,$00,$03,$30,$03,$31,$00,$00,$00,$00
        FCB     $00,$00,$33,$30,$E3,$31,$00,$00,$00,$00
;*
;*      LAVA TROLL GRABBING HAND
;*
_ILAVAT FDB     0,$00FB,GRAB1
        FDB     0,$00F8,GRAB2
        FDB     0,$00F8,GRAB3
        FDB     0,$00F2,GRAB4
        FDB     0,$00F0,GRAB5
        FDB     0,$00EF,GRAB6

;*
;*      LAVA TROOL HAND SEQUENCES
;*
;*AAFF040678B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
GRAB1   FDB     $0306!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $44,$8E,$00
        FCB     $0E,$44,$E0
        FCB     $00,$04,$80
        FCB     $00,$0E,$40
        FCB     $00,$00,$40
        FCB     $00,$00,$40
;*AAFF040978B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
GRAB2   FDB     $0409!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$0C,$00
        FCB     $00,$00,$E4,$00
        FCB     $00,$00,$44,$00
        FCB     $00,$0E,$44,$00
        FCB     $0E,$44,$4E,$00
        FCB     $E4,$44,$E0,$00
        FCB     $44,$E0,$00,$00
        FCB     $48,$00,$00,$00
        FCB     $4E,$00,$00,$00
;*AAFF070978B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
GRAB3   FDB     $0609!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$40,$04,$00
        FCB     $00,$04,$00,$40,$04,$E0
        FCB     $00,$04,$0E,$40,$E4,$E0
        FCB     $00,$04,$4C,$C4,$44,$00
        FCB     $00,$04,$4A,$CC,$4E,$00
        FCB     $00,$E4,$AA,$44,$E0,$00
        FCB     $00,$4A,$A4,$E0,$00,$00
        FCB     $04,$A8,$E0,$00,$00,$00
        FCB     $4E,$00,$00,$00,$00,$00
;*AAFF070F78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
GRAB4   FDB     $060F!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$A0,$00,$80,$00
        FCB     $00,$00,$A0,$0E,$A0,$00
        FCB     $08,$00,$A8,$0A,$80,$00
        FCB     $EA,$0E,$A8,$8A,$80,$A0
        FCB     $AA,$08,$AA,$AA,$0A,$A0
        FCB     $CA,$0A,$AA,$A8,$8A,$80
        FCB     $8C,$AA,$AA,$AA,$AC,$00
        FCB     $EC,$AA,$AA,$AC,$4E,$00
        FCB     $08,$CA,$CA,$A4,$E0,$00
        FCB     $0E,$4C,$AC,$4E,$00,$00
        FCB     $00,$4C,$C4,$E0,$00,$00
        FCB     $00,$44,$4E,$00,$00,$00
        FCB     $0E,$44,$E0,$00,$00,$00
        FCB     $E4,$4E,$00,$00,$00,$00
        FCB     $4E,$00,$00,$00,$00,$00
;*AAFF081178B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
GRAB5   FDB     $0711!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$80,$00,$00,$00
        FCB     $00,$00,$0E,$80,$0A,$00,$00
        FCB     $00,$00,$0E,$E0,$8E,$0E,$E0
        FCB     $0A,$00,$08,$EE,$80,$08,$80
        FCB     $E8,$00,$E8,$08,$80,$88,$00
        FCB     $88,$00,$EA,$A8,$E8,$80,$00
        FCB     $EA,$80,$88,$5F,$AA,$0E,$80
        FCB     $0A,$AF,$FE,$8F,$5E,$88,$E0
        FCB     $0E,$A8,$F8,$AA,$AA,$80,$00
        FCB     $08,$AA,$8A,$AA,$E8,$00,$00
        FCB     $0E,$88,$8F,$5F,$80,$00,$00
        FCB     $00,$8A,$A5,$FA,$E0,$00,$00
        FCB     $08,$8E,$8A,$8E,$00,$00,$00
        FCB     $04,$AA,$8E,$E0,$00,$00,$00
        FCB     $E4,$C4,$CE,$00,$00,$00,$00
        FCB     $84,$48,$E0,$00,$00,$00,$00
        FCB     $48,$E0,$00,$00,$00,$00,$00
;*AAFF081278B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
GRAB6   FDB     $0712!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$AA,$F0,$00
        FCB     $00,$00,$00,$8A,$88,$E8,$80
        FCB     $00,$00,$0E,$F8,$EA,$EA,$A0
        FCB     $00,$00,$0F,$AE,$08,$88,$E0
        FCB     $00,$00,$AF,$AE,$8A,$AF,$F0
        FCB     $00,$0E,$AA,$EE,$EE,$08,$80
        FCB     $00,$08,$88,$8E,$8A,$FF,$80
        FCB     $00,$EA,$FE,$A8,$E0,$88,$00
        FCB     $0E,$8F,$88,$FA,$0F,$08,$00
        FCB     $08,$4A,$88,$8E,$81,$E0,$00
        FCB     $04,$A4,$8E,$08,$F1,$E0,$00
        FCB     $04,$A8,$E0,$0F,$8F,$E0,$00
        FCB     $04,$CE,$00,$0F,$EF,$E0,$00
        FCB     $08,$CE,$00,$00,$F8,$E0,$00
        FCB     $0E,$48,$00,$00,$00,$00,$00
        FCB     $00,$48,$00,$00,$00,$00,$00
        FCB     $04,$4E,$00,$00,$00,$00,$00
        FCB     $48,$E0,$00,$00,$00,$00,$00
;*
;*      LAVA FLAME
;*
_IFLAME FDB     0,$00F2,FLAME1
        FDB     0,$00F1,FLAME2
        FDB     0,$00F1,FLAME3
        FDB     0,$00F5,FLAME4
;*
;*      FLAME SEQUENCES
;*
;*AAFF050F78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
FLAME1  FDB     $040F!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$40,$00
        FCB     $00,$0E,$44,$00
        FCB     $00,$04,$C4,$00
        FCB     $00,$04,$A8,$00
        FCB     $00,$08,$50,$00
        FCB     $00,$00,$50,$00
        FCB     $00,$00,$00,$00
        FCB     $00,$00,$00,$00
        FCB     $0E,$80,$00,$00
        FCB     $00,$4E,$00,$00
        FCB     $00,$E4,$40,$00
        FCB     $00,$E4,$C4,$00
        FCB     $00,$8C,$5A,$E0
        FCB     $0E,$CA,$55,$C0
        FCB     $E4,$A5,$55,$A0
;*AAFF041078B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
FLAME2  FDB     $0410!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$0E,$4E,$00
        FCB     $00,$0E,$44,$00
        FCB     $00,$00,$4A,$00
        FCB     $00,$00,$04,$00
        FCB     $00,$00,$00,$00
        FCB     $00,$00,$00,$00
        FCB     $00,$00,$00,$00
        FCB     $04,$EE,$00,$00
        FCB     $0E,$48,$E0,$00
        FCB     $0E,$44,$80,$00
        FCB     $00,$44,$CE,$00
        FCB     $00,$4C,$A8,$00
        FCB     $00,$4A,$5C,$00
        FCB     $0E,$C5,$5C,$00
        FCB     $08,$A5,$5C,$00
        FCB     $4A,$55,$5A,$00
;*AAFF051078B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
FLAME3  FDB     $0510!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$4E,$00
        FCB     $00,$00,$00,$E4,$00
        FCB     $00,$00,$00,$00,$00
        FCB     $00,$00,$00,$00,$00
        FCB     $00,$00,$00,$00,$00
        FCB     $00,$00,$40,$00,$00
        FCB     $00,$04,$00,$40,$00
        FCB     $0E,$44,$0E,$40,$00
        FCB     $04,$4E,$0C,$40,$00
        FCB     $04,$C0,$4A,$80,$00
        FCB     $0C,$54,$C8,$E0,$00
        FCB     $0A,$5A,$C4,$00,$00
        FCB     $0A,$55,$C4,$00,$00
        FCB     $05,$55,$A8,$00,$00
        FCB     $05,$55,$A8,$00,$00
        FCB     $4A,$55,$A8,$00,$00
;*AAFF040C78B0FFF4FFF4FFF4FFF4FFF4
;*00FF70580F3F51E814905D111FA40A67
FLAME4  FDB     $040C!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$04,$00
        FCB     $00,$04,$44,$00
        FCB     $00,$4C,$48,$00
        FCB     $0E,$CA,$40,$00
        FCB     $04,$AE,$00,$00
        FCB     $04,$00,$00,$00
        FCB     $04,$00,$00,$00
        FCB     $84,$80,$00,$00
        FCB     $4C,$CE,$00,$00
        FCB     $4A,$5C,$E0,$00
        FCB     $45,$55,$A0,$00
        FCB     $4A,$55,$AE,$00
;*
;*******************************************************************************
;*      PLAYER DEATH POOF IMAGES
;*       FROM KEN LANTZ
;*
_POOF1  POSOFF  0,$01,$18,FL1
_POOF2  POSOFF  0,$01,$1E,FL2
_POOF3  POSOFF  0,$00,$23,FL3
;*
FL1     FDB     $0305!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$04,$00
        FCB     $00,$44,$40
        FCB     $04,$41,$44
        FCB     $00,$44,$40
        FCB     $00,$04,$00
;*
FL2     FDB     $0509!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$70,$00,$00
        FCB     $07,$00,$70,$07,$00
        FCB     $00,$70,$00,$70,$00
        FCB     $00,$05,$05,$00,$00
        FCB     $77,$00,$00,$07,$70
        FCB     $00,$05,$05,$00,$00
        FCB     $00,$70,$00,$70,$00
        FCB     $07,$00,$70,$07,$00
        FCB     $00,$00,$70,$00,$00
;*
FL3     FDB     $060B!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$07,$00,$07,$00,$00
        FCB     $00,$00,$07,$00,$00,$00
        FCB     $07,$00,$00,$00,$07,$00
        FCB     $00,$07,$01,$07,$00,$00
        FCB     $00,$00,$00,$00,$00,$00
        FCB     $70,$71,$00,$01,$70,$70
        FCB     $00,$00,$00,$00,$00,$00
        FCB     $00,$07,$01,$07,$00,$00
        FCB     $07,$00,$00,$00,$07,$00
        FCB     $00,$00,$07,$00,$00,$00
        FCB     $00,$07,$00,$07,$00,$00
;*
;*      PTERODACTYL, FLYING ONLY IMAGES
;*
_IPTERO POSOFF  PT1RC,1,11,PT1R
        POSOFF  PT1LC,1,11,PT1L
        POSOFF  PT2RC,1,07,PT2R
        POSOFF  PT2LC,0,07,PT2L
        POSOFF  PT3RC,0,10,PT3R
        POSOFF  PT3LC,0,10,PT3L
;*
PT1RC   FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     9+COFF,14+COFF
        FDB     9+COFF,22+COFF
        FDB     5+COFF,26+COFF
        FDB     3+COFF,24+COFF
        FDB     5+COFF,21+COFF
        FDB     8+COFF,15+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100             ;TERMINATING POINTER
;*
PT2RC   FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     20+COFF,24+COFF
        FDB     10+COFF,27+COFF
        FDB     7+COFF,25+COFF
        FDB     5+COFF,25+COFF
        FDB     7+COFF,26+COFF
        FDB     5+COFF,21+COFF
        FDB     3+COFF,7+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100             ;TERMINATING POINTER
;*
PT3RC   FDB     $8000,$8000
        FDB     27+COFF,28+COFF
        FDB     23+COFF,27+COFF
        FDB     22+COFF,26+COFF
        FDB     20+COFF,25+COFF
        FDB     9+COFF,27+COFF
        FDB     6+COFF,25+COFF
        FDB     4+COFF,26+COFF
        FDB     6+COFF,21+COFF
        FDB     8+COFF,16+COFF
        FDB     5+COFF,12+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100             ;TERMINATING POINTER
;*
PT1LC   FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     15+COFF,20+COFF
        FDB     7+COFF,20+COFF
        FDB     3+COFF,24+COFF
        FDB     5+COFF,26+COFF
        FDB     8+COFF,24+COFF
        FDB     14+COFF,21+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100
        FDB     $8100,$8100             ;TERMINATING POINTER
;*
PT2LC   FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     $8000,$8000
        FDB     5+COFF,9+COFF
        FDB     2+COFF,19+COFF
        FDB     4+COFF,22+COFF
        FDB     4+COFF,24+COFF
        FDB     3+COFF,22+COFF
        FDB     12+COFF,24+COFF
        FDB     22+COFF,26+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100             ;TERMINATING POINTER
;*
PT3LC   FDB     $8000,$8000
        FDB     1+COFF,2+COFF
        FDB     2+COFF,6+COFF
        FDB     3+COFF,7+COFF
        FDB     4+COFF,9+COFF
        FDB     2+COFF,20+COFF
        FDB     4+COFF,23+COFF
        FDB     3+COFF,25+COFF
        FDB     8+COFF,23+COFF
        FDB     13+COFF,21+COFF
        FDB     17+COFF,24+COFF
        FDB     $8100,$8100
        FDB     $8100,$8100             ;TERMINATING POINTER
;*
;*AAFF0E0E80C2FF00FF40FF00FF00FF00
;*00FF70580F3F51E814905D111FA40A67
PT1R    FDB     $0D0A!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $99,$99,$F6,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$09,$44,$F7,$90,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$00,$00,$44,$CF,$79,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$00,$00,$09,$44,$FF,$70,$00,$00,$00,$00,$00,$00
        FCB     $00,$00,$00,$94,$4F,$79,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$00,$00,$94,$CF,$70,$00,$0D,$1F,$FD,$00,$00,$00
        FCB     $00,$99,$44,$88,$F4,$14,$90,$00,$04,$00,$D1,$1F,$00
        FCB     $99,$64,$8C,$FF,$CC,$C5,$FF,$CA,$88,$FF,$DD,$00,$00
        FCB     $00,$99,$44,$CD,$FF,$88,$4F,$FC,$34,$E0,$00,$00,$00
        FCB     $00,$00,$09,$44,$48,$86,$E0,$00,$00,$00,$00,$00,$00
;*
;*AAFF0E077FCBFF00FF40FF00FF00FF00
;*00FF70580F3F51E814905D111FA40A67
;*
PT2R    FDB     $0D07!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$0D,$1F,$FD,$00,$00
        FCB     $00,$00,$00,$06,$36,$9F,$F1,$90,$00,$04,$00,$11,$10
        FCB     $00,$00,$69,$94,$9F,$FC,$F9,$A0,$00,$EC,$8F,$80,$00
        FCB     $00,$69,$4E,$94,$FC,$D8,$E8,$9C,$9F,$FD,$C9,$F0,$00
        FCB     $00,$00,$94,$FC,$99,$6E,$98,$AD,$CF,$8E,$00,$ED,$00
        FCB     $00,$94,$DD,$66,$0E,$E6,$88,$E0,$00,$00,$00,$00,$00
        FCB     $94,$F4,$90,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;*
;*AAFF0F0B7FC8FF00FF40FF00FF00FF00
;*00FF70580F3F51E814905D111FA40A67
;*
PT3R    FDB     $0F0B!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8F,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FD,$ED,$10,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$00,$DF,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$00,$0F,$14,$F1,$C0,$00,$00
        FCB     $00,$00,$00,$00,$63,$69,$86,$00,$00,$00,$0F,$DC,$E8,$40,$00
        FCB     $00,$00,$06,$99,$AA,$AC,$FC,$A6,$00,$00,$CD,$43,$F0,$00,$00
        FCB     $00,$06,$94,$84,$C3,$FF,$F1,$8A,$CD,$FF,$D8,$00,$ED,$00,$00
        FCB     $00,$00,$06,$64,$6F,$FC,$F9,$8C,$DC,$F8,$E0,$00,$00,$00,$00
        FCB     $00,$00,$00,$06,$4C,$78,$66,$8E,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$00,$99,$4C,$AA,$F7,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $99,$44,$CA,$AA,$FF,$D7,$D0,$00,$00,$00,$00,$00,$00,$00,$00
;*
;*AAFF0E0E80C2FF00FF40FF00FF00FF00
;*00FF70580F3F51E814905D111FA40A67
PT1L    FDB     $0D0A!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$00,$6F,$99,$99,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$09,$7F,$44,$90,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$97,$FC,$44,$00,$00,$00,$00
        FCB     $00,$00,$00,$00,$00,$07,$FF,$44,$90,$00,$00,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$97,$F4,$49,$00,$00,$00,$00
        FCB     $00,$00,$DF,$F1,$D0,$00,$07,$FC,$49,$00,$00,$00,$00
        FCB     $F1,$1D,$00,$40,$00,$09,$41,$4F,$88,$44,$99,$00,$00
        FCB     $00,$DD,$FF,$88,$AC,$FF,$5C,$CC,$FF,$C8,$46,$99,$00
        FCB     $00,$00,$0E,$43,$CF,$F4,$88,$FF,$DC,$44,$99,$00,$00
        FCB     $00,$00,$00,$00,$00,$0E,$68,$84,$44,$90,$00,$00,$00
;*
;*AAFF0E077FCBFF00FF40FF00FF00FF00
;*00FF70580F3F51E814905D111FA40A67
;*
PT2L    FDB     $0E07!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $00,$00,$DF,$F1,$D0,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $01,$11,$00,$40,$00,$09,$1F,$F9,$63,$60,$00,$00,$00,$00
        FCB     $00,$08,$F8,$CE,$00,$0A,$9F,$CF,$F9,$49,$96,$00,$00,$00
        FCB     $00,$0F,$9C,$DF,$F9,$C9,$8E,$8D,$CF,$49,$E4,$96,$00,$00
        FCB     $00,$DE,$00,$E8,$FC,$DA,$89,$E6,$99,$CF,$49,$00,$00,$00
        FCB     $00,$00,$00,$00,$00,$0E,$88,$6E,$E0,$66,$DD,$49,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$4F,$49,$00
;*
;*AAFF0F0B7FC8FF00FF40FF00FF00FF00
;*00FF70580F3F51E814905D111FA40A67
;*
PT3L    FDB     $0F0B!DMAFIX                                                    ;;Fixme was: !XDMAFIX
        FCB     $F8,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $01,$DE,$DF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$FD,$00,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $00,$0C,$1F,$41,$F0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        FCB     $04,$8E,$CD,$F0,$00,$00,$00,$68,$96,$36,$00,$00,$00,$00,$00
        FCB     $00,$0F,$34,$DC,$00,$00,$6A,$CF,$CA,$AA,$99,$60,$00,$00,$00
        FCB     $00,$DE,$00,$8D,$FF,$DC,$A8,$1F,$FF,$3C,$48,$49,$60,$00,$00
        FCB     $00,$00,$00,$0E,$8F,$CD,$C8,$9F,$CF,$F6,$46,$60,$00,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$E8,$66,$87,$C4,$60,$00,$00,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$00,$7F,$AA,$C4,$99,$00,$00,$00
        FCB     $00,$00,$00,$00,$00,$00,$00,$0D,$7D,$FF,$AA,$AC,$44,$99,$00
;*
;*      PTERODACTYL DISSOULVE
;*
_ASH1R
_ASH1L
;* PTERA1
        FCB     $D0,$1C,$01
        FCB     $B0,$2C,$14,$01
        FCB     $C0,$14,$01
        FCB     $B0,$14,$1C,$01
        FCB     $40,$34,$30,$24,$1C,$1C,$01
        FCB     $30,$14,$3C,$14,$20,$14,$2C,$01
        FCB     $20,$24,$2C,$34,$2C,$10,$14,$01
        FCB     $30,$34,$5C,$01
        FCB     $30,$24,$3C,$01
        FCB     $20,$2C,$01
        FCB     $24,$5C,$00
;* PTERA2
        FCB     $D0,$14,$01
        FCB     $B0,$24,$1E,$01
        FCB     $C0,$2E,$01
        FCB     $B0,$1E,$14,$01
        FCB     $40,$3E,$30,$2E,$1E,$14,$01
        FCB     $30,$2E,$24,$1E,$20,$1E,$24,$01
        FCB     $20,$3E,$14,$2E,$10,$1E,$14,$2E,$01
        FCB     $30,$1E,$10,$2E,$24,$24,$01
        FCB     $30,$1E,$2E,$24,$01
        FCB     $20,$3E,$14,$01
        FCB     $3E,$24,$24,$00
;* PTERA3
        FCB     $E0,$01
        FCB     $B0,$1E,$14,$1E,$01
        FCB     $C0,$2E,$01
        FCB     $B0,$1E,$1E,$01
        FCB     $40,$2E,$40,$2E,$1E,$1E,$01
        FCB     $30,$1E,$10,$1E,$14,$1E,$20,$1E,$14,$1E,$01
        FCB     $30,$2E,$10,$1E,$20,$1E,$10,$2E,$01
        FCB     $50,$2E,$1E,$14,$1E,$14,$01
        FCB     $40,$2E,$1E,$14,$01
        FCB     $20,$2E,$1E,$01
        FCB     $1E,$2E,$20,$1E,$14,$00




    * $1000-$1FFF
    * $2000-$2FFF
    * $3000-$3FFF
    * $4000-$4FFF
    * $5000-$5FFF
    * $6000-$6FFF
    * $7000-$7FFF
    * $8000-$8FFF
    * $D000-$DFFF
    * $E000-$EFFF
    * $F000-$FFFF
        * $F000-$FFF1: 
        * $FFF2-$FFF3: SWI 3 Vector -- Registers pushed onto stack: D,X,Y,U,DP,CC
        * $FFF4-$FFF5: SWI 2 Vector -- Registers pushed onto stack: D,X,Y,U,DP,CC
        * $FFF6-$FFF7: FIRQ Vector -- Registers pushed onto stack: CC (E flag cleared)
        * $FFF8-$FFF9: IRQ Vector -- Registers pushed onto stack: D,X,Y,U,DP,CC
        * $FFFA-$FFFB: SWI 1 Vector -- Registers pushed onto stack: D,X,Y,U,DP,CC
        * $FFFC-$FFFD: NMI Vector -- Registers pushed onto stack: D,X,Y,U,DP,CC
        * $FFFE-$FFFF: RESET Vector -- Registers pushed onto stack: NA

### AUDIO MEMORY MAP (CPU 6800)
* $F000-$FFFF -- VSNDRM4.ASM
