#!/bin/bash
# 
# File. myquery2.sh
# Date. 12/13/2020
# Description.
#       MyQuery - A database query tool implemented in Java/Jdbc/Swing.
#
SDB=0
if [ $# -ge 1 ]
then
   if [ $1 == "sdb" ]
   then
      SDB=1
   else
      echo "usage myquery2.sh [sdb]"
      exit 2
   fi
fi

cd "`dirname $0`"

# ── JAVA_HOME resolution: env → PATH → ini ────────────────────────────────
JAVA_CMD=""
INI_FILE="myquery.ini"

# Step 1: $JAVA_HOME from environment
if [ -n "${JAVA_HOME:-}" ] && [ -d "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
  JAVA_CMD="$JAVA_HOME/bin/java"
fi

# Step 2: java on PATH
if [ -z "$JAVA_CMD" ] && command -v java >/dev/null 2>&1; then
  JAVA_CMD="java"
fi

# Step 3: JAVA_HOME from ini file
if [ -z "$JAVA_CMD" ]; then
  if [ -f "$INI_FILE" ]; then
    while IFS='=' read -r f1 f2; do
      if [ "$f1" == "JAVA_HOME" ]; then
        JAVA_HOME=$f2
        break
      fi
    done <"$INI_FILE"
    if [ -n "$JAVA_HOME" ] && [ -d "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
      JAVA_CMD="$JAVA_HOME/bin/java"
    fi
  fi
fi

if [ -z "$JAVA_CMD" ]; then
  echo "ERROR: JAVA_HOME is not set."
  echo "  Set JAVA_HOME in the environment, ensure java is on PATH, or edit $INI_FILE"
  exit 1
fi

[ -n "${JAVA_HOME:-}" ] && PATH=$JAVA_HOME/bin:$PATH
ORIG_CP=$CLASSPATH
CLASSPATH=./:myquery.jar

CLASSPATH=$CLASSPATH:misc/gson-2.8.6.jar
CLASSPATH=$CLASSPATH:misc/log4j-api-2.17.1.jar
CLASSPATH=$CLASSPATH:misc/log4j-core-2.17.1.jar
CLASSPATH=$CLASSPATH:misc/log4j-slf4j-impl-2.17.1.jar
CLASSPATH=$CLASSPATH:misc/guava-20.0.jar
CLASSPATH=$CLASSPATH:misc/slf4j-api-1.7.36.jar
# CLASSPATH=$CLASSPATH:misc/language-detector-0.5.jar
# CLASSPATH=$CLASSPATH:misc/slf4j-api-1.7.36.jar
# CLASSPATH=$CLASSPATH:misc/slf4j-simple-1.7.36.jar
# CLASSPATH=$CLASSPATH:misc/tika-core-1.0.18.jar
# CLASSPATH=$CLASSPATH:misc/tika-langdetect-1.0.18.jar
CLASSPATH=$CLASSPATH:misc/tika-core-1.24.jar
CLASSPATH=$CLASSPATH:misc/tika-parsers-1.24.jar
CLASSPATH=$CLASSPATH:misc/tika-langdetect-1.24.jar
CLASSPATH=$CLASSPATH:misc/language-detector-0.6.jar
CLASSPATH=$CLASSPATH:misc/sqlite-jdbc-3.47.1.0.jar
CLASSPATH=$CLASSPATH:misc/orai18n.jar
CLASSPATH=$CLASSPATH:misc/orai18n-mapping.jar
CLASSPATH=$CLASSPATH:misc/orai18n-lcsd.jar
if [ $SDB -eq 1 ]
then
   JDBC_CLASSPATH=jdbc/sdb-jdbc-2.59.0.jar
else
   JDBC_CLASSPATH=jdbc/postgresql-42.7.3.jar
fi
JDBC_CLASSPATH=$JDBC_CLASSPATH:jdbc/ojdbc11.jar
JDBC_CLASSPATH=$JDBC_CLASSPATH:jdbc/mysql-connector-j-9.0.0.jar
CLASSPATH=$CLASSPATH:$JDBC_CLASSPATH
printf  "%s`$JAVA_CMD -fullversion`"
printf  "jdbc drivers: %s\n" $JDBC_CLASSPATH
$JAVA_CMD -cp $CLASSPATH -Xms2g -Xmx8g -Dlog4j.configurationFile=log4j2.xml -Dmyquery.config=myquery.xml myquery.MyQuery
rc=$?
if [ $rc -eq 127 ]; then
  # exit code 127 - command not found 
  echo "The specified JAVA path does not exist. Check the setting of JAVA_HOME in the script."
fi
CLASSPATH=$ORIG_CP
echo "The application exits with code" $rc
exit $rc
