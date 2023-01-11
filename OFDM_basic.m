clear all;
close all;


Nbps = 2 ;                                                                 % number of bits per symbol
M = 2^Nbps ;                                                               % Modulation Order = 2/4/6 for 4-QAM/16-QAM/64-QAM

Nfft = 4096 ;                                                              % FFT Size/ number of sub-carriers
Ncp = 288 ;                                                                % Length of Cyclic Prefix
Nsym = Nfft + Ncp ;                                                        % Symbol Duration
Nused = 273*12 ;                                                           % number of actual data symbols tx over 4096 carriers

EbNo = [0:1:12] ;                                                          % Data SNR for BER evaluation
N_iter = 1e3 ;                                                             % number of iterations for each Eb/No.
eng_sqrt = (M==2)+(M~=2)*sqrt((M-1)/6*(2^2)) ;                             % average energy per data symbol

ber = zeros(1,length(EbNo)) ;
ser = zeros(1,length(EbNo)) ;

ber_qpsk_analytical = qfunc(sqrt(2*10.^(EbNo/10))) ;

for i = 1:length(EbNo)
    N_error = 0; N_total = 0;                                              % number of error & total bits
    N_error_sym = 0; N_total_sym = 0;                                      % number of error & total symbols
    % measure signal power
    snr = EbNo(i) + 10*log10(Nbps*Nused/Nfft) ;                            % SNR vs Eb/No relation
    
    for m = 1:N_iter
        
        X_cp = OFDM_Tx(M, Nused, Nfft, Ncp) ;                              % OFDM Modulated Tx sequence
        
        Y_cp = awgn_ch(X_cp, snr) ;                                        % Addition of AWGN to signal        
        
        Y = OFDM_Rx(Y_cp, M, Nused, Nfft, Ncp) ;                           % OFDM De-Modulated Rx sequence
        
        N_error = N_error + sum(sum(de2bi(Y,Nbps)~=de2bi(X,Nbps))) ;       % record number of bit errors 
        N_error_sym = N_error_sym + sum(sum(Y~=X)) ;                       % record number of symbol errors 
        N_total = N_total + Nbps*Nused ;                                   % record number of bits received
        N_total_sym = N_total_sym + Nused ;                                % record number of symbols received
              
    end
    
    ber(i) = N_error/N_total ;
    ser(i) = N_error_sym/N_total_sym ;
end


semilogy(EbNo,ber_qpsk_analytical);
hold on;
semilogy(EbNo,ber,'ro');
semilogy(EbNo,ser);
xlabel('Eb/No (in dB)');
ylabel('BER/SER'); title(strcat('OFDM - BER & SER Plot for ',num2str(M),'-QAM'));
legend('BER QPSK Analytical',strcat('BER ',num2str(M),'-QAM Simulated'),strcat('SER',num2str(M),'-QAM Simulated'));
grid on;