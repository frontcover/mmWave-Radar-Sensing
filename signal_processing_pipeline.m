clear 

%run this cell to set all your parameters as per the settings you chose
%in mmWave

numADCSamples = 256; numADCBits = 16; chirp_slope = 105e12; Fs = 1e7;

% Can currently only take in up to 2 files
% If the experiment data is contained in more than one file, only enter
% the name of the first file produces (e.g. exp_1_Raw_0)
% enter relative path within data/raw_data directory without .bin extension
fileName = "7_18/slowdrums_speaker_absorber_exp_Raw_0"; 

numRX = 4; % number of recievers used
chirId = 100; % which chirp to use for Range-FFT, doesn't matter for static experiments                
n_chirps = 128; % number of chirps per experiment
chirpDuration = 98; % idle time + ramp end time as per mmWave Studio Settings (in microseconds)
frame_periodicity = 12.6e-3; % as per mmWave Studio Settings (in seconds)
highpass_cutoff = 80; % frequency cutoff for high-pass filter use for phase data
FFT_window = "han"; % window used for FFT

%%

% run this cell to read in .bin file to convert bin data to IQ radar readings

[chirpData, total_num_chirps] = process_radar_data(char(fileName), numRX, ...
    whichRX, numADCBits, numADCSamples, numFiles);

%% 

%run this cell to perform range FFT and extract vibrations phase data

disp("Identifying range of nearest object...")
[loco, chirpfft, distance, dbfs, locs, pks] = range_fft_locator( ...
    numADCSamples, chirp_slope, Fs, chirpData, chirId, "han",0.5, ...
    strrep(exp_name,"_"," "),false);

disp("Extracting phase of nearest object...")
[phase_time, iqData, first_peak] = phase_data(loco, total_num_chirps, ...
    chirpData, FFT_window, numADCSamples);

%%

%run this cell to produce all plots once you've run all of the previous
%cells. May need to rerun this cell if the first two plots do not appear
%after the first time you run this cell
plot_data(loco, chirpfft, distance, dbfs, locs, pks, phase_time, ...
    iqData, first_peak)