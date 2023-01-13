%% EE6323: Project
% Baseband receiver

%% Parameter initializations

M = 4;
N_slots = 10;
N_OFDM_sym = 14*N_slots;
N_PRBs = 273;
N_subcar = 12*N_PRBs;
N_CP = 288;
N_FFT = 2^ceil(log2(N_subcar));

%% File reading and Rx data vector creation 

V_ref = 5;
num_bits = 16;

I_data = readlines('Rx_I_data.txt');
I_quant = I_data(1:end-1);
Q_data = readlines('Rx_Q_data.txt');
Q_quant = Q_data(1:end-1);

I_vals = Deciconvert(I_quant,V_ref,num_bits);
Q_vals = Deciconvert(Q_quant,V_ref,num_bits);

Rx_vals = complex(I_vals,Q_vals);
Rx_vals = Rx_vals.';

Tx_syms = readmatrix('Tx_syms.csv');
Tx_bits = readmatrix('Tx_bits.csv');

%% Baseband receiver chain

Rx_syms = BB_Rx_chain(Tx_syms,Rx_vals,M,N_subcar,N_FFT,N_CP,N_OFDM_sym);



