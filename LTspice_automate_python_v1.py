import os
import shutil
import matplotlib.pyplot as plt
import ltspice
import numpy as np

# File and folder locations of the .asc file
netlist_directory = r'D:\Research\circuit_automation'
spice_file_name_tran = 'RC_ckt_transient'
spice_file_name_net_tran = spice_file_name_tran + '.net'
netlist_file_tran = os.path.join(netlist_directory, spice_file_name_net_tran)
raw_file_tran = os.path.join(netlist_directory, spice_file_name_tran + '.raw')
asc_file_tran = os.path.join(netlist_directory, spice_file_name_tran + '.asc')
LTSpice_exe_directory = r'C:\Program Files\LTC\LTspiceXVII'

# Change directory to LTSpice executable
os.chdir(LTSpice_exe_directory)

# Run the LTSpice command to generate netlist from .asc
system_command_tran = f'XVIIx64.exe -run -b "{asc_file_tran}"'
os.system(system_command_tran)

# Change back to the netlist directory
os.chdir(netlist_directory)

# Modify the netlist file, replacing the parameter value
R_val = 2
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


# Change directory to LTSpice executable
os.chdir(LTSpice_exe_directory)

# Run the modified .net file
system_command = f'XVIIx64.exe -run -b "{netlist_file_tran}"'
os.system(system_command)

# Change back to the netlist directory
os.chdir(netlist_directory)

# Load the raw data
l = ltspice.Ltspice(raw_file_tran)
l.parse()  # Parse the LTSpice raw file

# Extract time and voltage data
time = l.get_time()
voltage = l.get_data('V(vout)')

# Transpose the data (if needed)
time = np.transpose(time)
voltage = np.transpose(voltage)

# Plot voltage vs time
plt.figure()

# Plot voltage vs time with customizations
plt.plot(time, voltage, linewidth=2, color='r')  # Red line with thicker width
plt.title('Voltage vs Time', fontsize=14, fontweight='bold')
plt.xlabel('Time (s)', fontsize=12)
plt.ylabel('Voltage (V)', fontsize=12)

# Add grid for better readability
plt.grid(True)

# Set axis limits (adjust based on your data range)
plt.xlim([min(time), max(time)])
plt.ylim([min(voltage), max(voltage)])

# Customize the plot appearance
plt.gca().set_fontsize(12)
plt.gca().set_linewidth(1.5)

# Save the plot as a PNG image
plt.savefig('voltage_vs_time_plot_python.png')

# Show the plot
plt.show()
