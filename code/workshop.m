numADCSamples = 256;
Fs = 1e7;
numRX = 4;
numADCBits = 16;
chirp_slope = 105e12;
exp_name = "lab_room_idle_phone";
% combined_bin_files = combine_bin_files("data/raw_data/" + exp_name + "_Raw_0.bin", "data/raw_data/" + exp_name + "_Raw_1.bin");
% adcData = local_reading_bin_file(combined_bin_files,numRX,16,numADCSamples);


% frameData = reshape_by_chirp(adcData, 1);
% all_phases = zeros(total_num_chirps, numADCSamples);
% phase_time = zeros(1, total_num_chirps);

% plot_my_fft(frameData, 400, numADCSamples, "han", Fs, chirp_slope, strrep(exp_name,"_"," "), 0.5, false)

% win = hann(numADCSamples);
%finding phase corresponding to desired range bin
% find_obj = fft(frameData(1,:) .* win', NRangeBin);
% dbfs = 20 * log10(abs(find_obj)/max(abs(find_obj)));
% [pks, locs] = findpeaks(dbfs);
% peeks = pks > -10;
% locs = locs > 10;
% locs = locs(peeks);
% pks = pks(peeks);
% loc = find(dbfs > -10);

% obj_loc = loc(1);
% phases = angle(find_obj);
% phase_time(1,1) = phases(obj_loc);

