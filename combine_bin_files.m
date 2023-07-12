function adcData = combine_bin_files(exp_name)
    fid = fopen("data/raw_data/" + exp_name + "_0.bin",'r');
    adcData1 = fread(fid, 'int16');
    fclose(fid);
    fid = fopen("data/raw_data/" + exp_name + "_1.bin",'r');
    adcData2 = fread(fid, 'int16');
    fclose(fid);
    adcData = vertcat(adcData1, adcData2);
end