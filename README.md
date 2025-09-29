# Battery_charge_discharge_simulink_model
This project simulates a constant current charge-discharge model for batteries connected in series.And this simulation provides a realistic model of battery behavior under cyclic charge-discharge conditions with parameter variations to account for manufacturing differences among battery modules. The system follows a specific operational cycle where it charges when the maximum voltage exceeds 3.65V after a 300-second rest period, and discharges when the voltage drops below 2.85V after another 300-second rest period.

Overview
The project enables users to:

Sets the randomized parameters for each battery block including SOC, maximum capacity, internal resistance, normal operating point (90% of maximum capacity), and nominal capacity.

Model battery clusters with parameter variations

Simulate custom charge/discharge cycles

Extract and visualize simulation data

Analyze battery performance under special conditions

Project Structure

Core Files:
parament_set_save_data.m - Configures battery parameter inconsistencies and initial settings

battery_simulink_model.slx - Main Simulink simulation model for battery cluster behavior

sumlink_data_save.m - Processes simulation data from workspace and generates visualizations/Excel outputs

parament_save.m - Extracts and saves battery module parameters from the simulation model

Key Features
Parameter Customization: Set base battery parameters and introduce random variations using MATLAB's rand function

Flexible Simulation: Modify charge/discharge cycles, C-rates, and cutoff conditions through function blocks

Data Visualization: Generate plots and Excel files containing detailed battery simulation data

Parameter Export: Automatically extract and save battery module parameters to structured Excel format

Workflow
Configure battery parameters and inconsistencies using parament_set_save_data.m

Run simulations in Special_condition.slx with customizable stopping conditions

Process and visualize results with sumlink_data_save.m

Export battery parameters using parament_save.m

Requirements
MATLAB

Simulink

Simscape Battery (for battery modeling components)

Usage
Clone the repository and ensure all files are in the same directory. Follow the sequential workflow described above to set up parameters, run simulations, and analyze results. The system supports customization of battery types, operational conditions, and parameter distributions for comprehensive battery cluster analysis.

This introduction clearly explains the project's purpose, structure, and workflow while maintaining a professional tone suitable for GitHub.
Model Configuration
The MATLAB script configures a Simulink model named 'special_condition.slx' with the following parameters:

Standard Values
Rated Capacity: 228 Ah
Nominal Discharge Current: 0.5C (114A)
Nominal Voltage: 3.2V
Baseline Parameters
Initial State of Charge (SOC): 10%
Maximum Capacity: 228 Ah
Cutoff Voltage: 2.5V
Full Charge Voltage: 3.65V
Internal Resistance: 0.00022 Ohm
Exponential Zone: [3.45,10]
Display Characteristics: [114] (for 0.5C discharge)
Implementation Details
The script configures 10 battery modules in the model with randomized parameters (±5% variation) for:

Initial SOC
Maximum capacity
Internal resistance
Customization
To modify the battery operating conditions, you can:

Edit the MATLAB Function block in the Simulink model
Introduce a Time module to control the timing of the charge-discharge cycles
The current operational logic follows this pattern:

When maximum voltage > 3.65V: Rest for 300s, then charge
When voltage < 2.85V: Rest for 300s, then discharge
This cycle repeats continuously
Here is simulink model.

<img width="1760" height="1080" alt="image" src="https://github.com/user-attachments/assets/131131c3-d09c-4010-b602-bc12de964a72" />


Here you can change your battery  parameters.

<img width="1366" height="580" alt="image" src="https://github.com/user-attachments/assets/1adc03b3-67fa-46aa-9e22-aa99fff186c1" />

Here is my result voltage-time.

<img width="2822" height="1488" alt="image" src="https://github.com/user-attachments/assets/31bde012-cbdd-46f0-9a58-6e39d344a234" />
