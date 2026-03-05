# Hadoop Hive Analytical Queries

This folder implements "Experiment 3: Working with Hive" to orchestrate database creation, data loading, and MapReduce HiveQL metrics querying.

## 📦 How to Clone this Specific Experiment
To prevent different experiments from getting mixed up, this repository is organized using **Git Tags**. You can download *only* this exact Hive experiment code by running:
```bash
git clone --branch v3.0-hive https://github.com/pmr1234/Hadoop-Installer.git
```
*(If you need the earlier MapReduce WordCount experiment, just change `v3.0-hive` to `v2.0-wordcount`!)*

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

### Interactive Usage (Manual Testing)
If you want to quickly drop into a live database to write **DDL, DML, or DQL** queries yourself (such as `SELECT *`, `JOIN`, or `DROP`), use the shell script provided:
```bat
run_hive_shell.cmd
```
This bypasses the automation and immediately opens an interactive `hive>` prompt inside your terminal!

## 🚀 Uses of Apache Hive
Apache Hive is primarily used for Data Warehousing and Data Engineering on top of Hadoop. Its uses include:
1. 📊 **Data Summarization & Analysis:** Executing complex analytical queries on massive datasets stored in HDFS.
2. 🔄 **ETL (Extract, Transform, Load):** Transforming raw unstructured data (like `students.csv`) into structured tables for business intelligence tools.
3. 🕵️ **Ad-hoc Querying:** Allowing analysts to query Big Data using familiar SQL syntax (HiveQL) without needing to write complex Java MapReduce code!

---

## 🛠️ Key Hive Operations & Commands (With Examples!)
Hive provides various SQL-like operations to manage and analyze your data. Here is a clear breakdown of the commands we used in this experiment:

### 1. 🏗️ DDL (Data Definition Language)
These commands are used to define the metadata schemas (the blueprints) of your databases and tables.
- **`CREATE DATABASE college;`** 
  *What it does:* Creates a new folder structure in HDFS to logically group your tables together.
- **`USE college;`**
  *What it does:* Tells Hive that all subsequent commands should act inside the `college` database.
- **`CREATE TABLE students (...);`**
  *What it does:* Creates the schema for your table, specifying the column names and their data types (like `INT` and `STRING`). It also tells Hive how to parse the data (e.g., separating columns by commas).
- **`DROP TABLE students;`**
  *What it does:* Deletes the table. *Warning:* If it's an internal table, this deletes the underlying data from HDFS too!

### 2. 🚚 DML (Data Manipulation Language)
These commands are used to move and manipulate the actual raw data files.
- **`LOAD DATA LOCAL INPATH 'students.csv' OVERWRITE INTO TABLE students;`**
  *What it does:* Takes your local `students.csv` file from your Windows drive and safely uploads it directly into the correct HDFS folder that belongs to the `students` table. 

### 3. 🔍 DQL (Data Query Language)
These are the powerful analytical commands used to extract insights from your data! Hive converts these directly into MapReduce jobs:
- **`SELECT * FROM students;`**
  *What it does:* Retrieves every single row and column from your table so you can view the entire dataset.
- **`SELECT COUNT(*) FROM students;`**
  *What it does:* Counts the total number of rows (students) inside your table. 
- **`SELECT AVG(marks) FROM students;`**
  *What it does:* Calculates the numerical average of all the values in the `marks` column.
- **`SELECT dept, COUNT(*) FROM students GROUP BY dept;`**
  *What it does:* Groups the rows by their `dept` (Department) column, and then individually counts how many students are in each specific department!
- **`SELECT name, marks FROM students WHERE marks > 80;`**
  *What it does:* Filters the table to only show students who scored higher than 80 marks.

---

## 📁 File Structure & Script Explanations
Here is what each file in this folder actually does:
- 📜 **`hive_queries.hql`**: Contains the actual HiveQL (SQL-like) queries that create the tables, load the CSV data, and perform the data analytics.
- ⚙️ **`init_hdfs.cmd`**: Bootstraps the backend HDFS directories (`/user/hive/warehouse` and `/tmp/hive`) so Hive has a place to securely store its databases.
- 🚀 **`run_hive.cmd`**: The main automated execution wrapper. It configures the Java classpaths, intelligently initializes the Derby database, and seamlessly executes `hive_queries.hql`.
- 🛠️ **`run_hive_native.cmd`**: A specialized debugging script used to cleanly wipe, format, and test the Derby Metastore if it gets corrupted.
- 💻 **`run_hive_shell.cmd`**: Launches the interactive `hive>` CLI so you can type SQL queries manually in real-time!
- 🧰 **`setup_hive.cmd`**: A helper script utilized during the initial Hive installation and environment configuration.

