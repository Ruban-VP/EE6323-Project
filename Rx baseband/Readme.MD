# Rx baseband
Contains all files corresponding to the baseband part of the receiver.

**Baseband_Rx.m**: The master MATLAB code for baseband receiver. Remaining two codes are helper functions used in this main code.

**BB_Rx_chain.m**: The received values are taken, channel tap is estimated using pilots, CP removal and FFT is done, modulation symbols and bits are decoded

**Deciconvert.m**: The hexadecimal Rx data is read, converted back to signal values w.r.t a given reference voltage
