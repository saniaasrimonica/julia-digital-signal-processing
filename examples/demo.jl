using DigitalSignalProcessing, Random
Random.seed!(42)
fs=8000.0
t,clean=tone(fs,1.0,[(440.0,1.0,0.0),(1200.0,0.35,0.0)])
noisy=clean .+ 0.1 .* randn(length(clean))
spec=one_sided_spectrum(clean,fs)
peak=argmax(spec.amplitude)
println("Dominant frequency: ",spec.frequency_hz[peak]," Hz")
println("Spectral centroid: ",spectral_centroid(clean,fs)," Hz")
println("Reconstruction max error: ",maximum(abs.(clean-reconstruct_from_spectrum(clean))))
println("Moving-average output samples: ",length(moving_average(noisy,9)))
