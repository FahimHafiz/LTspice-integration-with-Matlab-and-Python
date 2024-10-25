# LTspice-integration-with-Matlab-and-Python
In this work, I demonstrate how can we link circuits built in LTspice circuit simulator with MATLAB and Python. In this way, we can vary different parameters of the actual circuit using MATLAB and Python for analyzing the circuit without the need to make changes or even touch the circuits built in LTspice.
## Requirements

- **MATLAB:** Version 2022b
- **Python:** I used version 3.10.12 but upto 3.7 should work
- **Python Packages:**
    - `matplotlib`
    - `ltspice`
    - `numpy`


# LTSpice Automation with MATLAB and Python

## Overview
This repository demonstrates how to automate LTSpice circuit simulations using both MATLAB and Python. It includes source code for automating the generation of netlists, modifying parameters, and extracting simulation results for RC circuits.

## File Structure
- `/scripts/matlab`: Contains MATLAB scripts for automating LTSpice.
- `/scripts/python`: Contains Python scripts for automating LTSpice.
- `/LTSpice_Circuits/`: Contains LTSpice schematic and netlist files.
- `/plots/`: Simulation result plots in PNG format.
- `/docs/`: Detailed documentation on using the repository.

## Instructions
### Prerequisites
- LTSpice XVII (installed and added to the system path).
- MATLAB (for MATLAB automation).
- Python (with required libraries, e.g., `ltspice`, `matplotlib`).

### Running MATLAB Automation
1. Open MATLAB.
2. Navigate to the `/scripts/` folder.
3. Run `LTspice_automate_matlab.m`.
4. `LTspice_automate_matlab_structured.m` can be run also. This code is more written in a more organised way whereas `LTspice_automate_matlab.m` is hardcoded.

### Running Python Automation
1. Install required libraries using `pip install -r requirements.txt`.
2. Navigate to the `/scripts/` folder.
3. Run `LTspice_automate_python.py`.
4. `LTspice_automate_python_structured.m` can be run also. This code is more written in a more organised way whereas `LTspice_automate_python.m` is hardcoded.

## License
This project is licensed under the MIT License.

