function [Rx_syms] = BB_Rx_chain(Tx_syms,Rx_vals,M,N_subcar,N_FFT,N_CP,N_OFDM_sym)

Rx_syms = zeros(N_subcar,N_OFDM_sym);

% Symbol constellation is stored in an array
constellation = qammod(0:(2^M-1),2^M,"gray",UnitaveragePower=true); 

Rx_vals_resh = reshape(Rx_vals,N_FFT+N_CP,N_OFDM_sym); % Serial to parallel conversion
IFFT_noisy_out = Rx_vals_resh(N_CP+1:end,:);  % CP removal

N_slots = N_OFDM_sym/14;
for i=1:N_slots

    % First OFDM symbol of a slot is assumed to be the block pilot for that slot
    curr_slot_pilot = Tx_syms(:,(i-1)*14+1);
    curr_slot_time_data = IFFT_noisy_out(:,(i-1)*14+1:i*14);
    curr_slot_freq_data = fft(curr_slot_time_data)/sqrt(N_FFT);
    curr_slot_freq_data = [curr_slot_freq_data(end-(N_subcar/2)+1:end,:); curr_slot_freq_data(1:N_subcar/2,:)];
    Rx_curr_slot_pilot = curr_slot_freq_data(:,1);
    
    % Channel estimation and equalization using block pilot 
    G = Rx_curr_slot_pilot./curr_slot_pilot;
    Rx_data = curr_slot_freq_data./G;

    % Nearest neighbour decoding is done on received symbols
    for p=1:N_subcar
        for k=1:14
            diff = abs(constellation-Rx_data(p,k));
            [~,minind] = min(diff);
            Rx_syms(p,(i-1)*14+k) = constellation(minind);
        end
    end
end

end