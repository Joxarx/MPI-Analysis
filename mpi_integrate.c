#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

// Function to integrate
double f1(double x) {
    return x * x;
}

double f2(double x) {
    return x * x * x * x - 3 * x * x + x + 4;
}

// Compute local trapezoidal approximation
double Trap(double left_endpt, double right_endpt, int trap_count, double base_len, double (*func)(double)) {
    double estimate, x;
    int i;

    estimate = (func(left_endpt) + func(right_endpt)) / 2.0;
    for (i = 1; i <= trap_count - 1; i++) {
        x = left_endpt + i * base_len;
        estimate += func(x);
    }
    estimate = estimate * base_len;
    
    return estimate;
}

int main(int argc, char** argv) {
    int my_rank, comm_sz;
    double a = 0.0, b = 1.0; // default interval
    int n = 1024;            // default number of trapezoids
    double h, local_a, local_b;
    int local_n;
    double local_int, total_int;
    double start, finish, elapsed;
    int func_choice = 1; // default function choice
    double (*func)(double) = f1; // default function

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &comm_sz);

    // Parse command-line arguments
    // Expected usage: program_name n a b func_choice
    if (argc >= 2) {
        n = atoi(argv[1]);
    }
    if (argc >= 4) {
        a = atof(argv[2]);
        b = atof(argv[3]);
    }
    if (argc >= 5) {
        func_choice = atoi(argv[4]);
    }

    // Select function based on func_choice
    if (func_choice == 1) {
        func = f1;
    } else if (func_choice == 2) {
        func = f2;
    } else {
        if (my_rank == 0) {
            printf("Invalid function choice. Use 1 for f(x)=x^2, 2 for f(x)=x^4 - 3x^2 + x + 4\n");
        }
        MPI_Finalize();
        return -1;
    }

    // Start timing the entire program
    start = MPI_Wtime();

    h = (b - a) / n;  // width of each trapezoid
    local_n = n / comm_sz;  // number of trapezoids for each process

    // Each process calculates its local interval
    local_a = a + my_rank * local_n * h;
    local_b = local_a + local_n * h;

    // Calculate the local integral
    local_int = Trap(local_a, local_b, local_n, h, func);

    // Sum up the integrals from all processes using MPI_Reduce
    MPI_Reduce(&local_int, &total_int, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

    // End timing the entire program
    finish = MPI_Wtime();
    elapsed = finish - start;

    // Output the result and total time
    if (my_rank == 0) {
        printf("With n = %d trapezoids, our estimate of the integral from %f to %f = %.15e\n", n, a, b, total_int);
        printf("Total elapsed time = %f seconds\n", elapsed);
    }

    MPI_Finalize();
    return 0;
}
