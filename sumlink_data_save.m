% Read Simulink.SimulationOutput object data and save as Excel file
% The 'out' variable contains all required timeseries data

% Check if 'out' variable exists in workspace
if ~exist('out', 'var')
    error('Variable ''out'' does not exist in workspace');
end

% Verify that 'out' is a Simulink.SimulationOutput object
if ~isa(out, 'Simulink.SimulationOutput')
    error('Variable ''out'' is not a Simulink.SimulationOutput object');
end

% Use correct method to get signal names from Simulink.SimulationOutput object
% For Simulink.SimulationOutput objects, use who method instead of whos
signal_names = who(out); % Use who method to get editable property names

fprintf('Signals found: %s\n', strjoin(signal_names, ', '));

% Use tout as time vector (since it already exists)
if isprop(out, 'tout') || isfield(out, 'tout')
    time_data = out.tout;
    fprintf('Using tout as time vector, length: %d\n', length(time_data));
else
    % If tout doesn't exist, use time from first timeseries
    first_signal = signal_names{1};
    time_data = out.(first_signal).Time;
    fprintf('Using time vector from %s, length: %d\n', first_signal, length(time_data));
end

% Create data table
data_table = table(time_data, 'VariableNames', {'Time'});

% Add all signal data to table
for i = 1:length(signal_names)
    signal_name = signal_names{i};
    
    % Skip tout since it's already used as time column
    if strcmp(signal_name, 'tout')
        continue;
    end
    
    % Skip non-data fields like SimulationMetadata and ErrorMessage
    if any(strcmp(signal_name, {'SimulationMetadata', 'ErrorMessage'}))
        continue;
    end
    
    try
        % Get signal data
        signal_obj = out.(signal_name);
        
        % Check if it's a timeseries
        if isa(signal_obj, 'timeseries')
            signal_data = signal_obj.Data;
            
            % Ensure data length matches time vector
            if length(signal_data) == length(time_data)
                data_table.(signal_name) = signal_data;
                fprintf('Signal added: %s\n', signal_name);
            else
                fprintf('Warning: Data length for %s (%d) does not match time vector length (%d), skipping this signal\n', ...
                        signal_name, length(signal_data), length(time_data));
            end
        else
            fprintf('Skipping non-timeseries signal: %s (type: %s)\n', signal_name, class(signal_obj));
        end
    catch ME
        fprintf('Error processing signal %s: %s\n', signal_name, ME.message);
    end
end

% Save as Excel file
filename = 'Solo_battery10_CC0o01.xlsx';
try
    writetable(data_table, filename);
    fprintf('Data successfully saved to %s\n', filename);
    fprintf('File contains %d rows of data and %d signal columns\n', height(data_table), width(data_table)-1);
    
    % Display first few rows of data table
    disp('Data preview:');
    disp(head(data_table));
catch ME
    error('Error saving Excel file: %s', ME.message);
end

try
    figure;
    
    if ismember('battery1', data_table.Properties.VariableNames) && ismember('battery2', data_table.Properties.VariableNames)
        subplot(2,2,1);
        plot(data_table.Time, data_table.battery1);
        hold on;
        plot(data_table.Time, data_table.battery2);
        title('Battery Voltage');
        xlabel('Time');
        ylabel('Voltage (V)');
        legend('Battery 1', 'Battery 2');
    end
    
    if ismember('SOC1', data_table.Properties.VariableNames) && ismember('SOC2', data_table.Properties.VariableNames)
        subplot(2,2,2);
        plot(data_table.Time, data_table.SOC1);
        hold on;
        plot(data_table.Time, data_table.SOC2);
        title('Battery SOC');
        xlabel('Time');
        ylabel('SOC (%)');
        legend('Battery 1', 'Battery 2');
    end
    
    if ismember('totalV', data_table.Properties.VariableNames)
        subplot(2,2,3);
        plot(data_table.Time, data_table.totalV);
        title('Total Voltage');
        xlabel('Time');
        ylabel('Voltage (V)');
    end
    
    if ismember('totalC', data_table.Properties.VariableNames)
        subplot(2,2,4);
        plot(data_table.Time, data_table.totalC);
        title('Total Current');
        xlabel('Time');
        ylabel('Current (A)');
    end
    
    set(gcf, 'Position', [100, 100, 1200, 800]);
    
    saveas(gcf, 'battery_simulation_plots.png');
    fprintf('Graph saved as battery_simulation_plots.png\n');
catch ME
    fprintf('Error during plotting: %s\n', ME.message);
end