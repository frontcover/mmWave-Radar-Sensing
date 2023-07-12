function chirpMat = reshape_by_chirp(adcData, numADCSamples, RX)

    %organizing data into matrix of chirps
    size_data = size(adcData);
    total_num_chirps = size_data(2)/numADCSamples;
    rx0 = adcData(RX,:);
    chirpMat = reshape(rx0,[numADCSamples, total_num_chirps]).'; 

end