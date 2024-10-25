clc; clear; close all;

%% Configuration Section
% Define paths and file locations
netlist_directory = 'D:\Research\LTspice-integration-with-Matlab-and-Python\LTspice_circuits\';
spice_file_name_tran = 'RC_ckt_transient';  % Edit according to your LTspice circuit file name
LTSpice_exe_directory = 'C:\Program Files\LTC\LTspiceXVII';
code_directory = 'D:\Research\LTspice-integration-with-Matlab-and-Python\scripts\matlab\';
result_directory = 'D:\Research\LTspice-integration-with-Matlab-and-Python\plots\';  % Directory for results

% We have a RC LTspice circuit, where we want to change the original
% resistance value to see the changes in the output voltage vs. time.
% This is just an example on how we can automate any changes we want to see
% using MATLAB

% Resistance value to modify in the circuit
R_val = 3;  % New resistance value in the RC circuit (in kOhms)

%% Helper functions
addpath(code_directory);

% Function to build full file paths
build_path = @(dir, filename, ext) fullfile(dir, strcat(filename, ext));

% Paths for netlist and raw data files
netlist_file_tran = build_path(netlist_directory, spice_file_name_tran, '.net');
raw_file_tran = build_path(netlist_directory, spice_file_name_tran, '.raw');
asc_file_tran = build_path(netlist_directory, spice_file_name_tran, '.asc');

%% Run LTSpice simulation
% Change directory to LTSpice and run the transient analysis
cd(LTSpice_exe_directory);
run_LTspice_simulation(asc_file_tran);

%% Modify Netlist
% Open the netlist and modify the resistor value
modify_netlist(netlist_file_tran, R_val);

% Save the new netlist with the updated resistor value
netlist_file_name_new = save_modified_netlist(spice_file_name_tran, R_val, netlist_directory);

%% Run LTSpice with modified netlist
run_LTspice_simulation(netlist_file_name_new);

%% Extract and Process Simulation Data
raw_data = LTspice2Matlab(raw_file_tran);
[var_char, voltage, time] = extract_voltage_time_data(raw_data, 'V(vout)');

%% Plot Results
plot_voltage_vs_time(time, voltage, R_val, result_directory);

rmpath(code_directory);

%% Helper Functions

function run_LTspice_simulation(asc_file)
    % Runs LTSpice simulation
    system_command = strcat('XVIIx64.exe -run -b "', asc_file, '"');
    system(system_command);
end

function modify_netlist(netlist_file, R_val)
    % Modify the resistor value in the netlist file
    fid = fopen(netlist_file, 'rt');
    X = fread(fid);
    fclose(fid);
    X = char(X.');
    
    % Replace old resistor value with the new one
    S1 = '.param R=1k';  % Default value
    S1_new = strcat('.param R=', num2str(R_val), 'k');
    Y1 = strrep(X, S1, S1_new);
    
    % Write modified netlist back to the file
    fid = fopen(netlist_file, 'wt');
    fwrite(fid, Y1);
    fclose(fid);
end

function netlist_file_new = save_modified_netlist(spice_file_name, R_val, netlist_directory)
    % Save the modified netlist with a new name
    netlist_file_new = fullfile(netlist_directory, strcat(spice_file_name, '_R_', num2str(R_val), '.net'));
    copyfile(fullfile(netlist_directory, strcat(spice_file_name, '.net')), netlist_file_new);
end

function [var_char, voltage, time] = extract_voltage_time_data(raw_data, voltage_variable)
    % Extract voltage and time from LTSpice simulation results
    var_char = raw_data.variable_name_list;
    index = find(strcmp(var_char, voltage_variable));  % Looking for the specific variable
    voltage = raw_data.variable_mat(index, :);
    voltage = transpose(voltage);
    time = transpose(raw_data.time_vect);
end

function plot_voltage_vs_time(time, voltage, R_val, result_directory)
    % Create a plot of voltage vs time and save it
    figure;
    plot(time, voltage, 'LineWidth', 2, 'Color', 'r');
    
    % Customize plot
    title('Voltage vs Time', 'FontSize', 14, 'FontWeight', 'bold');
    xlabel('Time (s)', 'FontSize', 12);
    ylabel('Voltage (V)', 'FontSize', 12);
    legend(strcat('Voltage for R =', ' ', num2str(R_val), 'k'));
    grid on;
    
    % Set axis limits
    xlim([min(time), max(time)]);
    ylim([min(voltage), max(voltage)]);
    
    % Save the plot as PNG
    saveas(gcf, fullfile(result_directory, 'voltage_vs_time_plot_matlab.png'));
end
