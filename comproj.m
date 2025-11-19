clc; clear; close all;

% Parameters
numSymbols = 10000; % Increased for better accuracy
SNR_dB_range = 5:2:30; % Higher SNR range for less noise
SNR_dB_constellation = 20; % Higher SNR for clearer constellation
bitsPerSymbol_16QAM = 4;
bitsPerSymbol_64QAM = 6;
M_16QAM = 16;
M_64QAM = 64;
samplesPerSymbol = 8; % Used for pulse shaping

% Generate random data
data_16QAM = randi([0 1], numSymbols * bitsPerSymbol_16QAM, 1);
data_64QAM = randi([0 1], numSymbols * bitsPerSymbol_64QAM, 1);

% Convert to symbols
sym_16QAM = bi2de(reshape(data_16QAM, bitsPerSymbol_16QAM, []).', 'left-msb');
sym_64QAM = bi2de(reshape(data_64QAM, bitsPerSymbol_64QAM, []).', 'left-msb');

% Modulate with normalized power
modulated_16QAM = qammod(sym_16QAM, M_16QAM, 'UnitAveragePower', true);
modulated_64QAM = qammod(sym_64QAM, M_64QAM, 'UnitAveragePower', true);

% Pulse shaping using a raised cosine filter
txFilter_64 = rcosdesign(0.1, 6, samplesPerSymbol); % Raised cosine filter (roll-off 0.25, span 6 symbols)
txFilter_16 = rcosdesign(0.25, 4, samplesPerSymbol);
filtered_16QAM = upfirdn(modulated_16QAM, txFilter_16, samplesPerSymbol, 1);
filtered_64QAM = upfirdn(modulated_64QAM, txFilter_64, samplesPerSymbol, 1);

% Plot Eye Diagram for 16-QAM
eyediagram(real(filtered_16QAM(1:5000)), samplesPerSymbol);
title('Eye Diagram of 16-QAM');
grid on;

% Plot Eye Diagram for 64-QAM
eyediagram(real(filtered_64QAM(1:10000)), samplesPerSymbol);
title('Eye Diagram of 64-QAM');
grid on;

% Add AWGN noise for constellation display (less noise)
noisy_16QAM_constellation = awgn(modulated_16QAM, SNR_dB_constellation, 'measured');
noisy_64QAM_constellation = awgn(modulated_64QAM, SNR_dB_constellation, 'measured');

filtered_16QAM = upfirdn(noisy_16QAM_constellation, txFilter_16, samplesPerSymbol, 1);
filtered_64QAM = upfirdn(noisy_64QAM_constellation, txFilter_64, samplesPerSymbol, 1);

% Plot Eye Diagram for 16-QAM
eyediagram(real(filtered_16QAM(1:5000)), samplesPerSymbol);
title('Eye Diagram of 16-QAM');
grid on;

% Plot Eye Diagram for 64-QAM
eyediagram(real(filtered_64QAM(1:10000)), samplesPerSymbol);
title('Eye Diagram of 64-QAM');
grid on;
% BER simulation
ber_16QAM = zeros(size(SNR_dB_range));
ber_64QAM = zeros(size(SNR_dB_range));

for i = 1:length(SNR_dB_range)
    SNR_dB = SNR_dB_range(i);
    
    % Add noise with increasing SNR (less noise)
    noisy_16QAM = awgn(modulated_16QAM, SNR_dB, 'measured');
    noisy_64QAM = awgn(modulated_64QAM, SNR_dB, 'measured');
    
    % Demodulate
    demod_16QAM = qamdemod(noisy_16QAM, M_16QAM, 'UnitAveragePower', true);
    demod_64QAM = qamdemod(noisy_64QAM, M_64QAM, 'UnitAveragePower', true);
    
    % Convert back to binary
    received_16QAM = reshape(de2bi(demod_16QAM, bitsPerSymbol_16QAM, 'left-msb').', [], 1);
    received_64QAM = reshape(de2bi(demod_64QAM, bitsPerSymbol_64QAM, 'left-msb').', [], 1);
    
    % Compute BER
    ber_16QAM(i) = sum(received_16QAM ~= data_16QAM) / length(data_16QAM);
    ber_64QAM(i) = sum(received_64QAM ~= data_64QAM) / length(data_64QAM);
end

% ----- Plot Constellation Diagrams Before and After Noise -----

% 16-QAM Constellation (Without Noise)
scatterplot(modulated_16QAM);
title('16-QAM Without Noise');
grid on;
axis([-1.5 1.5 -1.5 1.5]); 

% 16-QAM Constellation (With Noise)
scatterplot(noisy_16QAM_constellation);
title(['16-QAM With AWGN (SNR = ', num2str(SNR_dB_constellation), ' dB)']);
grid on;
axis([-1.5 1.5 -1.5 1.5]); 

% 64-QAM Constellation (Without Noise)
scatterplot(modulated_64QAM);
title('64-QAM Without Noise');
grid on;
axis([-2 2 -2 2]);

% 64-QAM Constellation (With Noise)
scatterplot(noisy_64QAM_constellation);
title(['64-QAM With AWGN (SNR = ', num2str(SNR_dB_constellation), ' dB)']);
grid on;
axis([-2 2 -2 2]);

% ----- Plot BER vs. SNR -----
figure;
semilogy(SNR_dB_range, ber_16QAM, 'ro-', 'LineWidth', 2); hold on;
semilogy(SNR_dB_range, ber_64QAM, 'bs-', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs. SNR for 16-QAM and 64-QAM (Less Noise)');
legend('16-QAM', '64-QAM');