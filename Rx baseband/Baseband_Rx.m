%% EE6323: Project
% Baseband receiver

%% Parameter initializations

M = 4;                           % Modulation index
N_slots = 10;                    % N0. of slots
N_OFDM_sym = 14*N_slots;         % No. of OFDM symbols
N_PRBs = 273;                    % No. of PRBs occupied
N_subcar = 12*N_PRBs;            % No. of subcarriers occupied 
N_CP = 288;                      % Cyclic prefix length 
N_FFT = 2^ceil(log2(N_subcar));  % Minimum FFT length required
fs = N_FFT*30e-3;                % Sampling frequency in MHz

%% File reading and Rx data vector creation 

V_ref = 5;      % ADC reference voltage
num_bits = 16;  % ADC resolution

% Rx signal is obtained
I_data = str2double(readlines('Rx_I_data.txt'));
I_quant = I_data(1:end-1);
Q_data = str2double(readlines('Rx_Q_data.txt'));
Q_quant = Q_data(1:end-1);

I_vals = Deciconvert(I_quant,V_ref,num_bits);
Q_vals = Deciconvert(Q_quant,V_ref,num_bits);

Rx_vals = complex(I_vals,Q_vals);
Rx_vals = Rx_vals.';

Tx_syms = readmatrix('Tx_syms.csv');
Tx_bits = readmatrix('Tx_bits.csv');

% Rx signal spectrum
figure(2)
pspectrum(Rx_vals,fs);
xlabel('Frequency (in MHz)');
ylabel('PSD (in dBm/Hz)');
title('PSD plot of Rx signal');

%% Baseband receiver chain

% Rx signal is sent through the receiver chain and information symbols are decoded
Rx_syms = BB_Rx_chain(Tx_syms,Rx_vals,M,N_subcar,N_FFT,N_CP,N_OFDM_sym);

N_sym = N_OFDM_sym*N_subcar;
Tx_syms = reshape(Tx_syms,1,N_sym);
Rx_syms = reshape(Rx_syms,1,N_sym);
% Bits are decoded
decoded_bits = qamdemod(Rx_syms,2^M,"gray","OutputType","bit",UnitAveragePower=true);

error_thr = 1e-10;
sym_mismatches = (abs(Tx_syms-Rx_syms)>error_thr);  % Symbol erros
bit_mismatches = (Tx_bits~=decoded_bits);           % Bit errors
 
SER = sum(sym_mismatches)/N_sym;                    % SER calculation
BER = sum(sum(bit_mismatches))/(M*N_sym);           % BER calculation


