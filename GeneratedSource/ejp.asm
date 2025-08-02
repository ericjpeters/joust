
; Eric J. Peters - 06/29/2025
; Making some constants more readable

; 6809 CPU Memory Map
;
;		$0000 ? $8FFF				Bank-switched RAM/ROM. This lower 36KB region is dynamically banked between working RAM and program ROM. 
;									When running game code, a portion of the game?s ROM is paged into this address range, but writes still go 
;									to the underlying RAM (the hardware ensures writes are directed to RAM even if ROM is visible) Most of 
;									this RAM serves as the video frame buffer: approximately 0x0000?0x97FF (around 38 KB) is used for the 
;									16-color bitmapped screen memory.  The remaining RAM in this banked region is used for game variables 
;									and stack when RAM is paged in. Writing to address 0xC900 controls this bank switching (see 0xC900 below)
;
;		$9000 ? $BFFF				Fixed RAM. A 12KB block of RAM that is always accessible (not banked).  Combined with the banked RAM above, 
;									the system provides 48KB of total RAM. This area typically holds general program work RAM. (Note: The 
;									video RAM described above overlaps as part of this 48KB total.)
;
;		$C000 ? $C00F				Color palette registers. 16 bytes of memory mapped to the video subsystem?s color PROM/registers.
;									Each byte defines a palette color in the format BBGGGRRR (2 bits Blue, 3 bits Green, 3 bits Red),
;									supporting a 16-color palette for the display.
;
;		$C804 ? $C807				Peripheral Interface Adapter (PIA) ? Input. One Motorola 6821 PIA is mapped here. It handles inputs from 
;									the cabinet (joysticks, buttons, coin switches) and possibly outputs to coin counters or control lamps. 
;									The PIA?s ports are configured for reading player controls and DIP switch settings, and for driving any 
;									associated output lines.
;
;		$C80C ? $C80F				PIA ? Sound interface. A second 6821 PIA at this address is used for communication with the dedicated sound 
;									board.  The main CPU writes a sound command (sound effect ID number) to one of this PIA?s ports, and uses 
;									a control line (via the PIA) to trigger an interrupt on the sound CPU. This PIA also allows the main CPU 
;									to receive handshake/status signals from the sound board if needed (e.g. an acknowledgment interrupt).
;
;		$C900						Bank select & watchdog control. Writing to this address controls the banked ROM/RAM region. Bit 0 of the 
;									value written selects whether 0x0000?0x8FFF maps to the game ROM bank or to RAM. The Williams hardware also 
;									implements a watchdog timer that will reset the machine unless it is regularly ?petted? ? this is 
;									accomplished by writing the exact value 0x39 to 0xC900 periodically. (The value 0x39 both toggles the 
;									bank-select bit appropriately and satisfies the watchdog?s expected pattern for reset.)
;
;		$CA00 ? $CA07				Blitter hardware. This range is mapped to Williams? custom bit-blitter chips. The blitter is a hardware 
;									block for fast bitmap drawing/copy operations, used to render sprites and images into video RAM quickly. 
;									The CPU writes parameters (source/destination addresses, width/height, and control bits) into these 
;									registers to trigger high-speed block transfers and bit masking for graphics blitting.
;
;		$CC00 ? $CFFF				CMOS NVRAM. A 1KB block of battery-backed static RAM for game settings and high scores. This ?CMOS? memory 
;									retains data when the machine is powered off, storing bookkeeping info, adjustable game settings, and player 
;									high-score initials.
;
;		$D000 - $FFEF				Program ROM (fixed). The upper 12KB of the CPU address space is permanently mapped to ROM. Together with 
;									banked ROM in the 0x0000?0x8FFF range, this contains the game?s entire program code and data (Joust?s total 
;									ROM footprint is ~48KB). 
;
;       $FFF0 - $FFF1				IRQ Vector - The 6809 processor?s reset and interrupt vectors reside at the top of this space 
;									(the vector table occupies the highest addresses, within 0xFFF0?0xFFFF).
;       $FFF2 - $FFF3				reserved
;       $FFF4 - $FFF5				FIRQ Vector
;       $FFF6 - $FFF7				reserved
;       $FFF8 - $FFF9				NMI (Non-Maskable Interrupt) vector
;       $FFFA - $FFFB				Software Interrupt (SWI) Vector
;       $FFFC - $FFFD				Reset Vector
;       $FFFE - $FFFF				Reset Vector (Extended) - provides a second reset vector for the 6809, allowing it to be used in systems 
;									with multiple CPUs or complex interrupt handling.   It appears to be unused in Joust.
;
; 6802/6808 CPU Memory Map (Audio Board)
;
; The sound subsystem runs on a separate board with its own 8-bit CPU (a Motorola 6808 or 6802 at ~1?MHz). Its memory map and resources are distinct 
; from the main CPU:
;
;		$0000 ? $007F				Scratch RAM. 128 bytes of working RAM for the sound CPU. In boards using a MC6802, this is the CPU?s internal 
;									RAM.  if a MC6808 is used (which lacks internal RAM), an external 6810 static RAM (128?8) occupies this space. 
;									This tiny RAM is used for the sound program?s stack and variables.
;
;		$0400 ? $0403				Sound I/O PIA (6821). The sound board?s PIA is mapped here, interfacing with both the main CPU and the DAC. 
;									One PIA port is configured as an input to receive the 7-bit sound command from the main CPU (latched when the 
;									main CPU writes to the sound PIA address on its side). The other port is an 8-bit output connected to an audio 
;									DAC (an MC1408 8-bit D/A converter). Writing a value to address 0x0400 on the sound CPU actually loads that 
;									8-bit value into the DAC, producing an analog voltage (sound output). The sound PIA?s control lines are used 
;									for handshaking: the main CPU signals the sound CPU via an IRQ or NMI line (triggered through the PIA) to tell 
;									it a new sound command is ready.
;
;		$B000 ? $EFFF				(Unused in Joust ? expansion space)
;									This range is not used by Joust?s standard sound hardware. (In later Williams games, this address space was used 
;									for additional audio hardware; for example, Sinistar?s speech board maps extra ROM and a Harris HC-55516 CVSD 
;									DAC in a portion of 0xB000?0xEFFF for voice playback.)
;
;		$F000 ? $FFFF				Sound program ROM. The sound CPU?s program ROM is mapped at the top of its address space. Joust uses a 4KB 
;									EPROM (mounted on the sound board) occupying 0xF000?0xFFFF, which contains the sound routine code and data 
;									(synthesis algorithms for each sound effect, etc.). The sound CPU?s reset and interrupt vectors (per 6800/6802 
;									architecture) are stored in the highest bytes of this ROM.
;
; source files:
;	* EJP.ASM			=> $0000 - $0000					EQU's only
;	* JOUSTI.ASM		=> $0000 - $39C6		BSM			Bank Switched Memory [RAM/ROM]
;	* RAMDEF.ASM		=> $E000 - $E03C		ROM
;                          $5ED0 - $5EEA		BSM
;                          $0000 - $003B		BSM
;                          $0000 - $0037		BSM
;                          $000D - $0035		BSM
;                          $A000 - $A03D		RAM
;                          $A040 - $A077		RAM
;                          $A080 - $A0BC		RAM
;                          $A0C0 - $A0C7		RAM
;                          $A100 - $B200		RAM
;	* EQU.ASM			=> $3B10 - $3B63		BSM
;						   $A0D0 - $A100		RAM
;                          $CC00 - $CC8F		CMOS		NVRAM
;                          $CD00 - $CFF7		CMOS
;                          $F000 - $F014		ROM
;	* MESSEQU.ASM		=> $4A50 - $4A6F		BSM
;	* MESSEQU2.ASM		=> $4A6F - $4A6F					EQU's only
;	* TB12REV3.ASM		=> $3B10 - $4A38		BSM
;	* MESSAGE.ASM		=> $4A50 - $5308		BSM
;	* PHRASE.ASM		=> $5309 - $5EC2		BSM
;	* ATT.ASM			=> $000D - $0013		BSM
;						   $BC00 - $BC1F		RAM
;                          $D000 - $D6EF		ROM
;	* SYSTEM.ASM		=> $E000 - $E694		ROM
;                          $EFF0 - $EFFF		ROM
;	* JOUSTRV4.ASM		=> $0000 - $0003		BSM
;						   $0000 - $0006		BSM
;						   $0000 - $0007		BSM
;						   $0000 - $000D		BSM
;						   $0000 - $0030		BSM
;						   $0000 - $006B		BSM
;						   $0007 - $0036		BSM
;						   $5ED0 - $8FBE		BSM
;                          $B300 - $B303		RAM
;						   $D760 - $D7F9		ROM
;						   $D800 - $DF99		ROM
;						   $E6A8 - $EFE7		ROM
;	* T12REV3.ASM		=> $F000 - $FFE7		ROM
;						   $FFF0 - $FFFF		ROM
;   * JOUST_MODS.ASM	=> 
;						   $6518 - $651A		BSM
;						   $6545 - $6547		BSM
;						   $655F - $6561		BSM
;						   $658E - $6590		BSM
;						   $663D - $663D		BSM
;						   $6AD6 - $6AD7		BSM
;						   $82FB - $82FD		BSM
;						   $8598 - $8598		BSM
;						   $85D0 - $85D5		BSM
;						   $872B - $872C		BSM
;						   $876A - $876C		BSM
;						   $8AAC - $8AAE		BSM
;						   $8D2F - $8D31		BSM
;						   $D6EF - $D746		ROM
;						   $DDC1 - $DDC3		ROM
;						   $DFA0 - $DFF4		ROM
;						   $E70A - $E70C		ROM
;						   $EB97 - $EB97		ROM
;						   $F066 - $F067		ROM
;						   $F06C - $F06E		ROM
;						   $F320 - $F341		ROM
;						   $F33E - $F341		ROM
;						   $F43D - $F442		ROM
;						   $F4B7 - $F4B8		ROM
;						   $F4C2 - $F4C4		ROM
;						   $F4C5 - $F562		ROM
;						   $F563 - $F5A0		ROM
;						   $F5A1 - $F5EF		ROM
;
; Used vs. Free
;	* $0000 - $39C6			(multiple sources)
;		* $0000 - $0003		JOUSTRV4.ASM
;		* $0000 - $000D		JOUSTRV4.ASM
;		* $0000 - $0006		JOUSTRV4.ASM
;		* $0000 - $0007		JOUSTRV4.ASM
;		* $0000 - $0030		JOUSTRV4.ASM
;		* $0000 - $0037		RAMDEF.ASM
;		* $0000 - $003B		RAMDEF.ASM
;		* $0000 - $006B		JOUSTRV4.ASM
;		* $0000 - $39C6		JOUSTI.ASM
;		* $0007 - $0036		JOUSTRV4.ASM
;		* $000D - $0013		ATT.ASM
;		* $000D - $0035		RAMDEF.ASM
;	* [$39C7 - $3B0F]		(free)						$0141 bytes
;	* $3B10 - $4A38			(multiple sources)
;		* $3B10 - $3B63		EQU.ASM
;		* $3B10 - $4A38		TB12REV3.ASM
;   * [$4A37 - $4A4F]		(free)						$0019 bytes
;	* $4A50 - $5308			(multiple sources)
;		* $4A50 - $4A6F		MESSEQU.ASM
;		* $4A50 - $5308		MESSAGE.ASM
;	* $5309 - $5EC2			PHRASE.ASM
;   * [$5EC3 - $5ECF]		(free)						$000D bytes
;	* $5ED0 - $8FBE			(multiple sources)
;		* $5ED0 - $5EEA		RAMDEF.ASM
;		* $5ED0 - $8FBE		JOUSTRV4.ASM
;		* $6518 - $651A		JOUST_MODS.ASM
;		* $6545 - $6547		JOUST_MODS.ASM
;		* $655F - $6561		JOUST_MODS.ASM
;		* $658E - $6590		JOUST_MODS.ASM
;		* $663D - $663D		JOUST_MODS.ASM
;		* $6AD6 - $6AD7		JOUST_MODS.ASM
;		* $82FB - $82FD		JOUST_MODS.ASM
;		* $8598 - $8598		JOUST_MODS.ASM
;		* $85D0 - $85D5		JOUST_MODS.ASM
;		* $872B - $872C		JOUST_MODS.ASM
;		* $876A - $876C		JOUST_MODS.ASM
;		* $8AAC - $8AAE		JOUST_MODS.ASM
;		* $8D2F - $8D31		JOUST_MODS.ASM
;	* [$8FBF - $9FFF]		(free)						$1040 bytes
;	* $A000 - $A03D			RAMDEF.ASM
;   * [$A03E - $A03F]		(free)						$0002 bytes
;	* $A040 - $A077			RAMDEF.ASM
;   * [$A078 - $A07F]		(free)						$0008 bytes
;	* $A080 - $A0BC			RAMDEF.ASM
;   * [$A0BD - $A0BF]		(free)						$0003 bytes
;	* $A0C0 - $A0C7			RAMDEF.ASM
;   * [$A0C8 - $A0CF]		(free)						$0008 bytes
;	* $A0D0 - $B200			(multiple sources)
;		* $A0D0 - $A100		EQU.ASM
;		* $A100 - $B200		RAMDEF.ASM
;   * [$B201 - $B2FF]		(free)						$00FF bytes
;	* $B300 - $B303			JOUSTRV4.ASM
;   * [$B304 - $BBFF]		(free)						$08FC bytes
;	* $BC00 - $BC1F			ATT.ASM
;   * [$BC20 - $CBFF]		(free)						$0FE0 bytes
;	* $CC00 - $CC8F			EQU.ASM
;   * [$CC90 - $CCFF]		(free)						$0070 bytes
;	* $CD00 - $CFF7			EQU.ASM
;   * [$CCC8 - $CFFF]		(free)						$0338 bytes
;	* $D000 - $D6EE			ATT.ASM
;	* $D6EF - $D746			JOUST_MODS.ASM
;   * [$D747 - $D75F]		(free)						$0019 bytes
;	* $D760 - $D7F9			JOUSTRV4.ASM
;   * [$D7FA - $D7FF]		(free)						$0006 bytes
;	* $D800 - $DF99			(multiple sources)
;		* $D800 - $DF99		JOUSTRV4.ASM
;		* $DDC1 - $DDC3		JOUST_MODS.ASM
;   * [$DF9A - $DF9F]		(free)						$0006 bytes
;	* $DFA0 - $DFF4			JOUST_MODS.ASM
;   * [$DFF5 - $DFFF]		(free)						$000B bytes
;	* $E000 - $E694			(multiple sources)
;		* $E000 - $E03C		RAMDEF.ASM
;		* $E000 - $E694		SYSTEM.ASM
;   * [$E695 - $E6A7]		(free)						$0013 bytes
;	* $E6A8 - $EFE7			(multiple sources)
;		* $E6A8 - $EFE7		JOUSTRV4.ASM
;		* $E70A - $E70C		JOUST_MODS.ASM
;		* $EB97 - $EB97		JOUST_MODS.ASM
;   * [$EFE8 - $EFEF]		(free)						$0008 bytes
;	* $EFF0 - $EFFF			SYSTEM.ASM
;	* $F000 - $FFE7			(multiple sources)
;		* $F000 - $F014		EQU.ASM
;		* $F000 - $FFE7		T12REV3.ASM
;		* $F066 - $F067		JOUST_MODS.ASM
;		* $F06C - $F06E		JOUST_MODS.ASM
;		* $F320 - $F341		JOUST_MODS.ASM
;		* $F33E - $F341		JOUST_MODS.ASM
;		* $F43D - $F442		JOUST_MODS.ASM
;		* $F4B7 - $F4B8		JOUST_MODS.ASM
;		* $F4C2 - $F4C4		JOUST_MODS.ASM
;		* $F4C5 - $F562		JOUST_MODS.ASM
;		* $F563 - $F5A0		JOUST_MODS.ASM
;		* $F5A1 - $F5EF		JOUST_MODS.ASM
;   * [$FFE8 - $FFEF]		(free)						$0008 bytes
;	* $FFF0 - $FFFF			T12REV3.ASM
;
;	Total Used: $D06E bytes (52.1KB)
;	Total Free: $2F92 bytes (11.9KB)
;

