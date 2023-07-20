# Rice Networks Group - mmWave Sensing for Measuring Millimeter and Micrometer Vibrations


## Prerequisites

* Software Prerequisites
    - Install the Signal Processing Toolbox add-on within Matlab

##

## Operating the Signal Processing Pipeline


- *Data Placement*
    - Before clicking on the "DCA1000 ARM" button shown below. Replace the the path shown below with the following: "<path_to_repo>\mmWave-Radar-Sensing\data\raw_data"

    <img src="https://i.ibb.co/jk34Tdc/mmwave-personal-Demo.png" alt="drawing" height="300"/>

    - Depending on the amount of data captured by the radar, mmWave Studio will save 1 or more files because each file it produces has to be at most 1 GB. Currently, the signal processing pipeline
    can only accomodate an exeriment with up to two files; however, the pipeline can be easily adjusted to accomodate more than 2 files per experiment

- *Saving Chrip Configuration*

    - Make sure that you save the chrip configuration for your experiment because the chirp parameters are needed for signal processing later. Feel free to save the file under "<path_to_repo>\mmWave-Radar-Sensing\data\raw_data"

    <img src="https://i.ibb.co/9h0ykcG/mmwave-personal-Demo-2.png" alt="drawing" height="300"/>

- *Running Pipeline Matlab Code*
    - Open the *signal_processing_pipeline.m* file. This is the only file you will need to use.
    - Enter the parameters corresponding to the setup of your experiment in the first section of code
    - Run the rest of the sections in the file to produce the plots corresponding to the results of the experiment, which are currently as follows
        - **Phase Plot**
            - Plotting unwrapped and highpassed phase versus time
        - **Vibration Plot**
            - Plotting vibration versus time. Directly derived from phase plot
        - **Phase Spectrogram**
            - Spectrogram of phase vs time data
        - **IQ Plot**
            - Plotting IQ samples corresponding to the phase of the reverberating object
        - **Range-FFT**
            - Range-FFT of a given chirp. The peak out of which the phase data was extracted is circled
        - **FFT of Phase vs Time**
            - Frequency power spectrum of the phase over time data
    - Important notes
        - As mentioned earlier, the pipeline can currently accomodate up to 2 .bin data files per experiment. Be aware of how many .bin data files are produced by the experiment before operating the pipeline
        - The plotting function sometimes fails to plot the first two of the six included plots. However, that can easily be worked around by rerunning the plotting function

All signal processing files are in the root directory. 

## Repository Structure

    - [ ] *data*
        - [ ] *chirp_configurations*: used for storing chirp configuration to store the parameters needed for running the signal processing pipeline
        - [ ] *raw_data*: used for storing mmWave Studio produced data. This directory is used in the signal processing pipeline
    - [ ] *lua_code*: The lua_code directory consists of files that can be used within mmWave Studio to automate radar operation. Currently not developed nor relevant. Stored in case it's useful for later.
    - [ ] *matlab_dsp_pipeline*: stores the entire MATLAB based signal processing and results plotting pipeline
        - **combine_bin_files.m**: MATLAB function used for combining the data from multiple .bin files if the experiment requires multiple .bin data files
        - **local_reading_bin_file.m**: MATLAB function used for converting .bin data to the corresponding IQ ADC samples per receiver that were collected by the radar
        - **phase_data.m**: MATLAB function that extracts the phase data corresponding to the reverberating object accross all of the chirps
        - **plot_data.m**: MATLAB function the plots all the results in 6 plots as described in the *Running Pipeline Matlab Code* subsection under *Operating the Signal Processing Pipeline* section
        - **range_fft_locator.m**: MATLAB function for performing range-FFT on given chirp and identifies closest object
        - **reshape_by_chrip.m**: MATLAB function for reshaping the single rowed receiver data to a matrix where each row corresponds to the ADC samples corresponding to each chirp
        - **retrieve_adcData.m**: MATLAB function for reading .bin file into raw numeric data
        - **signal_processing_pipeline.m**: MATLAB file for compiling all of the other function into a complete end-to-end pipeline for processing the radar data and generating the results