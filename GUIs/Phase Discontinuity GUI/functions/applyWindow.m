% This function applies a window type to the signal segment
function segment = applyWindow(segment, type)

    size = length(segment);
    n = 0:size-1;
    window = zeros(1, size);
    
    switch type
        
        case window_type.Rectangle
                         
        case window_type.Triangle
            halflength = floor(length(window)/2);
            window(1:halflength) = linspace(0, 1, halflength);
            window(halflength+1:length(window)) = linspace(1, 0, length(window)-halflength);
            segment = segment.*window;
                         
        case window_type.Parzen
            window = transpose(parzenwin(size));
            segment = segment.*window; 
            
        case window_type.Welch
            window = 1 - ((n-((size-1)/2))/((size-1)/2)).^2;
            segment = segment.*window;
                         
        case window_type.Hanning
                         
        case window_type.Hamming
                         
        case window_type.Blackman
                         
        case window_type.Nutall
                         
        case window_type.BlackmanNutall
                         
        case window_type.BlackmanHarris
                         
        case window_type.FlatTop
                         
        case window_type.RiceVincent           
                         
        case window_type.Cosine
            window = sin(pi*n/(size-1));
            segment = segment.*window;
                         
        case window_type.Gaussian
                         
        case window_type.ConfinedGaussian
                         
        case window_type.ApproxConfinedGuassian
                         
        case window_type.GeneralNormal
                         
        case window_type.Tukey
                         
        case window_type.PlankTaper
                         
        case window_type.Slepian
                         
        case window_type.Kaiser
                         
        case window_type.DolphChebyshev
                         
        case window_type.UltraSpherical
                         
        case window_type.Poisson          
                         
        case window_type.BartlettHann
                         
        case window_type.PlankBessel
                         
        case window_type.HannPoisson
                         
        case window_type.Lanczos
            
        otherwise
            % leave as Rect
    end

