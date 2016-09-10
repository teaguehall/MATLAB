% This function builds a sinusoid with phase discontinuities via a
% combination segments
function signal = buildSignal(fs, tdur, freq, segs, window)

signal_size = fs*tdur;
segment_size = signal_size/segs;

signal = zeros(1, signal_size);
segment_size = round(segment_size);
segment = zeros(1, segment_size);

for i = 0:(segs-1)
    segment = buildSegment(segment, tdur/segs, freq);
    segment = applyWindow(segment, window);
    start = i*segment_size + 1;
    stop = start + segment_size -1;
    signal(start:stop) = segment;
end