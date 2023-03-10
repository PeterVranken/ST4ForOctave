@echo off
:: Enforce this directory to be the current working directory when Octave is started. Only
:: this way the file javaclasspath.txt becomes effective.
cd %~dp0

setlocal

:: Octave requires an environment variable to specify, which Java runtime to use.
::   TODO Consider adjusting the path to your Java installation.
REM set JAVA_HOME=C:\Program Files\Java\openlogic-openjdk-8u362-b09-windows-64\jre
REM set PATH=%JAVA_HOME%\bin;%PATH%

:: TODO Consider a local modification of the search path, edit the installation path of
:: Octave and uncomment the next statement.
REM set PATH=%PATH%;C:\Program Files\Octave\octave-7.1.0-w64;C:\Program Files\Octave\octave-5.2.0-w64-64;C:\Program Files\Octave\octave-4.4.1-w64;C:\Program Files\Octave\octave-4.2.0-w64

:: Check for Octave.
set tool=octave
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
call octave
