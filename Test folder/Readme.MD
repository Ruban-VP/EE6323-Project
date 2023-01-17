# Test folder
This is a test folder to perform SER/BER simulations with the integrated system (BB+RF). 
Instructions:
1. Create a PWD on your PC with all these files present in it.
2. Run the Baseband_Tx.m file first to generate the Tx signal data (**Tx_I_data.txt** and **Tx_Q_data.txt**).
3. Run the ADS file to generate the Rx signal data (**Rx_I_data.tim** and **Rx_Q_data.tim**). This ADS design also has option to vary the SNR.
4. Run the Baseband_Rx.m file now to find the SER and BER.
