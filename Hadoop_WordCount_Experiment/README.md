# Hadoop WordCount & File Processing

This project implements the "Word Count & File Processing" MapReduce assignment on Apache Hadoop. It contains two consecutive MapReduce analytical jobs written in Java:
1. **Word Count**: Counts the frequency of all words in an input text file.
2. **Group By Frequency**: Takes the output of the Word Count job, and groups all words that have the exact same frequency, sorted by length/occurrence.

## Structure
- `wc/src/`: Contains the MapReduce Mapper, Reducer, and Driver `.java` files for both tasks.
- `wc/classes/`: (Auto-generated) Contains the compiled `.class` binaries.
- `wc/exp2_wc_groupby.jar`: (Auto-generated) The packaged Maven/Ant equivalent archive for Hadoop distribution.
- `run_wordcount.cmd`: A unified wrapper script to compile code, provision HDFS namespaces, and run everything on new data in your Windows environment.

## Requirements & Setup
This project runs entirely locally on a Windows machine. You must have:
- **Java 8** (e.g., `jdk1.8.0_481` installed to `C:\Program Files\Java`)
- **Git Bash / Git for Windows**
- **Hadoop (Tested on v3.4.2)**

### 🚨 Hadoop Installer Download
Hadoop is an enormous 1.5 GB framework that is too large to exist directly inside this Git repository. You must install the Hadoop binaries to run this assignment.
1. Download Hadoop 3.4.2 natively compiled for Windows from Apache or GitHub (e.g., [cdarlint/winutils](https://github.com/cdarlint/winutils) or Apache mirrors).
2. Extract the `.tar.gz` archive to a high-level drive path to avoid maximum path errors (e.g., `F:\hadoop-3.4.2\hadoop-3.4.2`).
3. Ensure `start-dfs.cmd` and `start-yarn.cmd` have been executed to start NameNode and DataNode daemons before running this MapReduce project. 

## How to Run the Assignment

You can run this MapReduce architecture against **any text file** dynamically using the generated wrapper.

1. Clone this repository.
2. Ensure Hadoop services are running (`jps` command should show NameNode, DataNode, and ResourceManager).
3. Provide a path to any sample `.txt` data file to the wrapper script:

```bat
# Execute MapReduce on an existing folder of sample text
run_wordcount.cmd hadoop_input\sample.txt
```

### Expected Output
The wrapper will format and upload the file to HDFS, then print the MapReduce analytical outputs to your console:

```text
[5/8] Running WordCount MapReduce Job...
...
[6/8] WordCount Output:
apple	3
banana	2
grape	2
orange	2

[7/8] Running Group By Frequency MapReduce Job...
...
[8/8] Group By Frequency Output:
2	orange grape banana 
3	apple 
```

## Advanced Usage

### Uploading Other Files to Hadoop (CSV, XLS, MP4, etc.)
Hadoop Distributed File System (HDFS) does not care about file extensions; it treats all files as raw bytes. You can upload **any type of file** to Hadoop the exact same way you upload `.txt` files using the `-put` or `-copyFromLocal` command:

```bash
# Upload a CSV file
hdfs dfs -put C:\my_data.csv /user/Student/input/

# Upload an Excel file
hdfs dfs -put C:\finances.xls /user/Student/input/
```
Once uploaded, your MapReduce Java or Python programs can simply be coded to parse comma-separated or tab-separated data instead of raw text.

### Monitoring Hadoop via the Web GUIs
Hadoop automatically hosts real-time monitoring dashboards on your localhost when the daemons are running.

#### **A. NameNode UI / HDFS Dashboard (`http://localhost:9870`)**
This is the "Hard Drive" monitoring interface.
* **Browse Files Visually**: If you click **Utilities > Browse the file system** at the top right, it will open a file explorer. You can navigate through HDFS, create new folders, and even **upload/download files directly through the browser** without using the command line!
* **Monitor Storage**: You can see exactly how much disk space HDFS is currently using vs your Configured Capacity.
* **Check DataNode Health**: You can verify if your DataNodes are active or if any have crashed by clicking the "Datanodes" tab.

#### **B. ResourceManager UI / YARN Dashboard (`http://localhost:8088`)**
This is the "Task Manager" interface.
* **Track MapReduce Jobs**: Every time you run `hadoop jar ...`, a new job will appear in this list. 
* **Check Status and Progress**: You can see if an application is `ACCEPTED`, `RUNNING`, `FINISHED`, or `FAILED`.
* **Read Error Logs**: If a MapReduce job fails, you can click its `ID` in the list to look at exactly which Java exception or memory issue caused it to crash, line-by-line.