JoustImagesRam				    EQU     $0000
JoustImagesRamEnd   		    EQU     $39C6; was $3B0F

MessagesModuleRam				EQU     $4A50
MessagesModuleRamEnd			EQU     $5EC2; was $5ECF

GameRam					        EQU     $5ED0
GameRamEnd				        EQU     $8FBE; was $DFFF

BasePage1Ram					EQU     $A000
BasePage1RamEnd					EQU     $A03D; was $A03F

BasePage2Ram					EQU     $A040
BasePage2RamEnd					EQU     $A077; was $A07F

BasePage3Ram					EQU     $A080
BasePage3RamEnd					EQU     $A0BC; was $A0BF

BasePage4Ram					EQU     $A0C0

LavaTrollRam                    EQU     $B300

ScratchRam                      EQU     $BC00

CmosRam							EQU     $CC00

WritableCmosRam					EQU     $CD00

SystemVectors                   EQU     $E000
SystemVectorsEnd                EQU     $E694; was $E697

AttModuleRam                    EQU     $D000
AttModuleRamEnd                 EQU     $D6EE

ModificationPauseButton         EQU     $D6EF

IRQHandlerPointer				EQU		$EFF8

; Colors

DisplayColor_11					EQU		$11
DisplayColor_22					EQU		$22
DisplayColor_33					EQU		$33
DisplayColor_88					EQU		$88
DisplayColor_99					EQU		$99
DisplayColor_BB					EQU		$BB