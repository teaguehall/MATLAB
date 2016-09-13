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
            window = 0.5*(1-cos(2*pi*n/(size-1)));
            segment = segment.*window;
            
        case window_type.Hamming
            window = 0.54 - 0.46*cos(2*pi*n/(size-1));     
            segment = segment.*window;
            
        case window_type.Blackman
            window = 0.16 - 0.42*cos(2*pi*n/(size-1)) + 0.08*cos(4*pi*n/(size-1));
            segment = segment.*window;
            
        case window_type.Nuttall
            window = 0.355768 - 0.487396*cos(2*pi*n/(size-1)) + 0.144232*cos(4*pi*n/(size-1)) - 0.012604*cos(6*pi*n/(size-1));
            segment = segment.*window;               
              
        case window_type.BlackmanNuttall
            window = 0.3635819 - 0.4891775*cos(2*pi*n/(size-1)) + 0.1365995*cos(4*pi*n/(size-1)) - 0.0106411*cos(6*pi*n/(size-1));
            segment = segment.*window; 
            
        case window_type.BlackmanHarris
            window = 0.35875 - 0.48829*cos(2*pi*n/(size-1)) + 0.14128*cos(4*pi*n/(size-1)) - 0.01168*cos(6*pi*n/(size-1));
            segment = segment.*window; 
            
        case window_type.FlatTop
            window = 1 - 1.93*cos(2*pi*n/(size-1)) + 1.29*cos(4*pi*n/(size-1)) - 0.388*cos(6*pi*n/(size-1)) + 0.028*cos(8*pi*n/(size-1));
            segment = segment.*window; 
                      
        case window_type.Cosine
            window = sin(pi*n/(size-1));
            segment = segment.*window;
                         
        case window_type.Gaussian
            rho = 0.5;
            window = exp(-0.5*((n-(size-1)/2)/(rho*(size-1)/2)).^2);
            segment = segment.*window;
            
        case window_type.GeneralNormal
%             p = 2;
%             rho = 0.25;
%             window = exp(-((n-(size-1)/2)/(rho*(size-1)/2)).^p);
              window = exp(-((n-(size-1)/2)/(0.25*(size-1)/2)).^2);
              segment = segment.*window;
              
        case window_type.Tukey
            disp('Tukey window has not yet been implemented')
                         
        case window_type.PlankTaper
            disp('Plnk Taper window has not yet been implemented')
                         
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

