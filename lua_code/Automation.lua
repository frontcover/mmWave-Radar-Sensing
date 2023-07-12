---------------------------------- STARTUP -------------------------------------
------------------------ DO NOT MODIFY THIS SECTION ----------------------------
print("Hello")
-- mmwavestudio installation path
RSTD_PATH = RSTD.GetRstdPath()

-- Declare the loading function
dofile(RSTD_PATH .. "Startup.lua")

------------------------------ CONFIGURATIONS ----------------------------------
-- Use "DCA1000" for working with DCA1000
capture_device  = "DCA1000"

-- SOP mode
SOP_mode        = 2

-- RS232 connection baud rate
baudrate        = 921600
-- RS232 COM Port number
uart_com_port   = 3
-- Timeout in ms
timeout         = 1000

-- BSS firmware
bss_path        = "D:\\ti\\mmwave_studio_02_01_00_00\\rf_eval_firmware\\radarss\\xwr18xx_radarss.bin.bin"
-- MSS firmware
mss_path        = "D:\\ti\\mmwave_studio_02_01_00_00\\rf_eval_firmware\\masterss\\xwr18xx_masterss.bin"

adc_data_path   = "C:\Users\Mahmoud Al-Madi\Desktop\RNG Summer '23\mmWave-Radar-Sensing\data\raw_data\adc_data2.bin"

------------------------- Connect Tab settings ---------------------------------
-- Select Capture device
ret=ar1.SelectCaptureDevice(capture_device)
if(ret~=0)
then
    print("******* Wrong Capture device *******")
    return
end

-- SOP mode
ret=ar1.SOPControl(SOP_mode)
RSTD.Sleep(timeout)
if(ret~=0)
then
    print("******* SOP FAIL *******")
    return
end

-- RS232 Connect
ret=ar1.Connect(uart_com_port,baudrate,timeout)
RSTD.Sleep(timeout)
if(ret~=0)
then
    print("******* Connect FAIL *******")
    return
end

-- Download BSS Firmware
ret=ar1.DownloadBSSFw(bss_path)
RSTD.Sleep(2*timeout)
if(ret~=0)
then
    print("******* BSS Load FAIL *******")
    return
end

-- Download MSS Firmware
ret=ar1.DownloadMSSFw(mss_path)
RSTD.Sleep(2*timeout)
if(ret~=0)
then
    print("******* MSS Load FAIL *******")
    return
end

-- SPI Connect
ar1.PowerOn(1, --bCrcPresent
            1000, --bAckRequested 
            0, --trasportType, spi:0, RS232:1
            0) --portNum

-- RF Power UP
ar1.RfEnable()

------------------------- Other Device Configuration ---------------------------

-- ADD Device Configuration here

ar1.ChanNAdcConfig(1, 1, 0, 1, 1, 1, 1, 2, 1, 0)

ar1.LPModConfig(0, 0)

ar1.RfInit()
RSTD.Sleep(1000)

ar1.DataPathConfig(1, 1, 0)

ar1.LvdsClkConfig(1, 1)

ar1.LVDSLaneConfig(0, 1, 1, 1, 1, 1, 0, 0)

ar1.SetTestSource(4, 3, 0, 0, 0, 0, -327, 0, -327, 327, 327, 327, -2.5, 327, 327, 0, 0, 0, 0, -327, 0, -327, 
                      327, 327, 327, -95, 0, 0, 0.5, 0, 1, 0, 1.5, 0, 0, 0, 0, 0, 0, 0)
                      
ar1.ProfileConfig(0, 77, 100, 6, 60, 0, 0, 0, 0, 0, 0, 29.982, 0, 256, 10000, 0, 0, 30)

ar1.ChirpConfig(0, 0, 0, 0, 0, 0, 0, 1, 1, 0)

ar1.EnableTestSource(1)


ar1.FrameConfig(0,
                0,
                8,
                128,
                40,
                0,
                0,
                1)

ar1.CaptureCardConfig_EthInit("192.168.33.30", "192.168.33.180", "12:34:56:78:90:12", 4096, 4098)


_I_ UInt32	eLogMode	 - eLogMode, Raw mode : 1, Multimode:2
_I_ UInt32	eLvdsMode	 - eLvdsMode or Radar DeviceType: AR12xx or AR14:1, AR16xx or AR18xx or AR68xx:2:
_I_ UInt32	eDataXferMode	 - eDataXferMode, LVDS: 1, DMM:2
_I_ UInt32	eDataCaptureMode	 - eDataCaptureMode, EthernetMode:2, SDCard:1
_I_ UInt32	eDataFormatMode	 - eDataFormatMode, 12-bit:1, 14-bit:2, 16-bit:3

ar1.CaptureCardConfig_Mode(1, --eLogMode, Raw mode : 1, Multimode:2
                           2, --eLvdsMode or Radar DeviceType: AR12xx or AR14:1, AR16xx or AR18xx or AR68xx:2:
                           1, --eDataXferMode, LVDS: 1, DMM:2
                           2, --eDataCaptureMode, EthernetMode:2, SDCard:1
                           3, --eDataFormatMode, 12-bit:1, 14-bit:2, 16-bit:3
                           30) --u8Timer


ar1.CaptureCardConfig_PacketDelay(25)

--Start Record ADC data
ar1.CaptureCardConfig_StartRecord(adc_data_path, 1)
RSTD.Sleep(1000)

--Trigger frame
ar1.StartFrame()
RSTD.Sleep(5000)

------------------------- Close the Connection ---------------------------------
-- SPI disconnect
ar1.PowerOff()

-- RS232 disconnect
ar1.Disconnect()

------------------------- Exit MMwave Studio GUI -----------------------------------
os.exit()

-- end
