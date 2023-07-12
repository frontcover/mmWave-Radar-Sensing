NRangeBin = pow2(nextpow2(numADCSamples));

n_frames = 200;
n_chirps = 128;

total_no_chirps = n_frames * n_chirps;

rx0 = adcData(1,:);

frameData = reshape(rx0,[numADCSamples, total_no_chirps]).';

win = hann(512);
%win = blackman(Params.NSample);
%win = rectwin(Params.NSample);

all_ftts = zeros(total_no_chirps, numADCSamples);
all_phases = zeros(total_no_chirps, numADCSamples);

phase_time = zeros(1, total_no_chirps);
loc_time = zeros(1, total_no_chirps);

size(win)
size(frameData)
find_obj = fft(frameData(1,:) .* win', NRangeBin);
dbfs = 20 * log10(abs(find_obj)/max(abs(find_obj)));
loc = find(dbfs > -0.9);
obj_loc = loc(1);
phases = angle(find_obj);
loc_time(1,1) = phases(obj_loc);

tic
for i=2:total_no_chirps
    curr_phase = angle(fft(frameData(i,:) .* win', NRangeBin));
    phase_time(1,i) =  curr_phase(obj_loc);
end
toc
%myampfft = fft(frameData .* win', NRangeBin);
% 

myrealfft = fft(frameData(100,:) .* win', NRangeBin);
mysize = size(myrealfft);
myfft = abs(myrealfft);
% myfft = abs(myrealfft(1:mysize(2)/2));
dbfs = 20 * log10(myfft/max(myfft));
Fs = 1e7;

freq = [0:511] * Fs;

freq = (freq / NRangeBin) * 3e8 * (1/(30e12*2));

[pks, locs] = findpeaks(dbfs);

peeks = pks > -0.5;
locs = locs(peeks);
pks = pks(peeks);

figure;
plot(freq(locs),pks, "o");
hold on
plot(freq, dbfs)
hold off
xlabel("Distance (m) [∝ Frequency]")
ylabel("Frequency Magnitude (dBFS)")
title("Range-FFT of Phone Placed 2m Away")
% plot(freq(1,1:256), dbfs)

% figure;
% plot(angle(myrealfft))
%xlim([0 5])
% myreals

% %xdft = fftshift(fft(frameData));
% df = Fs/length(frameData);
% 

% 
% plot(freq, abs(xdft))
