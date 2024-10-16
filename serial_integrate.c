#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

// Function to integrate
double f1(double x) {
    return x * x;
}

double f2(double x) {
    return x * x * x * x - 3 * x * x + x + 4;
}

// Compute trapezoidal approximation
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
    double a = 0.0, b = 1.0; // default interval
    int n = 1024;            // default number of trapezoids
    double h;
    double total_int;
    struct timeval start, finish;
    double elapsed;
    int func_choice = 1; // default function choice
    double (*func)(double) = f1; // default function

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
        printf("Invalid function choice. Use 1 for f(x)=x^2, 2 for f(x)=x^4 - 3x^2 + x + 4\n");
        return -1;
    }

    // Start timing the entire program
    gettimeofday(&start, NULL);

    h = (b - a) / n;  // width of each trapezoid

    // Calculate the integral
    total_int = Trap(a, b, n, h, func);

    // End timing the entire program
    gettimeofday(&finish, NULL);
    elapsed = (finish.tv_sec - start.tv_sec) + (finish.tv_usec - start.tv_usec)/1e6;

    // Output the result and total time
    printf("With n = %d trapezoids, our estimate of the integral from %f to %f = %.15e\n", n, a, b, total_int);
    printf("Total elapsed time = %f seconds\n", elapsed);

    return 0;
}
