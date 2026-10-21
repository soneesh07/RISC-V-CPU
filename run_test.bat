@echo off
setlocal

set PROJECT=%1
set MODULE=%2

echo ========================================
echo Testing %PROJECT% - %MODULE%
echo ========================================
echo.

if /I "%PROJECT%"=="Project1" (
    if not exist "Project1\sim" mkdir "Project1\sim"

    echo [%TIME%] Starting compilation...

    iverilog -o "Project1\sim\%MODULE%.vvp" ^
        Project1\src\*.v ^
        Project1\tb\%MODULE%_tb.v

    if errorlevel 1 goto compile_failed

    echo Compilation successful.
    echo.
    echo [%TIME%] Starting simulation...
    echo.

    vvp "Project1\sim\%MODULE%.vvp"
    goto simulation_done

) else if /I "%PROJECT%"=="Project2" (
    if not exist "Project2\sim" mkdir "Project2\sim"

    echo [%TIME%] Starting compilation...

    iverilog -o "Project2\sim\%MODULE%.vvp" ^
        Project1\src\*.v ^
        Project2\src\*.v ^
        Project2\tb\%MODULE%_tb.v

    if errorlevel 1 goto compile_failed

    echo Compilation successful.
    echo.
    echo [%TIME%] Starting simulation...
    echo.

    vvp "Project2\sim\%MODULE%.vvp"
    goto simulation_done

) else if /I "%PROJECT%"=="Project3" (
    if not exist "Project3\sim" mkdir "Project3\sim"

    echo [%TIME%] Starting compilation...

    iverilog -o "Project3\sim\%MODULE%.vvp" ^
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
        Project3\tb\%MODULE%_tb.v

    if errorlevel 1 goto compile_failed

    echo Compilation successful.
    echo.
    echo [%TIME%] Starting simulation...
    echo.

    vvp "Project3\sim\%MODULE%.vvp"
    goto simulation_done

) else if /I "%PROJECT%"=="Project4" (
    if not exist "Project4\sim" mkdir "Project4\sim"

    echo [%TIME%] Starting compilation...

    iverilog -o "Project4\sim\%MODULE%.vvp" ^
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
        Project4\src\*.v ^
        Project4\tb\%MODULE%_tb.v

    if errorlevel 1 goto compile_failed

    echo Compilation successful.
    echo.
    echo [%TIME%] Starting simulation...
    echo.

    vvp "Project4\sim\%MODULE%.vvp"
    goto simulation_done

) else (
    echo Unknown project: %PROJECT%
    exit /b 1
)

:compile_failed
echo.
echo ========================================
echo COMPILATION FAILED
echo ========================================
exit /b 1

:simulation_done
if errorlevel 1 (
    echo.
    echo ========================================
    echo SIMULATION FAILED
    echo ========================================
    exit /b 1
)

echo.
echo ========================================
echo TEST COMPLETED
echo ========================================

endlocal