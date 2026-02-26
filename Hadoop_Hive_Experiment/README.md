# Hadoop Hive Analytical Queries

This folder implements "Experiment 3: Working with Hive" to orchestrate database creation, data loading, and MapReduce HiveQL metrics querying.

## Requirements
Unlike Java MapReduce, Apache Hive 3.1.3 relies heavily on legacy JVM frameworks and requires an explicitly managed Classpath to run natively on Windows without Git Bash/Cygwin. 

- Java 8
- Hadoop 3.4.2 (Running via `start-dfs.cmd` and `start-yarn.cmd`)
- Apache Hive 3.1.3 Extracted to `F:\apache-hive-3.1.3-bin`  
- *Note:* Hive 3 requires `commons-collections-3.2.2.jar` to be manually added to its `lib/` directory if running against modern Hadoop distributions.

## How to Run

1. Make sure your Hadoop NameNode and DataNode are running.
2. Execute the wrapper script:

```bat
run_hive.cmd
```

**What the wrapper does naturally:**
1. Dynamically detects and bridges the Hadoop 3 and Hive 3 classpath arrays together.
2. Isolates the Local Derby Metastore database (`metastore_db`) within this directory.
3. Initializes the metastore schemas silently if it's the first execution.
4. Orchestrates the `hive_queries.hql` file to parse `students.csv` into HDFS.
5. Prints the analytical MapReduce output of the `.csv` file.

## Uses of Apache Hive
Apache Hive is primarily used for Data Warehousing and Data Engineering on top of Hadoop. Its uses include:
1. **Data Summarization & Analysis:** Executing complex analytical queries on massive datasets stored in HDFS.
2. **ETL (Extract, Transform, Load):** Transforming raw unstructured data into structured tables for business intelligence tools.
3. **Ad-hoc Querying:** Allowing analysts and data scientists to query Big Data using familiar SQL syntax (HiveQL) without needing to write Java MapReduce code.

## Key Hive Operations
Hive provides various SQL-like operations to manage and analyze data:
1. **DDL (Data Definition Language):** Operations like `CREATE DATABASE`, `CREATE TABLE`, `ALTER TABLE`, and `DROP TABLE` to define the metadata schemas.
2. **DML (Data Manipulation Language):** Operations like `LOAD DATA`, `INSERT INTO`, and `UPDATE` to populate tables with data from local file systems or HDFS.
3. **DQL (Data Query Language):** Powerful analytical operations like `SELECT`, `GROUP BY`, `ORDER BY`, `JOIN`, and Aggregation functions (`COUNT`, `AVG`, `MAX`, `MIN`) to derive insights from data.
4. **Partitioning & Bucketing:** Advanced operations to split large datasets into manageable directories for optimized query performance.
