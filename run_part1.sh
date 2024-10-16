#!/bin/bash

# Make sure the code is compiled
mpicc -o mpi_integrate mpi_integrate.c
gcc -o serial_integrate serial_integrate.c

# Variables
n=4096
a=0.0
b=2.0

# Functions
funcs=(1 2)

for func_choice in "${funcs[@]}"
do
    if [ "$func_choice" -eq 1 ]; then
        func_name="f(x)=x^2"
    else
        func_name="f(x)=x^4 - 3x^2 + x + 4"
    fi

    echo "Function: $func_name"

    # Serial execution
    echo "Serial execution:"
    ./serial_integrate $n $a $b $func_choice > serial_output.txt
    cat serial_output.txt

    # Extract execution time
    serial_time=$(grep 'Total elapsed time' serial_output.txt | awk '{print $5}')

    # Parallel execution with 4 processes
    echo "Parallel execution with 4 processes:"
    mpirun -np 4 ./mpi_integrate $n $a $b $func_choice > mpi_output.txt
    cat mpi_output.txt

    # Extract execution time
    mpi_time=$(grep 'Total elapsed time' mpi_output.txt | awk '{print $5}')

    # Report the estimated integral and execution times
    echo "Estimated integral (Serial):"
    grep 'our estimate of the integral' serial_output.txt
    echo "Execution time (Serial): $serial_time seconds"

    echo "Estimated integral (Parallel):"
    grep 'our estimate of the integral' mpi_output.txt
    echo "Execution time (Parallel): $mpi_time seconds"

    # Calculate speedup and efficiency
    speedup=$(echo "scale=5; $serial_time / $mpi_time" | bc)
    efficiency=$(echo "scale=5; $speedup / 4" | bc)
    echo "Speedup: $speedup"
    echo "Efficiency: $efficiency"
    echo "----------------------------------------"
done
