% Read Simulink battery model parameters and export to Excel
function export_battery_parameters_to_excel()

    % Open Simulink model (if not already open)
    modelName = 'battery_simulink_model';
    if ~bdIsLoaded(modelName)
        open_system('battery_simulink_model.slx');
    end
    
    % Wait for model to fully load
    pause(2);
    
    % Create table data storage
    dataTable = table();
    
    % List of parameters to read
    paramNames = {
        'NomV',          % Nominal voltage
        'Dis_rate',      % Discharge rate
        'MinV',          % Cutoff voltage
        'FullV',         % Full charge voltage
        'expZone',       % Exponential zone
        'current',       % Display characteristics
        'SOC',           % Initial SOC
        'R',             % Internal resistance
        'MaxQ',          % Maximum capacity
        'Normal_OP',     % Normal operating point
        'NomQ'           % Nominal capacity
    };
    
    % Loop through all battery modules
    for i = 1:10
        batteryBlockPath = [modelName, '/Battery', num2str(i)];
        
        % Check if block exists
        if ~getSimulinkBlockHandle(batteryBlockPath)
            warning(['Block does not exist: ', batteryBlockPath]);
            continue;
        end
        
        % Read value for each parameter
        paramValues = cell(length(paramNames), 1);
        for j = 1:length(paramNames)
            try
                paramValues{j} = get_param(batteryBlockPath, paramNames{j});
            catch
                paramValues{j} = 'N/A';
            end
        end
        
        % Add parameter values to table
        rowData = cell2table(paramValues', 'VariableNames', paramNames);
        rowData.BlockName = {batteryBlockPath};  % Add block name column
        
        % Add new row to main table
        if isempty(dataTable)
            dataTable = rowData;
        else
            dataTable = [dataTable; rowData];
        end
    end
    
    % Reorder columns to put BlockName as first column
    dataTable = movevars(dataTable, 'BlockName', 'Before', 1);
    
    filename = ['battery_parameters', '.xlsx'];
    
    % Write data to Excel file
    try
        writetable(dataTable, filename);
        disp(['Battery parameters successfully exported to: ', filename]);
        
        % Display table content in MATLAB
        disp('Exported data content:');
        disp(dataTable);
        
    catch e
        error('Error exporting Excel file: %s', e.message);
    end
end