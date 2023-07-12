function [location, chripfft, dist, dbfs, locs, pks] = range_fft_locator(numADCSamples, chirp_slope, Fs, chirpData, chirpId, window, shortest_cutoff,exp_name,with_plot);
    
    %Setting up range-FFT parameters 
    if window=="black"
        win = blackman(numADCSamples);
    elseif window=="rect"
        win = rectwin(numADCSamples);
    elseif window=="han"
        win = hann(numADCSamples);
    end
    NRangeBin = pow2(nextpow2(numADCSamples));

    %performing range FFT
    chripfft = fft(chirpData(chirpId,:) .* win', NRangeBin);

    %determining cutoff distance to ignore
    max_dist = ((numADCSamples-1) * Fs)/NRangeBin * 3e8 * (1/(chirp_slope*2));
    cutoff = ceil(shortest_cutoff/ (max_dist/numADCSamples));

    %finding peaks in range-FFT
    myfft = abs(chripfft);
    dbfs = 20 * log10(myfft/max(myfft));
    [pks, locs] = findpeaks(dbfs);
    pks = pks((locs > cutoff));
    locs = locs(locs>cutoff);
    locs = locs((pks > -10));
    pks = pks((pks > -10));

    %setting up FFT plot x-axis
    freq= [0:numADCSamples-1] * Fs;    
    dist = (freq / NRangeBin) * 3e8 * (1/(chirp_slope*2));

    location = locs(1);
    if with_plot
        
        figure;           
        plot(dist, dbfs)
        hold on        
        plot(dist(locs),pks, "o");
        hold off
        xlabel("Distance (m) [∝ Frequency]")
        ylabel("Frequency Magnitude (dBFS)")
        title("Range-FFT of "+ exp_name)
    end
end
