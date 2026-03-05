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
