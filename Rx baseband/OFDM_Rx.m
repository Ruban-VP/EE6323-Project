function [Y]= OFDM_Rx(Y_cp, M, Nused, Nfft, Ncp)

Y_fft = fft(Y_cp(Ncp+1:end)) ;                                     % Remove CP and take FFT /sqrt(Nfft)
        
kk3 = (Nfft-Nused)/2 + 1 : Nfft/2 ;
kk4 = Nfft/2 + 1 : (Nfft+Nused)/2 ; 
Ymod = [Y_fft(kk4) Y_fft(kk3)] ;                                   % extract the rx symbols from the data carriers
        
Y = qamdemod(Ymod,M) ;                                             % map received signal to [0 3] 

end