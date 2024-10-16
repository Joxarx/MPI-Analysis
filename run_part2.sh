#!/bin/bash

# Make sure the code is compiled
mpicc -o mpi_integrate mpi_integrate.c
gcc -o serial_integrate serial_integrate.c

# Variables
processes=(1 2 4 8)
trapezoids=(256 1024 4096 16384)
a=0.0
b=2.0

# Functions
funcs=(1 2)

# Create result files
echo "Function,Processes,Trapezoids,Serial_Time,Parallel_Time,Speedup,Efficiency" > results_func1.csv
echo "Function,Processes,Trapezoids,Serial_Time,Parallel_Time,Speedup,Efficiency" > results_func2.csv

for func_choice in "${funcs[@]}"
do
    if [ "$func_choice" -eq 1 ]; then
        func_name="f(x)=x^2"
        result_file="results_func1.csv"
    else
        func_name="f(x)=x^4 - 3x^2 + x + 4"
        result_file="results_func2.csv"
    fi

    echo "Function: $func_name"

    for n in "${trapezoids[@]}"
    do
        # Run serial version
        ./serial_integrate $n $a $b $func_choice > serial_output.txt
        serial_time=$(grep 'Total elapsed time' serial_output.txt | awk '{print $5}')

        for p in "${processes[@]}"
        do
            # Run MPI version
            mpirun --oversubscribe -np $p ./mpi_integrate $n $a $b $func_choice > mpi_output.txt
            mpi_time=$(grep 'Total elapsed time' mpi_output.txt | awk '{print $5}')

            # Calculate speedup and efficiency
            speedup=$(echo "scale=5; $serial_time / $mpi_time" | bc)
            efficiency=$(echo "scale=5; $speedup / $p" | bc)

            # Output to result file
            echo "$func_choice,$p,$n,$serial_time,$mpi_time,$speedup,$efficiency" >> $result_file

            echo "n=$n, Processes=$p, Speedup=$speedup, Efficiency=$efficiency"
        done
    done
done
