#!/bin/bash
set -euo pipefail

# Ensure the code is compiled
mpicc -o mpi_integrate mpi_integrate.c

# Variables
n_values=(10 40 160 640)
a=0.0
b=2.0
processes=2

# Exact values
exact_value_func1=$(echo "scale=15; 8.0/3.0" | bc -l)
exact_value_func2=8.4

# Functions
funcs=(1 2)

# Create or clear the result file
echo "Function,Trapezoids,Estimated_Integral,Exact_Value,Absolute_Error" > precision_results.csv

for func_choice in "${funcs[@]}"
do
    if [ "$func_choice" -eq 1 ]; then
        func_name="f(x)=x^2"
        exact_value=$exact_value_func1
    else
        func_name="f(x)=x^4 - 3x^2 + x + 4"
        exact_value=$exact_value_func2
    fi

    echo "Function: $func_name"

    for n in "${n_values[@]}"
    do
        # Run MPI version with 2 processes
        mpirun --oversubscribe -np $processes ./mpi_integrate $n $a $b $func_choice > mpi_output.txt

        # Extract the estimated integral
        estimated_integral=$(grep 'our estimate of the integral' mpi_output.txt | awk -F'=' '{print $NF}' | xargs)

        # Debugging: Print the extracted estimated integral
        echo "Extracted Estimated Integral: $estimated_integral"

        # Check if estimated_integral is a valid number
        if [[ -z "$estimated_integral" ]]; then
            echo "Error: Failed to extract estimated integral."
            abs_error="N/A"
        else
            # Calculate absolute error using awk, which supports scientific notation
            abs_error=$(awk -v exact="$exact_value" -v est="$estimated_integral" 'BEGIN {diff = exact - est; if (diff < 0) diff = -diff; printf "%.10e", diff}')
        fi

        # Output to result file
        echo "$func_choice,$n,$estimated_integral,$exact_value,$abs_error" >> precision_results.csv

        echo "n=$n, Estimated Integral=$estimated_integral, Exact Value=$exact_value, Absolute Error=$abs_error"
    done
done

# Clean up temporary files
rm -f mpi_output.txt
