# Tx baseband
Contains all files corresponding to the baseband part of the transmitter.

**Baseband_Tx.m**: The master MATLAB code for baseband transmitter. Remaining two codes are helper functions used in this main code.

**BB_chain.m**: The bits are generated, symbol-mapped, IFFT and CP addition is done

**Bitconvert.m**: The infinite precision data is converted to finite precision data based on the bit resolution and reference voltage values given
