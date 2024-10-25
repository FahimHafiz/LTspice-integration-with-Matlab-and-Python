clc;clear all;close all;

%% File and folder locations of the .asc File/LTspice circuits folder
netlist_directory = 'D:\Research\LTspice-integration-with-Matlab-and-Python\LTspice_circuits\';
spice_file_name_tran = 'RC_ckt_transient'; % edit according to your LTspice circuit file name
spice_file_name_net_tran = strcat(spice_file_name_tran, '.net');
netlist_file_tran = strcat(netlist_directory, spice_file_name_tran, '.net');
raw_file_tran = strcat(netlist_directory, spice_file_name_tran, '.raw');
asc_file_tran = strcat(netlist_directory, spice_file_name_tran, '.asc');
LTSpice_exe_directory = 'C:\Program Files\LTC\LTspiceXVII';
code_directory = 'D:\Research\LTspice-integration-with-Matlab-and-Python\scripts\matlab\';
result_directory = 'D:\Research\LTspice-integration-with-Matlab-and-Python\plots\'; % save all 
% the results, figures in this directory 

%% running the transient .asc file first to get the original netlist file of the Circuit
cd(LTSpice_exe_directory);
system_command_tran = strcat('XVIIx64.exe -run -b "',asc_file_tran,'"');
system(system_command_tran);

%% Returning to the netlist directory
cd(netlist_directory);
%% Modify the netlist file, replacing the parameter value

% We have a RC LTspice circuit, where we want to change the original
% resistance value to see the changes in the output voltage vs. time.
% This is just an example on how we can automate any changes we want to see
% using MATLAB

R_val = 2; % new value of the Resistance in the RC circuit (in kOhms)
fid = fopen(spice_file_name_net_tran,'rt') ; % generated net list being opened
X = fread(fid); % net list file being read
fclose(fid);
X = char(X.'); % net list file is saved in X 
S1 = '.param R=1k'; % default value in the RC circuit

S1_new = strcat('.param R=', num2str(R_val),'k'); % new value
Y1 = strrep(X, S1, S1_new);  % replacing for new value

fid2 = fopen(netlist_file_tran,'wt') ;
fwrite(fid2,Y1);
fclose (fid2);

% saving the new netlist file
netlist_file_name_new = strcat(spice_file_name_tran, '_R_', num2str(R_val), '.net' );
fid3 = fopen(netlist_file_name_new, "wt");
fwrite(fid3, Y1);
fclose(fid3);

%% Running the new .net file
cd(LTSpice_exe_directory);
system_command = strcat('XVIIx64.exe -run -b "',netlist_file_tran,'"');
system(system_command);
cd(netlist_directory);

%% Extracting the RAW data of the circuit using LTspice2Matlab function
% Importing the generated RAW data from LTspice to MATLAB
% Adding the LTspice2Matlab function directory
addpath(code_directory);
raw_data = LTspice2Matlab(raw_file_tran);


% removing the LTspice2Matlab function directory
rmpath(code_directory);
%% Saving the necessary variable value from the LTspice simulation generated .raw files
% Post Processing- Now we will import the output voltage and time data for
% the new Resistance value

var_char = raw_data.variable_name_list; % checking all the variables in the circuit
index = find(strcmp(var_char, 'V(vout)')); % looking for vout
voltage = raw_data.variable_mat(index,: ); % output voltage
voltage = transpose(voltage);
time = raw_data.time_vect; % simulation end time in the transient circuit
time = transpose(time);

%% Plotting the voltage vs time
% Creating a figure
figure;

% Plot voltage vs time
plot(time, voltage, 'LineWidth', 2, 'Color', 'r');  

% Title and labels
title('Voltage vs Time', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 12);
ylabel('Voltage (V)', 'FontSize', 12);
legend(strcat('voltage value for R =', ' ', num2str(R_val), 'k'));
% Adding grid for better readability
grid on;

% Setting axis limits
xlim([min(time) max(time)]);
ylim([min(voltage) max(voltage)]);

% Customizing the plot appearance
set(gca, 'FontSize', 12, 'LineWidth', 1.5);  % Set font size and axis line width

% Saving the figure
saveas(gcf, strcat(result_directory, 'voltage_vs_time_plot_matlab.png'));  % Save the plot as a PNG image
