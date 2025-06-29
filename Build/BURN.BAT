pushd .

cd Source
copy /b /y *.asm ..\GeneratedSource

cd ..\GeneratedSource
c:\bin\aswcurr\bin\asl make.asm -o ..\Intermediate\joust.p

cd ..\Intermediate
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_1b_3006-13.e4 -l 00 -r $0000-$0FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_2b_3006-14.c4 -l 00 -r $1000-$1FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_3b_3006-15.a4 -l 00 -r $2000-$2FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_4b_3006-16.e5 -l 00 -r $3000-$3FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_5b_3006-17.c5 -l 00 -r $4000-$4FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_6b_3006-18.a5 -l 00 -r $5000-$5FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_7b_3006-19.e6 -l 00 -r $6000-$6FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_8b_3006-20.c6 -l 00 -r $7000-$7FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_9b_3006-21.a6 -l 00 -r $8000-$8FFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_10b_3006-22.a7 -l 00 -r $D000-$DFFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_11b_3006-23.c7 -l 00 -r $E000-$EFFF
C:\bin\aswcurr\bin\p2bin joust.p joust_rom_12b_3006-24.e7 -l 00 -r $F000-$FFFF

popd
