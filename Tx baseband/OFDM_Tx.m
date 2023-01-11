function [X_cp]= OFDM_Tx(M, Nused, Nfft, Ncp)

X = randi([0 M-1], 1, Nused) ;
Xmod = qammod(X,M) ;                                               % Generate random Tx symbols

% place symbols on carriers such that index 0 symbol is placed on the central carrier 
kk1 = 1:Nused/2 ;
kk2 = Nused/2 + 1 :Nused ;
X_shift = [zeros(1,(Nfft-Nused)/2) Xmod(kk2) Xmod(kk1) zeros(1,(Nfft-Nused)/2)] ; % Mount symbols on carriers

X_ifft = ifft(X_shift) ;                                           % IFFT operation 
X_cp = [X_ifft(1,Nfft-Ncp+1:Nfft) X_ifft];                         % Addition of Cyclic Prefix

end