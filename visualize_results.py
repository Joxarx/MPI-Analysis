import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Set seaborn style for better aesthetics
sns.set(style="whitegrid")

# Function to plot Speedup and Efficiency
def plot_speedup_efficiency(filename, func_name):
    # Read the CSV file
    df = pd.read_csv(filename)
    
    # Convert Trapezoids and Processes to categorical data for plotting
    df['Trapezoids'] = df['Trapezoids'].astype(int)
    df['Processes'] = df['Processes'].astype(int)
    
    trapezoids_list = df['Trapezoids'].unique()
    
    # Plot Speedup
    plt.figure(figsize=(10, 6))
    for n in trapezoids_list:
        subset = df[df['Trapezoids'] == n]
        plt.plot(subset['Processes'], subset['Speedup'], marker='o', label=f'Trapezoids = {n}')
    plt.title(f'Speedup vs. Number of Processes ({func_name})')
    plt.xlabel('Number of Processes')
    plt.ylabel('Speedup')
    plt.legend()
    plt.xticks(df['Processes'].unique())
    plt.savefig(f'speedup_{func_name}.png')
    plt.show()
    
    # Plot Efficiency
    plt.figure(figsize=(10, 6))
    for n in trapezoids_list:
        subset = df[df['Trapezoids'] == n]
        plt.plot(subset['Processes'], subset['Efficiency'], marker='o', label=f'Trapezoids = {n}')
    plt.title(f'Efficiency vs. Number of Processes ({func_name})')
    plt.xlabel('Number of Processes')
    plt.ylabel('Efficiency')
    plt.legend()
    plt.xticks(df['Processes'].unique())
    plt.savefig(f'efficiency_{func_name}.png')
    plt.show()

# Function to plot Absolute Error
def plot_precision(filename):
    # Read the CSV file
    df = pd.read_csv(filename)
    
    # Convert Trapezoids to integer for plotting
    df['Trapezoids'] = df['Trapezoids'].astype(int)
    
    # Separate data for each function
    df_func1 = df[df['Function'] == 1]
    df_func2 = df[df['Function'] == 2]
    
    # Plot Absolute Error vs. Number of Trapezoids for Function 1
    plt.figure(figsize=(10, 6))
    plt.plot(df_func1['Trapezoids'], df_func1['Absolute_Error'].astype(float), marker='o')
    plt.title('Absolute Error vs. Number of Trapezoids (f(x) = x^2)')
    plt.xlabel('Number of Trapezoids')
    plt.ylabel('Absolute Error')
    plt.xscale('log')
    plt.yscale('log')
    plt.grid(True, which="both", ls="--")
    plt.savefig('precision_func1.png')
    plt.show()
    
    # Plot Absolute Error vs. Number of Trapezoids for Function 2
    plt.figure(figsize=(10, 6))
    plt.plot(df_func2['Trapezoids'], df_func2['Absolute_Error'].astype(float), marker='o')
    plt.title('Absolute Error vs. Number of Trapezoids (f(x) = x^4 - 3x^2 + x + 4)')
    plt.xlabel('Number of Trapezoids')
    plt.ylabel('Absolute Error')
    plt.xscale('log')
    plt.yscale('log')
    plt.grid(True, which="both", ls="--")
    plt.savefig('precision_func2.png')
    plt.show()

def main():
    # Plot for Function 1
    plot_speedup_efficiency('results_func1.csv', 'f(x) = x^2')
    
    # Plot for Function 2
    plot_speedup_efficiency('results_func2.csv', 'f(x) = x^4 - 3x^2 + x + 4')
    
    # Plot Precision
    plot_precision('precision_results.csv')

if __name__ == "__main__":
    main()
