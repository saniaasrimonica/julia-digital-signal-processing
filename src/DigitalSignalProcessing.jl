module DigitalSignalProcessing
using FFTW, Statistics
export tone, one_sided_spectrum, moving_average, windowed_spectrum, reconstruct_from_spectrum, spectral_centroid

function tone(fs::Real,duration::Real,components::AbstractVector)
    fs>0 && duration>0 || throw(ArgumentError("positive fs and duration required"))
    n=round(Int,fs*duration);n>=2 || throw(ArgumentError("need at least 2 samples"))
    t=collect(0:n-1)./fs
    x=zeros(Float64,n)
    for (frequency,amplitude,phase) in components
        0<=frequency<fs/2 || throw(ArgumentError("frequency must be below Nyquist"))
        x .+= amplitude .* sin.(2pi*frequency.*t .+ phase)
    end
    return t,x
end
function one_sided_spectrum(x::AbstractVector{<:Real},fs::Real)
    fs>0 || throw(ArgumentError("fs must be positive"))
    n=length(x);n>=2 || throw(ArgumentError("need at least 2 samples"))
    X=rfft(x)
    amp=2 .* abs.(X)./n
    amp[1]/=2
    if iseven(n);amp[end]/=2;end
    freq=collect(0:fld(n,2)).*(fs/n)
    return (frequency_hz=freq,amplitude=amp,complex_spectrum=X)
end
function moving_average(x::AbstractVector,window::Integer)
    1<=window<=length(x) || throw(ArgumentError("invalid window length"))
    # Centered output not implied: valid-window causal-style averages.
    return [sum(@view x[i:i+window-1])/window for i in 1:length(x)-window+1]
end
function windowed_spectrum(x::AbstractVector{<:Real},fs::Real)
    n=length(x);n>=2 || throw(ArgumentError("need at least 2 samples"))
    w=0.5 .- 0.5 .* cos.(2pi.*collect(0:n-1)./(n-1))
    coherent_gain=mean(w)
    s=one_sided_spectrum(x.*w,fs)
    return (frequency_hz=s.frequency_hz,amplitude=s.amplitude./coherent_gain)
end
function reconstruct_from_spectrum(x::AbstractVector{<:Real})
    n=length(x);n>=2 || throw(ArgumentError("need at least 2 samples"))
    return irfft(rfft(x),n)
end
function spectral_centroid(x::AbstractVector{<:Real},fs::Real)
    s=one_sided_spectrum(x,fs)
    power=abs2.(s.complex_spectrum)
    total=sum(power)
    return total==0 ? 0.0 : sum(s.frequency_hz.*power)/total
end
end
