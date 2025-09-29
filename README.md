# Battery_charge_discharge_simulink_model
This project simulates a constant current charge-discharge model for batteries connected in series. The system follows a specific operational cycle where it charges when the maximum voltage exceeds 3.65V after a 300-second rest period, and discharges when the voltage drops below 2.85V after another 300-second rest period.

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
Functions
set_nom_parament()
Sets the nominal parameters for each battery block including voltage, discharge rate, cutoff voltage, full charge voltage, exponential zone, and display characteristics.

set_random_parament()
Sets the randomized parameters for each battery block including SOC, maximum capacity, internal resistance, normal operating point (90% of maximum capacity), and nominal capacity.

This simulation provides a realistic model of battery behavior under cyclic charge-discharge conditions with parameter variations to account for manufacturing differences among battery modules.

Here is simulink model.
<img width="1760" height="1080" alt="image" src="https://github.com/user-attachments/assets/131131c3-d09c-4010-b602-bc12de964a72" />


Here you can change your battery  parameters.
<img width="1366" height="580" alt="image" src="https://github.com/user-attachments/assets/1adc03b3-67fa-46aa-9e22-aa99fff186c1" />
