function [Rx_syms] = BB_Rx_chain(Tx_syms,Rx_vals,M,N_subcar,N_FFT,N_CP,N_OFDM_sym)

Rx_syms = zeros(N_subcar,N_OFDM_sym);

const_vals = 0:2^M-1;
constellation = qammod(const_vals,2^M,"gray",UnitaveragePower=true);

Rx_vals_resh = reshape(Rx_vals,N_FFT+N_CP,N_OFDM_sym);
IFFT_noisy_out = Rx_vals_resh(N_CP+1:end,:);

N_slots = N_OFDM_sym/14;
for i=1:N_slots
    curr_slot_pilot = Tx_syms(:,(i-1)*14+1);
    curr_slot_time_data = IFFT_noisy_out(:,(i-1)*14+1:i*14);
    curr_slot_freq_data = fft(curr_slot_time_data)/sqrt(N_FFT);
    curr_slot_freq_data = [curr_slot_freq_data(end-(N_subcar/2)+1:end,:); curr_slot_freq_data(1:N_subcar/2,:)];
    Rx_curr_slot_pilot = curr_slot_freq_data(:,1);
    
    % Channel estimation using least squares solution
    G = (curr_slot_pilot'*Rx_curr_slot_pilot)/(norm(curr_slot_pilot)^2);
    Rx_data = curr_slot_freq_data/G;

    for p=1:N_subcar
        for k=1:14
            diff = abs(constellation-Rx_data(p,k));
            [~,minind] = min(diff);
            Rx_syms(p,(i-1)*14+k) = constellation(minind);
        end
    end
end

end
