@echo off
setlocal

set "PROJECT=%~1"
set "MODULE=%~2"

if not defined PROJECT goto usage
if not defined MODULE goto usage

echo ========================================
echo Testing %PROJECT% - %MODULE%
echo ========================================
echo.

if /I "%PROJECT%"=="Project1" goto project1
if /I "%PROJECT%"=="Project2" goto project2
if /I "%PROJECT%"=="Project3" goto project3

echo ERROR: Unknown project "%PROJECT%".
goto usage

:project1
set "SIM_DIR=Project1\sim"
set "TB=Project1\tb\%MODULE%_tb.v"
set "OUTPUT=%SIM_DIR%\%MODULE%.vvp"
set "TOP=%MODULE%_tb"
if not exist "%TB%" goto missing_testbench
if not exist "%SIM_DIR%" mkdir "%SIM_DIR%"
echo [%TIME%] Compiling %MODULE%...
iverilog -g2012 -o "%OUTPUT%" Project1\src\*.v "%TB%"
if errorlevel 1 goto compile_failed
goto run_simulation

:project2
set "SIM_DIR=Project2\sim"
set "TB=Project2\tb\%MODULE%_tb.v"
set "OUTPUT=%SIM_DIR%\%MODULE%.vvp"
set "TOP=%MODULE%_tb"
if not exist "%TB%" goto missing_testbench
if not exist "%SIM_DIR%" mkdir "%SIM_DIR%"
echo [%TIME%] Compiling %MODULE%...
iverilog -g2012 -o "%OUTPUT%" Project1\src\*.v Project2\src\*.v "%TB%"
if errorlevel 1 goto compile_failed
goto run_simulation

:project3
if /I "%MODULE%"=="ram16k" goto ram16k_skipped
set "SIM_DIR=Project3\sim"
set "TB=Project3\tb\%MODULE%_tb.v"
set "OUTPUT=%SIM_DIR%\%MODULE%.vvp"
if not exist "%TB%" goto missing_testbench
if not exist "%SIM_DIR%" mkdir "%SIM_DIR%"

rem Use minimal dependency lists for the 32-bit modules. Selecting the testbench
rem top prevents Icarus from elaborating unrelated top-level legacy RAM modules.
if /I "%MODULE%"=="reg32" goto project3_reg32
if /I "%MODULE%"=="regfile" goto project3_regfile

rem Legacy Project3 tests: RAM16K is deliberately not included.
rem Keep legacy naming compatibility here; reg32/regfile use targeted top-level builds below.
echo [%TIME%] Compiling %MODULE%...
iverilog -g2012 -o "%OUTPUT%" ^
    Project1\src\*.v ^
    Project2\src\*.v ^
    Project3\src\dff.v ^
    Project3\src\bit.v ^
    Project3\src\reg.v ^
    Project3\src\ram8.v ^
    Project3\src\ram64.v ^
    Project3\src\ram512.v ^
    Project3\src\pc.v ^
    Project3\src\reg32.v ^
    Project3\src\regfile.v ^
    "%TB%"
if errorlevel 1 goto compile_failed
goto run_simulation

:project3_reg32
set "TOP=Reg32_tb"
echo [%TIME%] Compiling %MODULE% with only required dependencies...
iverilog -g2012 -s "%TOP%" -o "%OUTPUT%" ^
    Project1\src\nand.v ^
    Project1\src\not.v ^
    Project1\src\and.v ^
    Project1\src\or.v ^
    Project1\src\mux.v ^
    Project3\src\dff.v ^
    Project3\src\bit.v ^
    Project3\src\reg.v ^
    Project3\src\reg32.v ^
    "%TB%"
if errorlevel 1 goto compile_failed
goto run_simulation

:project3_regfile
set "TOP=RegFile_tb"
echo [%TIME%] Compiling %MODULE% with only required dependencies...
iverilog -g2012 -s "%TOP%" -o "%OUTPUT%" ^
    Project1\src\nand.v ^
    Project1\src\not.v ^
    Project1\src\and.v ^
    Project1\src\or.v ^
    Project1\src\mux.v ^
    Project1\src\and8way.v ^
    Project1\src\decoder.v ^
    Project1\src\mux4way16.v ^
    Project1\src\mux16.v ^
    Project1\src\mux8way16.v ^
    Project1\src\mux8way32.v ^
    Project3\src\dff.v ^
    Project3\src\bit.v ^
    Project3\src\reg.v ^
    Project3\src\reg32.v ^
    Project3\src\regfile.v ^
    "%TB%"
if errorlevel 1 goto compile_failed
goto run_simulation

:run_simulation
echo Compilation successful.
echo.
echo [%TIME%] Starting simulation...
echo.
vvp "%OUTPUT%"
set "SIM_EXIT=%ERRORLEVEL%"
if not "%SIM_EXIT%"=="0" goto simulation_failed

echo.
echo ========================================
echo TEST COMPLETED: %PROJECT% - %MODULE%
echo ========================================
exit /b 0

:compile_failed
echo.
echo ========================================
echo COMPILATION FAILED: %PROJECT% - %MODULE%
echo ========================================
exit /b 1

:simulation_failed
echo.
echo ========================================
echo SIMULATION FAILED: %PROJECT% - %MODULE% (exit %SIM_EXIT%)
echo ========================================
exit /b %SIM_EXIT%

:missing_testbench
echo ERROR: Testbench not found: %TB%
exit /b 1

:ram16k_skipped
echo RAM16K test is intentionally excluded from this runner.
echo Its legacy simulation is not required for the RV32I CPU roadmap.
exit /b 2

:usage
echo Usage: run_test.bat Project1^|Project2^|Project3 MODULE
echo Example: run_test.bat Project2 alu32
exit /b 1
