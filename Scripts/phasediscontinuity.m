% Phase Discontinuity Testing: 
% An effort to examine the effects of phase discontinuity from a spectral
% and human auditory perspective.

% Common parameters
t_dur = 5;	% seconds
fs = 44100; % samples/sec
t_step = 1/fs;
freq = 400; % hz
t = 0:t_step:t_dur;
signal_size = length(t);

% 1) Build pure sinusoid (no phase discontinuity)
signal1 = cos(2*pi*freq*t);

% 2) Build sinusoid with same frequency as before but now with phase
% discontinuity. The discontinuity is introduced by adding different
% segments with varying phase shifts.

segment_dur = 0.03; % seconds
segment_t = 0:t_step:segment_dur;
segment_size = length(segment_t);
total_segments = signal_size/segment_size;

signal_segment = zeros(1, segment_size);
signal2 = zeros(1, fs*t_dur+1);

% Build sinusoid with discontinuties
for i = 0:total_segments-1
   rand_phase = rand()*2*pi; % random phase
   signal_segment = cos(2*pi*freq*segment_t + rand_phase);  
   start = i*segment_size + 1;
   stop  = start + segment_size-1; 
   signal2(start:stop) = signal_segment; % insert segment into signal2
end

% Calculate the frequency spectrum of each signal
freq_res = 1/t_dur;
freqs = 0:freq_res:(fs/2);

spectrum1 = fft(signal1);
mag1 = abs(spectrum1);
mag1 = mag1(1:((length(mag1)-1)/2+1)); % ugly way of just taking first half
phase1 = angle(spectrum1);
phase1 = phase1(1:((length(phase1)-1)/2+1)); % ugly way of just taking first half

spectrum2 = fft(signal2);
mag2 = abs(spectrum2);
mag2 = mag2(1:((length(mag2)-1)/2+1));
phase2 = angle(spectrum2);
phase2 = phase1(1:((length(phase2)-1)/2+1));

% Compare/analyze
figure;
subplot(2,2,1);
plot(t, signal1);
title('Signal 1 Time Domain');
xlabel('time (s)');
ylabel('magnitude');

subplot(2,2,2);
plot(t, signal2);
title('Signal 2 Time Domain');
xlabel('time (s)');
ylabel('magnitude');

subplot(2,2,3);
title('Signal 1 Spectrum');
xlabel('Frequency (Hz)');
yyaxis left
ylabel('Magnitude');
plot(freqs, mag1);
yyaxis right
ylabel('Phase (deg)');
plot(freqs, phase1);

subplot(2,2,4);
title('Signal 2 Spectrum');
xlabel('Frequency (Hz)');
yyaxis left
ylabel('Magnitude');
plot(freqs, mag2);
yyaxis right
ylabel('Phase (deg)');
plot(freqs, phase2);

% Uncomment below to listen to audio effects introduced by phase discont.
%sound(signal1, fs);
%sound(signal2, fs);

% Bandpass filtering to 'clean up' phase discontinuity
% fc_anlg_up = freq+30;
% fc_anlg_lo = freq-30;
% wn_up = fc_anlg_up/fs/2;
% wn_lo = fc_anlg_lo/fs/2;
% [z, p, k] = butter(5, [wn_lo, wn_up], 'bandpass');
% sos = zp2sos(z,p,k);
% 
% y = sosfilt(sos, signal2);
% sound(y, fs);
% 
% figure;
% spectrum = fft(y);
% mag = abs(spectrum);
% mag = mag(1:((length(mag)-1)/2+1)); % ugly way of just taking first half
% phase = angle(spectrum);
% phase = phase(1:((length(phase)-1)/2+1)); % ugly way of just taking first half
% plot(freqs, mag);


