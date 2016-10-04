@echo off
:: Enforce this directory to be the current working directory when Octave is started. Only
:: this way the file javaclasspath.txt becomes effective.
cd %~dp0
pwd

:: Check for Octave.
set tool=octave.bat
where %tool% >nul 2>&1
if ERRORLEVEL 1 (
    echo Tool %tool% is either not installed or not in the Windows search PATH.
    echo   Starting Octave with the Java class path appropriate for the sample code found here
    echo requires that %tool% is found via the search path! Consider extending your PATH
    echo variable.
    pause -1
    goto :eof
)
set tool=

:: Run Octave. Since we do this from here is the file javaclasspath.txt evaluated. See
:: https://www.gnu.org/software/octave/doc/v4.0.1/How-to-make-Java-classes-available_003f.html
:: for more details.
call octave.bat
