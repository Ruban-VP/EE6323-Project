%% EE6323: Project
% Baseband transmitter

%% Parameter initializations

M = 4;
N_slots = 10;
N_OFDM_sym = 14*N_slots;
N_PRBs = 273;
N_subcar = 12*N_PRBs;
N_CP = 288;
N_FFT = 2^ceil(log2(N_subcar));

%% Baseband transmitter chain

[Tx_bits, Tx_syms, Tx_out] = BB_Tx_chain(M,N_subcar,N_FFT,N_CP,N_OFDM_sym);
I_vals = real(Tx_out);
Q_vals = imag(Tx_out);

%% Converting data to finite precision

V_ref = 5;
num_bits = 16;
I_quant = Bitconvert(I_vals,V_ref,num_bits);
Q_quant = Bitconvert(Q_vals,V_ref,num_bits);

writematrix(I_quant,'Tx_I_data.txt');
writematrix(Q_quant,'Tx_Q_data.txt');

%% Writing Tx bits and symbols into file for SER/BER simulation

writematrix(Tx_bits,'Tx_bits.csv');
writematrix(Tx_syms,'Tx_syms.csv');