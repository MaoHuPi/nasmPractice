@REM Step-1 Download Code Blocks - 32 Bit Windows with MingW
@REM https://www.codeblocks.org/downloads/binaries/

@REM Step-2 Download NASM - 32 Bit Windows
@REM https://www.nasm.us/

@REM Step-3 Extract NASM Installer in C:\Program Files (x86)\CodeBlocks\MinGW\bin

@REM Step-4 Write following Assembly Code and save in d:\demo1.asm
@REM global  _main
@REM         extern  _printf
@REM         section .text
@REM   _main:
@REM         push    message
@REM         call    _printf
@REM         add     esp, 4
@REM         ret
@REM    message:
@REM         db      'Hello World From Dr. Parag Shukla', 0

@REM Step-5 Open Command Prompt and use cd command to change directory to bin
@REM cd "C:\Program Files (x86)\CodeBlocks\MinGW\bin"

@REM Step-6 Generate Object File 
@REM nasm -f win32 d:\demo1.asm -o d:\demo1.obj

@REM Step-7 Generate Exe file using GCC
@REM gcc d:\demo1.obj -o d:\demo1.exe

@REM Step-8 Run Exe file to produce the output
@REM d:\demo1.exe

set path=%cd%
set /p fileName="file name: "
set filePath=%path%\%fileName%

cd "C:\Program Files\CodeBlocks\MinGW\bin"
nasm -f win64 "%filePath%.asm" -w+all -o "%filePath%.obj" 
gcc "%filePath%.obj" -o "%filePath%.exe"

pause