% Open the Simulink model
open_system('battery_simulink_model.slx');
modelName = 'battery_simulink_model'; 

% Set standard values
Rated_Capacity = 228; % Set standard capacity (Ah)
Nominal_discharge_current = 0.5*Rated_Capacity; % Discharge rate (0.5C)
Nominal_voltage = 3.2; % Nominal voltage (V)

% Set baseline values for random parameters
SOC = 10; % Initial State of Charge (%)
Maximum_capacity = 228; % Maximum capacity (Ah)
Cut_off_Voltage = 2.5; % Minimum cutoff voltage (V)
Fully_charge_voltage = 3.65; % Full charge voltage (V)
Internal_resstance = 0.00022; % Internal resistance (Ohm)
Exponential_zone = "[3.45,10]"; % Exponential zone parameters
Display_characteristics = "[114]"; % Display characteristics for 0.5C discharge

% Loop to configure parameters for 10 battery modules
for i = 1:10
    % Construct battery block path
    batteryBlockPath = [modelName, '/Battery', num2str(i)];
    
    % Set nominal parameters
    set_nom_parament(batteryBlockPath, Nominal_voltage,...
        Nominal_discharge_current, Cut_off_Voltage, Fully_charge_voltage,...
        Exponential_zone, Display_characteristics)
    
    % Set random parameters
    set_random_parament(batteryBlockPath, SOC, Maximum_capacity, Internal_resstance)
end

% Function to set battery nominal parameters
function set_nom_parament(batteryBlockPath, Nominal_voltage,...
    Nominal_discharge_current, Cut_off_Voltage, Fully_charge_voltage,...
    Exponential_zone, Display_characteristics)

    % Set nominal voltage
    set_param(batteryBlockPath, 'NomV', num2str(Nominal_voltage))
    
    % Turn off preset model
    set_param(batteryBlockPath, 'PresetModel', 'off')
    
    % Set discharge rate
    set_param(batteryBlockPath, 'Dis_rate', num2str(Nominal_discharge_current))
    
    % Set cutoff voltage
    set_param(batteryBlockPath, 'MinV', num2str(Cut_off_Voltage))
    
    % Set full charge voltage
    set_param(batteryBlockPath, 'FullV', num2str(Fully_charge_voltage))

    % Set exponential zone parameters
    set_param(batteryBlockPath, 'expZone', Exponential_zone)
    
    % Set display characteristics
    set_param(batteryBlockPath, 'current', Display_characteristics)
end

% Function to set battery random parameters
function set_random_parament(batteryBlockPath, SOC, Maximum_capacity, Internal_resstance)
    % Calculate maximum capacity with random variation (±5% variation)
    V_MaxQ = round(Maximum_capacity * (1 + (rand() - 0.5) / 10), 1);
    
    % Set SOC with random variation (±5% variation)
    set_param(batteryBlockPath, 'SOC', num2str(round((SOC + rand() * 10 - 5), 0)))
    
    % Set internal resistance with random variation (±5% variation)
    set_param(batteryBlockPath, 'R', num2str(round((Internal_resstance * (1 + (rand() - 0.5) / 10)), 7)))
    
    % Set maximum capacity
    set_param(batteryBlockPath, 'MaxQ', num2str(V_MaxQ))
    
    % Set normal operating point (90% of maximum capacity)
    set_param(batteryBlockPath, "Normal_OP", num2str(V_MaxQ * 0.9))
    
    % Set nominal capacity
    set_param(batteryBlockPath, "NomQ", num2str(V_MaxQ))
end