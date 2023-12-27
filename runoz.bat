@echo off
setlocal enabledelayedexpansion

REM Set the directory where Oz files are located
REM set "oz_directory=C:\Path\To\Your\Directory"
set "oz_directory=%cd%"
REM Clear any existing .ozf files
del /Q "%oz_directory%\*.ozf" 2>NUL

REM Compile all .oz files in the directory
for %%i in ("%oz_directory%\*.oz") do (
    ozc -c "%%~fi"
)

REM Check if there is only one file
for /f %%i in ('dir /b /a-d "%oz_directory%\*.ozf" ^| find /c /v ""') do (
    set "file_count=%%i"
)

REM If there's only one file, run it automatically
if %file_count% equ 1 (
    for %%i in ("%oz_directory%\*.ozf") do (
        ozengine "%%~fi"
    )
    exit /b
)


REM List compiled .ozf files with numbers
set "counter=0"
echo Compiled Oz files:
for %%i in ("%oz_directory%\*.ozf") do (
    set /a "counter+=1"
    echo !counter!. %%~nxi
)
set "counter=0"
REM Prompt user to select a file by number
set /p "file_number=Enter the number of the file to run: "

REM Run the selected .ozf file using ozengine
set "selected_file="
for %%i in ("%oz_directory%\*.ozf") do (
    set /a "counter+=1"
    if !counter! equ %file_number% (
        set "selected_file=%%~nxi"
    )
)

if defined selected_file (
    ozengine "%oz_directory%\%selected_file%"
) else (
    echo Invalid file number selected.
)