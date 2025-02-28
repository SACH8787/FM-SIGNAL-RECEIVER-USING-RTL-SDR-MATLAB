clc; clear; close all;

%% 🎯 Define Basic RTL-SDR Receiver Parameters
fmFreq = 93.50e6;  % Change to your local FM station (e.g., 95.0 MHz)
%fmFreq = 122.30e6;
sampRate = 250e3;  % Lowered to 250 kHz for stability
audioRate = 48000; % Standard audio sample rate
frameLength = 4000; % Multiple of 200 to prevent buffer issues
rtl_gain = 25; % Gain setting for RTL-SDR
freqCorrection = 0; % Adjust if needed (-100 to 100)

%% 📡 Create RTL-SDR Receiver
rx = comm.SDRRTLReceiver('CenterFrequency', fmFreq, ...
    'SampleRate', sampRate, 'SamplesPerFrame', frameLength, ...
    'EnableTunerAGC', true, 'TunerGain', rtl_gain, ...
    'FrequencyCorrection', freqCorrection, 'OutputDataType', 'double');

%% 🎵 Create FM Demodulator
fmDemod = comm.FMBroadcastDemodulator('SampleRate', sampRate, ...
    'FrequencyDeviation', 75e3, 'AudioSampleRate', audioRate, 'Stereo', false);

%% 🔊 Create Audio Player
player = audioDeviceWriter('SampleRate', audioRate);

%% 📊 Create Spectrum Analyzer for Waterfall Display
spectrumAnalyzer = dsp.SpectrumAnalyzer('SampleRate', sampRate, ...
    'Title', 'FM Waterfall Spectrum', 'ShowLegend', false, ...
    'FrequencySpan', 'Full', 'TimeSpanSource', 'Property', 'TimeSpan', 5);

%% 🚀 GUI for Filter Settings
global cutoffFreq;
cutoffFreq = 15000; % Default cutoff at 15 kHz
fig = uifigure('Name', 'Filter Control', 'Position', [100 100 300 150]);
slider = uislider(fig, 'Position', [50 80 200 3], 'Limits', [1000 20000], ...
    'Value', cutoffFreq, 'ValueChangedFcn', @(src, event) updateFilter(src.Value));
uilabel(fig, 'Position', [50 100 200 20], 'Text', 'Adjust Low-Pass Cutoff');

function updateFilter(newFreq)
    global cutoffFreq;
    cutoffFreq = newFreq;
end

%% 🔄 Continuous FM Reception and Playback Loop
disp('🎶 Receiving FM... Adjust filter in GUI');

while ishandle(fig) % Run while GUI is open
    try
        % 📡 Receive Baseband Samples
        rxData = rx();
        
        % 📊 Display Waterfall Spectrum
        spectrumAnalyzer(rxData);
        
        % 🎵 FM Demodulation
        audioSignal = fmDemod(rxData);

        % 🚀 Dynamic Butterworth Low-Pass Filter (Adjustable via GUI)
        
        [b, a] = butter(6, cutoffFreq/(audioRate/2), 'low');
        filteredAudio = filter(b, a, audioSignal);

        % 🔊 Play the Filtered Audio
        player(filteredAudio);
        
    catch ME
        disp(['❌ Error: ', ME.message]);
        break; % Exit loop on error
    end
end

%% 🛑 Release System Objects
release(rx); release(player); release(spectrumAnalyzer);
disp('✅ FM Reception Stopped.');
