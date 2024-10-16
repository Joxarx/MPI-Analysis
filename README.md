# MPI Trapezoidal Rule for Numerical Integration

## Purpose

This project implements the trapezoidal rule for numerical integration using both serial and parallel (MPI) approaches. It aims to:

- Compare the performance between serial and parallel executions.
- Analyze the scalability of the MPI implementation with varying numbers of processes and trapezoids.
- Evaluate the precision of the integral estimation as the number of trapezoids increases.
- Automate the execution and analysis using scripts.

## Project Structure

```
.
├── mpi_integrate.c     # MPI implementation of the trapezoidal rule
├── serial_integrate.c  # Serial implementation of the trapezoidal rule
├── run_part1.sh        # Script for Part 1: Serial vs Parallel Comparison
├── run_part2.sh        # Script for Part 2: Scalability Test
├── run_part3.sh        # Script for Part 3: Precision Test
├── visualize_results.py # Python script to generate graphs
├── results_func1.csv   # Results for Function 1 (Scalability Test)
├── results_func2.csv   # Results for Function 2 (Scalability Test)
├── precision_results.csv # Results for Precision Test
└── README.md           # Project documentation
```

## Instructions to Run the Programs

### Prerequisites

- Ubuntu operating system (or any Unix-like system)
- OpenMPI installed (`mpicc`, `mpirun`)
- GCC compiler (`gcc`)
- Python 3 with the following packages:
  - `pandas`
  - `matplotlib`
  - `seaborn`

### Compilation

**Compile the MPI program:**

```bash
mpicc -o mpi_integrate mpi_integrate.c
```

**Compile the serial program:**

```bash
gcc -o serial_integrate serial_integrate.c
```

### Running the Programs

#### Part 1: Serial vs Parallel Execution Time Comparison
This part compares the execution time of the serial and parallel implementations for a fixed number of trapezoids.

Run the script:

```bash
chmod +x run_part1.sh
./run_part1.sh
```

#### Part 2: Scalability Test
This part analyzes the scalability of the MPI implementation by varying the number of processes and trapezoids.

Run the script:

```bash
chmod +x run_part2.sh
./run_part2.sh
```

#### Part 3: Precision Test
This part evaluates the precision of the integral estimation as the number of trapezoids increases.

Run the script:

```bash
chmod +x run_part3.sh
./run_part3.sh
```

### Generating Graphs
The `visualize_results.py` script generates graphs for speedup, efficiency, and precision based on the data collected from the previous parts.

Run the visualization script:

```bash
python visualize_results.py
```

The graphs will be saved as PNG files in the project directory.

## Purpose of Each Script

- `mpi_integrate.c`: MPI program that computes the integral using the trapezoidal rule across multiple processes.
- `serial_integrate.c`: Serial version of the program for comparison.
- `run_part1.sh`: Automates Part 1 by compiling the programs and running them with predefined parameters.
- `run_part2.sh`: Automates Part 2 by running the MPI program with different numbers of processes and trapezoids to test scalability.
- `run_part3.sh`: Automates Part 3 by running the program with increasing numbers of trapezoids to test precision.
- `visualize_results.py`: Reads the CSV result files and generates graphs for analysis.

## Understanding the Output

### CSV Files:

- `results_func1.csv`, `results_func2.csv`: Contain data for speedup and efficiency for two different functions.
- `precision_results.csv`: Contains data for precision analysis.

### Graphs:

- Speedup vs. Number of Processes
- Efficiency vs. Number of Processes
- Absolute Error vs. Number of Trapezoids

## Functions Implemented

The programs compute the definite integral over the interval [0,2] for the following functions:

1. Function 1: f(x) = x^2
2. Function 2: f(x) = x^4 - 3x^2 + x + 4

## Notes

- Ensure that all scripts have execute permissions. If not, you can set them using:

  ```bash
  chmod +x script_name.sh
  ```

- The MPI programs use the `--oversubscribe` option to allow more MPI processes than available CPU cores. This is for testing purposes.

- If you encounter any issues with the Python script, make sure all required packages are installed:

  ```bash
  pip install pandas matplotlib seaborn
  ```

## License

This project is open-source and available under the MIT License.
