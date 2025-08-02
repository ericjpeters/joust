pushd .

cd Source
copy /b /y *.asm ..\GeneratedSource

cd ..\GeneratedSource
c:\bin\aswcurr\bin\asl -L make.asm -o ..\Intermediate\joust.p
c:\bin\aswcurr\bin\asl -L decoder_roms.asm -o ..\Intermediate\decoder.p
c:\bin\aswcurr\bin\asl -L VSNDRM4.ASM -o ..\Intermediate\vsndrm4.p

cd ..\Intermediate
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_1b_3006-13.e4 -l 00 -r $0000-$0FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_2b_3006-14.c4 -l 00 -r $1000-$1FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_3b_3006-15.a4 -l 00 -r $2000-$2FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_4b_3006-16.e5 -l 00 -r $3000-$3FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_5b_3006-17.c5 -l 00 -r $4000-$4FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_6b_3006-18.a5 -l 00 -r $5000-$5FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_7b_3006-19.e6 -l 00 -r $6000-$6FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_8b_3006-20.c6 -l 00 -r $7000-$7FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_9b_3006-21.a6 -l 00 -r $8000-$8FFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_10b_3006-22.a7 -l 00 -r $D000-$DFFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_11b_3006-23.c7 -l 00 -r $E000-$EFFF
c:\bin\aswcurr\bin\p2bin joust.p joust_rom_12b_3006-24.e7 -l 00 -r $F000-$FFFF
c:\bin\aswcurr\bin\p2bin decoder.p decoder_rom_4.3g -r $0000-$01FF
c:\bin\aswcurr\bin\p2bin decoder.p decoder_rom_6.3c -r $0200-$03FF
c:\bin\aswcurr\bin\p2bin vsndrm4.p video_sound_rom_4_std_780.ic12 -l 00 -r $F000-$FFFF

copy /b /y *.* \\DESKTOP-GC7QGJP\joust\

popd

