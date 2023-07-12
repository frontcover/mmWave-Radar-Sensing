classdef mmWave_Sensing
    properties
        numRX
        numADCBits
        numADCSamples
        exp_name
        adcData
        chirp_slope
        combined_data
        Fs = 1e7
    end
    methods
        function obj = mmWave_Sensing(numRX, numADCBits,numADCSamples,chirpSlope, exp_name)
            obj.numADCBits = numADCBits;
            obj.numRX = numRX;
            obj.numADCSamples = numADCSamples;
            obj.exp_name = exp_name;
            obj.chirp_slope = chirpSlope;
        end
    end
    methods(Static)
        function adcData = local_reading_bin_file()

            % numADCBits - number of ADC bits per sample
            % numRX - number of receivers
            numLanes = 2; % do not change. number of lanes is always 2
            isReal = 0; % set to 1 if real only data, 0 if complex data0          

            adcData = mmWave_Sensing.combine_bin_files();
            
            fileSize = size(adcData, 1);
            
            % if 12 or 14 bits ADC per sample compensate for sign extension
            if obj.numADCBits ~= 16
                l_max = 2^(obj.numADCBits-1)-1;
                adcData(adcData > l_max) = adcData(adcData > l_max) - 2^obj.numADCBits;
            end
            
            fileSize = size(adcData, 1);
            
            % real data reshape, filesize = numADCSamples*numChirps
            if isReal
                numChirps = fileSize/obj.numADCSamples/obj.numRX;
                LVDS = zeros(1, fileSize);
                %create column for each chirp
                LVDS = reshape(adcData, obj.numADCSamples*obj.numRX, numChirps);
                %each row is data from one chirp
                LVDS = LVDS.';
            else
                % for complex data
                % filesize = 2 * numADCSamples*numChirps
                numChirps = fileSize/2/obj.numADCSamples/obj.numRX;
                LVDS = zeros(1, fileSize/2);
                %combine real and imaginary part into complex data
                %read in file: 2I is followed by 2Q
                counter = 1;
               
                for i = 1:4:fileSize-1
                    LVDS(1,counter) = adcData(i) + sqrt(-1)*adcData(i+2); 
                    LVDS(1,counter+1) = adcData(i+1)+sqrt(-1)*adcData(i+3); 
                    counter = counter + 2;
               
                end
                
                % create column for each chirp
                LVDS = reshape(LVDS, obj.numADCSamples*obj.numRX, numChirps);
                %each row is data from one chirp
                LVDS = LVDS.';
            end
            %organize data per RX
            adcData = zeros(obj.numRX,numChirps*obj.numADCSamples);
            for row = 1:obj.numRX
                for i = 1: numChirps
                    adcData(row, (i-1)*obj.numADCSamples+1:i*obj.numADCSamples) = LVDS(i, (row-1)*obj.numADCSamples+1:row*obj.numADCSamples);
                end
            end

        end

        
        function adcData = combine_bin_files()
            disp(obj.numRX)
            fid = fopen("data/raw_data/" + obj.exp_name + "_Raw_0.bin",'r');
            adcData1 = fread(fid, 'int16');
            fclose(fid);
            fid = fopen(file2,'r');
            adcData2 = fread(fid, 'int16');
            fclose(fid);
            adcData = vertcat(adcData1, adcData2);
        end
    end
    methods
        function location = range_fft_locator(chirpData, chirpId, window, shortest_cutoff,plot)
            
            %Setting up range-FFT parameters 
            if window=="black"
                win = blackman(obj.numADCSamples);
            elseif window=="rect"
                win = rectwin(obj.numADCSamples);
            elseif window=="han"
                win = hann(obj.numADCSamples);
            end
            NRangeBin = pow2(nextpow2(obj.numADCSamples));
            
            %performing range FFT
            myrealfft = fft(chirpData(chirpId,:) .* win', NRangeBin);
            
            %determining cutoff distance to ignore
            max_dist = ((obj.numADCSamples-1) * obj.Fs)/NRangeBin * 3e8 * (1/(obj.chirp_slope*2));
            cutoff = ceil(shortest_cutoff/ (max_dist/obj.numADCSamples));
            
            %finding peaks in range-FFT
            myfft = abs(myrealfft);
            dbfs = 20 * log10(myfft/max(myfft));
            [pks, locs] = findpeaks(dbfs);
            pks = pks((locs > cutoff));
            locs = locs(locs>cutoff);
            locs = locs((pks > -10));
            pks = pks((pks > -10));
            
            location = locs(1);
            
            if plot
                %setting up FFT plot axes
                freq= [0:obj.numADCSamples-1] * obj.Fs;
                dist = (freq / NRangeBin) * 3e8 * (1/(obj.chirp_slope*2));
                
                figure;
                plot(dist(locs),pks, "o");
                hold on
                
                plot(dist, dbfs)
                hold off
                xlabel("Distance (m) [∝ Frequency]")
                ylabel("Frequency Magnitude (dBFS)")
                title("Range-FFT of "+ obj.exp_name)
            end
        end

        function chirpMat = reshape_by_chirp(adcData, RX)
                
            %organizing data into matrix of chirps
            size_data = size(adcData);
            total_num_chirps = size_data(2)/obj.numADCSamples;
            rx0 = adcData(RX,:);
            chirpMat = reshape(rx0,[obj.numADCSamples, total_num_chirps]).'; 
        
        end
    end
end