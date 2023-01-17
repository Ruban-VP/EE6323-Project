%% EE6323: Project
% Baseband transmitter

%% Parameter initializations
 
M = 4;                           % Modulation index
N_slots = 10;                    % N0. of slots
N_OFDM_sym = 14*N_slots;         % No. of OFDM symbols
N_PRBs = 273;                    % No. of PRBs occupied
N_subcar = 12*N_PRBs;            % No. of subcarriers occupied 
N_CP = 288;                      % Cyclic prefix length 
N_FFT = 2^ceil(log2(N_subcar));  % Minimum FFT length required
fs = N_FFT*30e-3;                % Sampling frequency in MHz

%% Baseband transmitter chain

% Baseband Tx operations are performed
[Tx_bits, Tx_syms, Tx_out] = BB_Tx_chain(M,N_subcar,N_FFT,N_CP,N_OFDM_sym);
I_vals = real(Tx_out);  % In-phase data
Q_vals = imag(Tx_out);  % Quadrature-phase data

% Tx signal spectrum
figure(1)
pspectrum(Tx_out,fs);
xlabel('Frequency (in MHz)');
ylabel('PSD (in dBm/Hz)');
title('PSD plot of Tx signal');

%% Converting data to finite precision

V_ref = 5;       % Quantization reference voltage
num_bits = 16;   % Quantization resolution
% I and Q signals are quantized
I_quant = Bitconvert(I_vals,V_ref,num_bits);
Q_quant = Bitconvert(Q_vals,V_ref,num_bits);

writematrix(I_quant.','Tx_I_data.txt');
writematrix(Q_quant.','Tx_Q_data.txt');

%% Writing Tx bits and symbols into file for SER/BER simulation

writematrix(Tx_bits,'Tx_bits.csv');
writematrix(Tx_syms,'Tx_syms.csv');