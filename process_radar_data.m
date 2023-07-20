function [chirpData, total_num_chirps] = process_radar_data(fileName, numRX,whichRX, numADCBits, numADCSamples, numFiles)
    
    %retrieve adcData from bin file
    adcData = retrieve_adcData(fileName, numFiles);

    %converting bin file data to receiver IQ data
    disp("Reading in bin file...")
    rxData = local_reading_bin_file(adcData, numRX, numADCBits, numADCSamples);
    disp("Organizing raw data...")
    chirpData = reshape_by_chirp(rxData,numADCSamples, whichRX);
    
    size_data = size(chirpData);
    
    total_num_chirps  = size_data(1);

end