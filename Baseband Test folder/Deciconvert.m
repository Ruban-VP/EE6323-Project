function [sig_out]= Deciconvert(sig_in,V_ref,num_bits)

dec_vals = sig_in/(2^(num_bits-1));  % Converted to normalized fractions
sig_out = V_ref*(dec_vals);        % Shifting and scaling w.r.t reference voltage

end