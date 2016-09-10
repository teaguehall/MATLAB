% This function builds an individual sinusoid segment
function segment = buildSegment(segment, tdur, freq)
    segment_size = length(segment);
    t = linspace(0, tdur, segment_size);
    rand_phase = rand()*2*pi;
    segment = cos(2*pi*freq*t + rand_phase);
    