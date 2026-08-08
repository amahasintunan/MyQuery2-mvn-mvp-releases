# MyQuery2 v2.0 MVP — JDBC Desktop Database Query Tool

A Java Swing JDBC desktop query tool for Oracle, PostgreSQL, MySQL, SQLite, and SDB.
**MVP (Minimum Viable Product) edition** — subset of features for essential database work.

## What's in this package

| File | Description |
|------|-------------|
| `myquery.jar` | Application JAR |
| `myquery2.sh` | Linux/Mac launcher |
| `myquery2.bat` | Windows launcher |
| `myquery.xml` | Application config (JDBC drivers) |
| `myquery2.xml` | Application config (alternate) |
| `myquery.ini` | JAVA_HOME config |
| `log4j2.xml` | Logging config |
| `jdbc/` | JDBC driver jars (PostgreSQL, MySQL, SQLite) |
| `misc/` | Runtime dependency jars (Tika, Log4j, Gson, Guava) |

## Requirements

- JDK 17+
- A supported database server (Oracle, PostgreSQL, MySQL, SQLite, SDB)

## Quick start

```bash
# Linux/macOS
./myquery2.sh

# Windows
.\myquery2.bat
```

If `java` is not on your PATH, set `JAVA_HOME` in `myquery.ini`.

## MVP Features

This MVP build includes:
- JDBC connections to Oracle, PostgreSQL, MySQL, SQLite, SDB
- SQL query editor with multi-statement support
- Paginated query results
- Export to XML, CSV, HTML
- Schema/Tables/Views navigation
- Basic CRUD (Insert/Update/Delete) on query results
- Content/Attributes/DDL views
- Tablespace/Role/User browsing
- Disk usage charts (Oracle)

## Disabled features (MVP)

The following features are disabled in this MVP edition:
- Detect Encoding (files)
- Explain Plan / Execution Plan
- Long Running Queries
- Lock Info
- List Statistics
- Bind Variables
- Import / Export / Transform
- Detect / Translate / Dump / Inspect Content
- Content View / Document View / Download
- Monitor

For full feature access, use the standard [MyQuery2-mvn-releases](https://github.com/amahasintunan/MyQuery2-mvn-releases) edition.

## Oracle support (optional)

Oracle JDBC driver is NOT bundled (Oracle OTN license). To enable Oracle connections:

1. Download `ojdbc11.jar` from [Oracle JDBC](https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)
2. Place it in the `jdbc/` directory
3. The launcher scripts auto-detect it
