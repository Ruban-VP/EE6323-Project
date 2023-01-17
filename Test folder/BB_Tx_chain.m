function [Tx_bits, Tx_syms, Tx_out] = BB_Tx_chain(M,N_subcar,N_FFT,N_CP,N_OFDM_sym)

N_sym = N_subcar*N_OFDM_sym;
Bits = randi([0,1],M,N_sym);                    % Random Tx bits are generated    
Xmod = qammod(Bits,2^M,"gray","InputType","bit",UnitaveragePower=true); % Symbol mapping
Xmod_resh = reshape(Xmod,N_subcar,N_OFDM_sym);  % Serial to Parallel conversion

% Place symbols on carriers such that index 0 symbol is placed on the central carrier 
kk1 = 1:N_subcar/2;
kk2 = N_FFT-(N_subcar/2)+1:N_FFT;

% Mount symbols on carriers
X_shift = zeros(N_FFT,N_OFDM_sym);
X_shift(kk1,:) = Xmod_resh((N_subcar/2)+1:N_subcar,:);
X_shift(kk2,:) = Xmod_resh(1:N_subcar/2,:);

X_ifft = sqrt(N_FFT)*ifft(X_shift);                % IFFT operation 
X_cp = [X_ifft(N_FFT-N_CP+1:N_FFT,:); X_ifft];     % Addition of Cyclic Prefix

Tx_out = reshape(X_cp,1,(N_FFT+N_CP)*N_OFDM_sym);  % Paralle to serial conversion
Tx_syms = Xmod_resh;
Tx_bits = Bits;

end