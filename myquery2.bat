@REM File. myquery2.bat
@REM Date. 06/25/2026
@REM Description.
@REM       MyQuery - A database query tool implemented in Java/Jdbc/Swing.
@REM       JAVA_HOME resolution: env → PATH → myquery.ini
@ECHO off
SETLOCAL EnableDelayedExpansion

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
REM ==============================
REM Ora*i18n LCSD jars (Oracle proprietary — excluded from distribution).
REM Users who need Oracle LCSD can drop these jars into misc/ and uncomment:
REM SET CLASSPATH=%CLASSPATH%;misc\orai18n.jar
REM SET CLASSPATH=%CLASSPATH%;misc\orai18n-mapping.jar
REM SET CLASSPATH=%CLASSPATH%;misc\orai18n-lcsd.jar

REM All JDBC drivers (PostgreSQL, SDB, Oracle, MySQL) are loaded in isolation by
REM the application via <jarfile> in myquery.xml, so drivers that share class
REM names (e.g. PostgreSQL and SDB, both defining org.postgresql.Driver) don't
REM clash and any mix of them can be connected to at the same time.

ECHO JDBC drivers (isolated): jdbc\postgresql-*.jar, jdbc\sdb-jdbc-*.jar, jdbc\ojdbc*.jar, jdbc\mysql-connector-j-*.jar

"%JAVA_CMD%" -cp %CLASSPATH% -Xms2g -Xmx8g -Dlog4j.configurationFile=log4j2.xml myquery.MyQuery
SET RC=%ERRORLEVEL%
IF %RC% EQU 127 (
    ECHO The specified JAVA path does not exist. Check the setting of JAVA_HOME in myquery.ini.
)
ECHO The application exits with code %RC%
ENDLOCAL
EXIT /b %RC%
