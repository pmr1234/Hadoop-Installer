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
