function [sig_out]= Bitconvert(sig_in,V_ref,num_bits)

sig_in_norm = (sig_in/V_ref)+1;                 % Normalized w.r.t reference voltage
sig_out = floor(sig_in_norm*(2^(num_bits-1)));  % Converted to decimal integers

end