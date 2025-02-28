# FM-SIGNAL-RECEIVER-USING-RTL-SDR-MATLAB
📡 RTL-SDR FM Receiver with GUI & Waterfall Spectrum
🔍 Project Overview
This project implements an FM radio receiver using an RTL-SDR (Software Defined Radio) dongle in MATLAB. The system captures, demodulates, filters, and plays FM audio in real-time while also providing a GUI for dynamic filter adjustment and a waterfall spectrum display.

📑 Key Components
RTL-SDR Receiver:

Captures FM signals from a selected radio frequency.
Converts RF signals into baseband complex signals (I/Q data).
FM Demodulation:

Extracts the audio signal from the modulated FM transmission.
Dynamic Low-Pass Filter (GUI-Controlled):

A Butterworth Low-Pass Filter removes high-frequency noise above 15 kHz.
GUI slider allows real-time adjustment of filter cutoff frequency.
Waterfall Spectrum Display:

Real-time visualization of the FM signal’s power spectrum.
Audio Playback:

The filtered audio signal is played live using MATLAB’s audioDeviceWriter.
🎯 Project Goals
✅ Real-time FM signal reception & demodulation
✅ Live noise filtering with user-controlled GUI
✅ Dynamic spectrum analysis (waterfall display)
✅ Efficient MATLAB implementation for smooth performance

This project demonstrates how software-defined radios (SDRs) can be used for FM broadcasting and provides an interactive way to analyze and process signals. 🚀📡🎧
