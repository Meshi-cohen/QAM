# QAM
QAM Simulation: Analysis of 16-QAM and 256-QAM Modulation Orders

📡 QAM Modulation Simulation – 16-QAM & 256-QAM
MATLAB Communication Lab Project

# 📘 Overview
This project implements a full MATLAB simulation of Quadrature Amplitude Modulation (QAM) for two modulation orders: 16-QAM and 256-QAM.
The goal is to analyze how Additive White Gaussian Noise (AWGN) and varying SNR levels affect constellation distortion, eye diagrams, and bit error rate (BER).
The simulation demonstrates the trade-off between spectral efficiency and robustness to noise:
Higher-order QAM carries more bits per symbol but requires significantly higher SNR to achieve reliable performance.

# 🎯 Objectives
Generate random bitstreams and map them to QAM symbols
Perform ideal QAM modulation with unit average power
Add AWGN noise for a wide range of SNR values (5–40 dB)
Demodulate the noisy signals and compute BER
Plot:
  Pre-noise and post-noise constellation diagrams
  BER vs. SNR curves for comparison
  Eye diagrams for different noise levels

# 🧠 Key Concepts
QAM (Quadrature Amplitude Modulation)
Represents data using both amplitude and phase variations
Combines two orthogonal carriers (I & Q components)
Supports high spectral efficiency
Modulation Orders
Modulation	Points	Bits/Symbol	Characteristics
16-QAM	16	4	More robust to noise, lower data rate
256-QAM	256	8	High data rate, high SNR required
AWGN (Additive White Gaussian Noise) - Models thermal noise that spreads uniformly over the spectrum.
BER (Bit Error Rate) - <img width="276" height="69" alt="image" src="https://github.com/user-attachments/assets/b5fd36ea-36e0-4191-9280-71cb5093485d" />

# 📌 Conclusions
Higher SNR results in lower BER, as expected in digital communication systems.
256-QAM is far more sensitive to noise compared to 16-QAM.
For noisy environments, low-order QAM is preferable due to robustness.
For high-throughput clean channels, high-order QAM is optimal.

# 👥 Authors
Liav Raccah
Meshi Cohen
