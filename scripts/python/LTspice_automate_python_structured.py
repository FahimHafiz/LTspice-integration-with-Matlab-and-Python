# %% Importing necessary python packages
import os
import shutil
import matplotlib.pyplot as plt
import ltspice
import numpy as np

# %% File and folder locations of the .asc File/LTspice circuits folder
netlist_directory = r'D:\Research\LTspice-integration-with-Matlab-and-Python\LTspice_circuits'
spice_file_name_tran = 'RC_ckt_transient' # edit according to your LTspice circuit file name
netlist_file_tran = os.path.join(netlist_directory, spice_file_name_tran + '.net')
raw_file_tran = os.path.join(netlist_directory, spice_file_name_tran + '.raw')
asc_file_tran = os.path.join(netlist_directory, spice_file_name_tran + '.asc')
LTSpice_exe_directory = r'C:\Program Files\LTC\LTspiceXVII'
code_directory = r'D:\Research\LTspice-integration-with-Matlab-and-Python\scripts\python'
result_directory = r'D:\Research\LTspice-integration-with-Matlab-and-Python\plots' # save all  the results, figures in this directory 

# %% Circuit Parameters
''' We have a RC LTspice circuit, where we want to change the original resistance value to see the changes in the output voltage vs. time.
This is just an example on how we can automate any changes we want to see using Python'''
R_val = 2 # new value of the Resistance in the RC circuit (in kOhms)

# %% Run the LTSpice command to generate netlist from .asc
# Change directory to LTSpice executable
os.chdir(LTSpice_exe_directory)
system_command_tran = f'XVIIx64.exe -run -b "{asc_file_tran}"'
os.system(system_command_tran)

# %% Change back to the netlist directory
os.chdir(netlist_directory)

# %% Modify the netlist file, replacing the parameter value

S1 = '.param R=1k'  # default value
S1_new = f'.param R={R_val}k'  # new value

# Open the netlist file
with open(netlist_file_tran, 'r') as file:
    X = file.read()

# Replace the parameter value
Y1 = X.replace(S1, S1_new)

# Save the modified netlist file
with open(netlist_file_tran, 'w') as file:
    file.write(Y1)

# Save the modified netlist with a new name
netlist_file_name_new = f'{spice_file_name_tran}_R_{R_val}.net'
with open(os.path.join(netlist_directory, netlist_file_name_new), 'w') as file:
    file.write(Y1)


# %% # Run the modified .net file
# Change directory to LTSpice executable
os.chdir(LTSpice_exe_directory)
system_command = f'XVIIx64.exe -run -b "{netlist_file_tran}"'
os.system(system_command)

# Change back to the netlist directory
os.chdir(netlist_directory)

# %% Extracting the RAW data of the circuit using LTspice package of python
# Importing the generated RAW data from LTspice to MATLAB
# Load the raw data
l = ltspice.Ltspice(raw_file_tran)
l.parse()  # Parse the LTSpice raw file

# Extract time and voltage data
time = l.get_time()
voltage = l.get_data('V(vout)')

# Transpose the data (if needed)
time = np.transpose(time)
voltage = np.transpose(voltage)

# %% Plot the voltage vs. time and save the results
# Plot voltage vs time
plt.figure()
plt.plot(time, voltage, linewidth=2, color='r')  
plt.title('Voltage vs Time', fontsize=14, fontweight='bold')
plt.xlabel('Time (s)', fontsize=12)
plt.ylabel('Voltage (V)', fontsize=12)
plt.grid(True)


plt.xlim([min(time), max(time)])
plt.ylim([min(voltage), max(voltage)])

# Save the plot as a PNG image
img_path = os.path.join(result_directory, 'voltage_vs_time_plot_python.png')
plt.savefig(img_path)

# Show the plot
plt.show()


# %%
