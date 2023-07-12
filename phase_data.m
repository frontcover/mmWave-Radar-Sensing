function [phase_time, iqData] = phase_data(location, total_num_chirps, chirpData, window, numADCSamples);
    
    NRangeBin = pow2(nextpow2(numADCSamples));
    
    %Setting up range-FFT parameters 
    if window=="black"
        win = blackman(numADCSamples);
    elseif window=="rect"
        win = rectwin(numADCSamples);
    elseif window=="han"
        win = hann(numADCSamples);
    end

    phase_time = zeros(1, total_num_chirps);
    iqData = zeros(1, total_num_chirps);
    for i=1:total_num_chirps
        curr_fft = fft(chirpData(i,:) .* win', NRangeBin);
        curr_phase = angle(curr_fft);
        phase_time(1,i) = curr_phase(location);
        iqData(1,i) = curr_fft(location);
    end

end