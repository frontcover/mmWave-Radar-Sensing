

time = 0:213e-6:213e-6*(total_no_chirps-3);
figure;
plot(time(1:total_no_chirps-4),phase_time(1,2:total_no_chirps-3) * 180 /pi)
title("Phase of Received Chirps - Phone at 2m Playing Audio")
xlabel("Time (s)")
ylabel("Phase (Degrees)")

phase_diff = phase_time(2:total_no_chirps)-phase_time(1:total_no_chirps-1);

displacement = phase_diff(2:total_no_chirps-1) * 4 / (4 * pi) * 1000;
displacement = displacement - noise;

% displacement = bandpass(displacement, [80 2e3],4292);
% sound(displacement,4292)

figure;
plot(time,displacement)
xlabel("Time (s)")
ylabel("Vibration Displacement (\mum)")
title("Vibration Measurement of Phone at 2m Playing Audio")
% mysize = size(myrealfft);
% myfft = abs(myrealfft);
% dbfs = 20 * log10(all_ffts(1101,:)/max(myfft));
% Fs = 1e7;
% 
% freq = [0:511] * Fs;
% 
% freq = (freq / NRangeBin) * 3e8 * (1/(30e12*2));
% 
% [pks, locs] = findpeaks(dbfs);
% 
% peeks = pks > -0.9;
% locs = locs(peeks);
% pks = pks(peeks);
% 
% figure;
% plot(freq(locs),pks, "o");
% hold on
% plot(freq, dbfs)
% hold off