---

## 🌱 How to Create a New Database and a New HQL Script
If you want to move beyond the `college` experiment and create your own custom project, follow these simple steps:

### Part 1: Creating a New Database
You have two easy ways to create a new database:

**Option A: Interactive Shell (Manual)**
1. Double-click `run_hive_shell.cmd` to open the interactive `hive>` prompt.
2. Type `CREATE DATABASE my_new_project;` and press Enter.
3. Type `USE my_new_project;` to switch into it, and start writing your `CREATE TABLE` commands!

**Option B: Automated Script (HQL)**
You can write the database generation command directly into an `.hql` file instead (see Part 2 below).

### Part 2: Crafting a New Automated HQL Script
If you want to completely automate a new sequence of queries (just like we did for this assignment), you can write a new script:

1. Create a new file (e.g., `my_queries.hql`) using a text editor like VS Code or Notepad.
2. Add your custom SQL queries to the file:
```sql
CREATE DATABASE IF NOT EXISTS my_new_project;
USE my_new_project;

CREATE TABLE employee (id INT, job STRING);
-- Add more SQL commands here...
```

**To run your custom script:**
1. Open the existing `run_hive.cmd` wrapper script in your text editor.
2. Scroll to the very bottom where it says:
   `java -cp "%CP%" org.apache.hadoop.hive.cli.CliDriver -f hive_queries.hql`
3. Change `hive_queries.hql` to `my_queries.hql` and save the script!
4. Double-click `run_hive.cmd` and watch your custom queries execute autonomously!

---

## 🧠 How Hive Actually Works (Architecture & Hadoop Integration)
Apache Hive acts as a data warehouse infrastructure built on top of Hadoop. It facilitates reading, writing, and managing massive datasets residing in distributed storage (HDFS) via **SQL (HiveQL)**.

When you type a query like `SELECT AVG(marks) FROM students;`, here is exactly what happens under the hood:

### 1. The Execution Pipeline
- **User Interface / CLI:** You enter the query into the interactive `hive>` shell.
- **Driver & Compiler:** The internal Hive Driver receives the query and sends it to the Compiler. The Compiler checks the syntax and queries the **Metastore** to verify that the table actually exists.
- **Metastore Database:** This is the "brain" of Hive (we used **Apache Derby** in our experiment). The Metastore doesn't store the actual data (like the student names); instead, it stores the *schema* (the blueprints, table names, column types, and HDFS file paths).
- **Execution Engine:** If the query is valid, the Compiler generates an Execution Plan (Directed Acyclic Graph) and submits it to the Execution Engine.
- **MapReduce Translation:** The Engine translates your simple SQL command into a highly complex, optimized Java MapReduce job and sends it to **YARN** (Hadoop's resource manager).
- **HDFS Processing:** YARN executes the Mappers and Reducers across your cluster, pulling the raw data from the HDFS blocks (e.g., your `students.csv`).
- **Result Delivery:** The final reduced analytical output is sent back up the chain and printed to your screen.

### 2. Internal vs. External Tables
When creating a table in Hive, you must decide how Hive will manage the underlying raw data file:
- **Internal (Managed) Tables:** Hive takes full physical ownership of the data. When you load a `.csv` file, Hive physically *moves* it into its own HDFS folder (e.g., `/user/hive/warehouse`). If you run `DROP TABLE students;`, Hive deletes BOTH the schema from its Metastore AND the actual `.csv` file from HDFS. Your data is gone forever!
- **External Tables:** You put the data in HDFS yourself, and simply tell Hive to "point" its schema at that folder using the `LOCATION` command. If you run `DROP TABLE students;`, Hive only deletes the blueprint from its Metastore. The actual data file sits safely untouched in HDFS!

### 3. Data Visualization in Hadoop via Hive (Schema-On-Read)
Hadoop HDFS is historically blind. It just sees blocks of raw bytes (0s and 1s). It has no concept of rows, columns, names, or integers. Hive acts as the **Visualizer / Schema-On-Read** layer for Hadoop:

Unlike traditional SQL databases (like Oracle or MySQL) which rigidly enforce strict rules *before* you insert data (Schema-On-Write), Hive lets you dump raw, dirty `csv` files into HDFS immediately. It only applies the "table structure" at the exact moment you run a `SELECT` query.

Because Hive seamlessly creates this structured visualization layer, modern Business Intelligence (BI) tools (like Tableau or PowerBI) can connect directly to Hive via JDBC. To the BI tool, Hadoop just looks like a massive standard relational database!
