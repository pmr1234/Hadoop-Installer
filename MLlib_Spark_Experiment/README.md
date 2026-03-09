# Experiment 5: MLlib Implementation On Spark

This repository contains the codebase for **Experiment 5: To implement Machine Learning algorithms such as Classification (Logistic Regression) and Clustering (K-Means) using Apache Spark MLlib (PySpark).**

## 📦 How to Clone this Specific Experiment
To prevent different experiments from overlapping, this code is versioned via a Git Tag. You can download *only* this exact PySpark MLlib code by running:
```bash
git clone --branch v5.0-mllib-spark https://github.com/pmr1234/Hadoop-Installer.git
```

## Description
Apache Spark's MLlib is a scalable machine learning library that delivers high-quality clustering and classification algorithms natively distributed across resilient datasets.

This experiment proves:
1. **Classification:** Applying `LogisticRegression` against a synthesized dataset to build a binary decision boundary.
2. **Clustering:** Utilizing `KMeans` to automatically detect topological centroids (K=3) in an unlabelled DataFrame, returning silhouette scoring metrics.

---

## 🚀 How to Execute the Analytics

Ensure that your `JAVA_HOME` and `HADOOP_HOME` are correctly configured on your Windows machine (or run via the Anaconda environment). 

1. Double-click the orchestrated execution script:
   ```bat
   run_mllib.cmd
   ```

### What Happens Automatically:
1. The script bridges your PySpark installation to winutils.
2. Spark initializes a local master computation graph.
3. The script first executes `classification.py`, ingesting labeled data, training the Logistic Regression models, validating them, and outputting the accuracy.
4. The script secondly executes `clustering.py`, distributing unlabelled points mathematically into three calculated centroids and computing the squared errors.
5. The local application shuts down gracefully.
