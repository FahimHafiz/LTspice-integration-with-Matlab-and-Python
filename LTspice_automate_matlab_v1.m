clc;clear all;close all;

%% File and folder locations of the .asc File
netlist_directory = 'D:\Research\circuit_automation\';
spice_file_name_tran = 'RC_ckt_transient'; 
spice_file_name_net_tran = strcat(spice_file_name_tran, '.net');
netlist_file_tran = strcat(netlist_directory, spice_file_name_tran, '.net');
raw_file_tran = strcat(netlist_directory, spice_file_name_tran, '.raw');
asc_file_tran = strcat(netlist_directory, spice_file_name_tran, '.asc');
LTSpice_exe_directory = 'C:\Program Files\LTC\LTspiceXVII';

%% running the transient .asc file first to get the netlist

cd(LTSpice_exe_directory);
system_command_tran = strcat('XVIIx64.exe -run -b "',asc_file_tran,'"');
system(system_command_tran);

%% Returning to the netlist directory
cd(netlist_directory);
%% Extracting raw data from the transient .raw file to determine the SS DC Current

R_val = 2;
fid = fopen(spice_file_name_net_tran,'rt') ; % generated net list being opened
X = fread(fid); % net list file being read
fclose(fid);
X = char(X.'); % net list file is saved in X 
S1 = '.param R=1k'; % default value

S1_new = strcat('.param R=', rptgen.toString(R_val),'k'); % new value
Y1 = strrep(X, S1, S1_new);  % replacing for new value

fid2 = fopen(netlist_file_tran,'wt') ;
fwrite(fid2,Y1);
fclose (fid2);

% saving each netlist file
netlist_file_name_new = strcat(spice_file_name_tran, '_R_', num2str(R_val), '.net' );
fid3 = fopen(netlist_file_name_new, "wt");
fwrite(fid3, Y1);
fclose(fid3);


% Running the .net file
cd(LTSpice_exe_directory);
system_command = strcat('XVIIx64.exe -run -b "',netlist_file_tran,'"');
system(system_command);
cd(netlist_directory);


% Importing the generated RAW data from LTspice to MATLAB    
raw_data = LTspice2Matlab(raw_file_tran);

%% Saving the necessary variable value from the LTspice simulation generated .raw files
% Post Processing- Now we will import the sense current and time data for each time period
% Then, we will save these data columnwise in a text and xlsx file
% Then, we will calculate the delay also for each time period

var_char = raw_data.variable_name_list;
index = find(strcmp(var_char, 'V(vout)'));
voltage = raw_data.variable_mat(index,: );
voltage = transpose(voltage);
time = raw_data.time_vect;
time = transpose(time);

%% Plotting the time vs time
% Create a figure
figure;

% Plot voltage vs time
plot(time, voltage, 'LineWidth', 2, 'Color', 'r');  % Red line with thicker width

% Title and labels
title('Voltage vs Time', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 12);
ylabel('Voltage (V)', 'FontSize', 12);

% Add grid for better readability
grid on;

% Set axis limits (Optional: adjust based on your data range)
xlim([min(time) max(time)]);
ylim([min(voltage) max(voltage)]);

% Customize the plot appearance
set(gca, 'FontSize', 12, 'LineWidth', 1.5);  % Set font size and axis line width

% Save the figure (optional)
saveas(gcf, 'voltage_vs_time_plot.png');  % Save the plot as a PNG image
