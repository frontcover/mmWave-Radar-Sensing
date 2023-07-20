function adcData = combine_bin_files(exp_name)
    fid = fopen("../data/raw_data/" + exp_name + ".bin",'r');
    adcData1 = fread(fid, 'int16');
    fclose(fid);
    fid = fopen("../data/raw_data/" + exp_name(1:strlength(exp_name)-1) + "1.bin",'r');
    adcData2 = fread(fid, 'int16');
    fclose(fid);
    adcData = vertcat(adcData1, adcData2);
end