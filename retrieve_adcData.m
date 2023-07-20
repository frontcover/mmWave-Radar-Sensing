function adcData = retrieve_adcData(fileName, numFiles)

    %Reading in bin file data
    if numFiles == 1
        fid = fopen("data/raw_data/"+fileName+".bin",'r');
        adcData = fread(fid, 'int16');
    elseif numFiles == 2
        adcData = combine_bin_files(FileName, numFiles);
    end