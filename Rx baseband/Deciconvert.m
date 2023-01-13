function [sig_out]= Deciconvert(sig_in,V_ref,num_bits)

dec_ints = hex2dec(sig_in);                   % Converted to decimal integers
dec_vals = dec_ints/(2^(num_bits-1));         % Converted to normalized fractions
sig_out = V_ref*(dec_vals-1);                 % Shifting and scaling w.r.t reference voltage

end