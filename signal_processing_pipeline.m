clear 

numADCSamples = 256;
numADCBits = 16;
chirp_slope = 105e12;
Fs = 1e7;
exp_name = "vibstage_30hz_low_Raw";
numRX = 4;
chirId = 100;
n_chirps = 128;
chirpDuration = 98;

adcData = combine_bin_files(exp_name);

rxData = local_reading_bin_file(adcData, numRX, numADCBits, numADCSamples);

chirpData = reshape_by_chirp(rxData,numADCSamples, 1);

size_data = size(chirpData);

total_num_chirps  = size_data(1);

[loco, chirpfft, distance, dbfs, locs, pks] = range_fft_locator(numADCSamples, chirp_slope, Fs, chirpData, chirId, "han",0.5, strrep(exp_name,"_"," "),false);

[phase_time, iqData] = phase_data(loco, total_num_chirps, chirpData, "han", numADCSamples);

mysize = size(phase_time);
mytime = 0:chirpDuration*1e-6:chirpDuration*1e-6*(total_num_chirps-1);
phase_time_degrees=phase_time*(180/pi);

figure(1);
subplot(3,2,1)
plot(mytime,phase_time_degrees)
title("Phase Plot for Experiment:" + strrep(exp_name,"_"," "))
ylabel("Phase (Degrees)")
xlabel("Time (s)")
% saveas(gcf,"figures/7_11_experiments/" + exp_name + "_phase_plot.png")


phase_change = phase_time(1,1:total_num_chirps-1) - phase_time(1,2:total_num_chirps);
vibrations = phase_change*4e-3/(4*pi) * 1e6;

subplot(3,2,2)
plot(mytime(1,2:total_num_chirps), vibrations)
title("Vibration plot for Experiment:"+ strrep(exp_name,"_"," "))
ylabel("Vibration Displacement (\mum)")
xlabel("Time (s)")
% saveas(gcf,"figures/7_11_experiments/" + exp_name + "_vibration_plot.png")

subplot(3,2,3)
spectrogram(vibrations,128,64,200, 10.2e3, "yaxis")
title("Vibration Spectrogram for Experiment: " + strrep(exp_name,"_"," "))
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
xlim([min_x max_x])
ylim([min_y max_y])
xline(0)
yline(0)

subplot(3,2,5)
plot(distance, dbfs)
hold on        
plot(distance(locs),pks, "o");
hold off
xlabel("Distance (m) [∝ Frequency]")
ylabel("Frequency Magnitude (dBFS)")
title("Range-FFT of "+ strrep(exp_name,"_"," "))
% saveas(gcf,"figures/7_11_experiments/" + exp_name + "_iq_plot.png")