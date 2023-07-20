function plot_data(loco, chirpfft, distance, dbfs, locs, pks, phase_time, iqData, first_peak)

    disp("Polynomial fitting for removing fame reset artifacts...")
    x = 1:length(phase_time);
    poly_coeffs = polyfit(x,phase_time, 10);
    poly_remove = polyval(poly_coeffs, x);
    phase_time = phase_time - poly_remove;
    
    disp("Implementing high pass to remove low frequency noise...")
    vib_fs = floor((1 / frame_periodicity) * n_chirps);
    phase_time = highpass(phase_time, highpass_cutoff,vib_fs);
    
    mysize = size(phase_time);
    mytime = 0:chirpDuration*1e-6:chirpDuration*1e-6*(total_num_chirps-1);
    % phase_time_degrees=phase_time*(180/pi);
    
    disp("Implementing plots...")
    figure(1);
    subplot(3,2,1)
    phase_time= unwrap(phase_time);
    
    % phase_time = phase_time - mean(phase_time);
    % phase_time(phase_time > pi) = phase_time(phase_time > pi) - pi;   
    % phase_time(phase_time < -pi) = phase_time(phase_time < -pi) + pi;   
    
    plot(mytime,phase_time)
    title("Phase Plot for Experiment:" + strrep(exp_name,"_"," "))
    ylabel("Phase (Radians)")
    xlabel("Time (s)")
    % saveas(gcf,"figures/7_11_experiments/" + exp_name + "_phase_plot.png")
    
    
    phase_change = phase_time(1,1:total_num_chirps-1) - phase_time(1,2:total_num_chirps);
    vibrations = phase_time*4/(4*pi);
    
    subplot(3,2,2)
    plot(mytime(1,1:total_num_chirps), vibrations)
    title("Vibration plot for Experiment:"+ strrep(exp_name,"_"," "))
    ylabel("Vibration Displacement (mm)")
    xlabel("Time (s)")
    % saveas(gcf,"figures/7_11_experiments/" + exp_name + "_vibration_plot.png")
    
    subplot(3,2,3)
    spectrogram(vibrations,128,64,200, 10.2e3, "yaxis")
    title("Vibration Spectrogram for Experiment: " + strrep(exp_name,"_"," "))
    % ylim([0 200])
    xlabel("Time (s)")
    % saveas(gcf,"figures/7_11_experiments/" + exp_name + "_vib_spectrogram_plot.png")
    
    subplot(3,2,4)
    scatter(real(iqData)*1e-4,imag(iqData)*1e-4, "filled")
    max_x = max(real(iqData)*1e-4) + 1;
    max_y = max(imag(iqData)*1e-4) + 1;
    min_x = min(real(iqData)*1e-4) - 1;
    min_y = min(imag(iqData)*1e-4) - 1;
    title("IQ Plot for Experiment: " + strrep(exp_name,"_"," "))
    xlabel("In-Phase Component")
    ylabel("Quadrature Component")
    % xlim([min_x max_x])
    % ylim([min_y max_y])
    xline(0)
    yline(0)
    
    subplot(3,2,5)
    plot(distance, dbfs)
    hold on        
    myloc = locs(1);
    plot(distance(myloc),pks(1), "o");
    hold off
    xlabel("Distance (m) [∝ Frequency]")
    set(gca,'XMinorTick','on')
    ylabel("Frequency Magnitude (dBFS)")
    xlim([0 3])
    title("Range-FFT of "+ strrep(exp_name,"_"," "))
    % saveas(gcf,"figures/7_11_experiments/" + exp_name + "_iq_plot.png")
    
    subplot(3,2,6)
    plot([0 1 2 3],[0 1 2 3], "--","Color", [0 0 1])
    hold on
    scatter([1 1.5 2], [1.073 1.56  1.95],"Color", [1 0 0])
    hold off
    title("Radar Distance Reading vs Actual Distance")
    xlabel("Phone Placement (m)")
    ylabel("Radar Distance Reading (m)")
