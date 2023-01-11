function [Y_cp]= awgn_ch(X_cp, snr)

Y_cp = awgn(X_cp,snr,10*log10(var(X_cp))) ;                        % Addition of AWGN to signal  

end