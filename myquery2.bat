@REM File. myquery2.bat
@REM Date. 06/25/2026
@REM Description.
@REM       MyQuery - A database query tool implemented in Java/Jdbc/Swing.
@REM       JAVA_HOME resolution: env → PATH → myquery.ini
@ECHO off
SETLOCAL EnableDelayedExpansion

IF "%1" == "" (
   SET SDB=0
) ELSE IF "%1" == "sdb" (
   SET SDB=1
) ELSE (
   ECHO usage myquery2.bat [sdb]
   EXIT /b 2
)

REM Change to the directory containing this script
cd /D "%~dp0"

REM ── JAVA_HOME resolution: env → PATH → ini ──────────────────────────────
SET JAVA_CMD=
SET INI_FILE=myquery.ini

REM Step 1: %JAVA_HOME% from environment
IF NOT "%JAVA_HOME%" == "" (
   IF EXIST "%JAVA_HOME%\bin\java.exe" (
      SET "JAVA_CMD=%JAVA_HOME%\bin\java.exe"
   )
)

REM Step 2: java on PATH
IF "%JAVA_CMD%" == "" (
   WHERE java >nul 2>&1
   IF NOT ERRORLEVEL 1 SET "JAVA_CMD=java"
)

REM Step 3: JAVA_HOME from ini file
IF "%JAVA_CMD%" == "" (
   IF EXIST "%INI_FILE%" (
      FOR /F "usebackq tokens=1,2 delims==" %%A IN ("%INI_FILE%") DO (
         IF "%%A" == "JAVA_HOME" (
            SET "JAVA_HOME=%%B"
         )
      )
      IF NOT "!JAVA_HOME!" == "" (
         IF EXIST "!JAVA_HOME!\bin\java.exe" (
            SET "JAVA_CMD=!JAVA_HOME!\bin\java.exe"
         )
      )
   )
)

IF "%JAVA_CMD%" == "" (
   ECHO ERROR: JAVA_HOME is not set.
   ECHO   Set JAVA_HOME in the environment, ensure java is on PATH, or edit %INI_FILE%
   EXIT /b 1
)

ECHO JAVA_CMD=%JAVA_CMD%
"%JAVA_CMD%" -fullversion

SET CLASSPATH=.\;myquery.jar
SET CLASSPATH=%CLASSPATH%;misc\gson-2.8.6.jar
SET CLASSPATH=%CLASSPATH%;misc\log4j-api-2.17.1.jar
SET CLASSPATH=%CLASSPATH%;misc\log4j-core-2.17.1.jar
SET CLASSPATH=%CLASSPATH%;misc\guava-20.0.jar
SET CLASSPATH=%CLASSPATH%;misc\slf4j-api-1.7.36.jar
SET CLASSPATH=%CLASSPATH%;misc\tika-core-1.24.jar
SET CLASSPATH=%CLASSPATH%;misc\tika-parsers-1.24.jar
SET CLASSPATH=%CLASSPATH%;misc\tika-langdetect-1.24.jar
SET CLASSPATH=%CLASSPATH%;misc\language-detector-0.6.jar
SET CLASSPATH=%CLASSPATH%;misc\sqlite-jdbc-3.47.1.0.jar
SET CLASSPATH=%CLASSPATH%;misc\orai18n.jar
SET CLASSPATH=%CLASSPATH%;misc\orai18n-mapping.jar
SET CLASSPATH=%CLASSPATH%;misc\orai18n-lcsd.jar

IF %SDB% == 1 (
    SET JDBC_CLASSPATH=jdbc\sdb-jdbc-2.59.0.jar
) ELSE (
    SET JDBC_CLASSPATH=jdbc\postgresql-42.7.3.jar
)
SET JDBC_CLASSPATH=%JDBC_CLASSPATH%;jdbc\ojdbc11.jar
SET JDBC_CLASSPATH=%JDBC_CLASSPATH%;jdbc\mysql-connector-j-9.0.0.jar
SET CLASSPATH=%CLASSPATH%;%JDBC_CLASSPATH%

ECHO JDBC drivers: %JDBC_CLASSPATH%

"%JAVA_CMD%" -cp %CLASSPATH% -Xms2g -Xmx8g -Dlog4j.configurationFile=log4j2.xml -Dmyquery.config=myquery2.xml myquery.MyQuery
SET RC=%ERRORLEVEL%
IF %RC% EQU 127 (
    ECHO The specified JAVA path does not exist. Check the setting of JAVA_HOME in myquery.ini.
)
ECHO The application exits with code %RC%
ENDLOCAL
EXIT /b %RC%
