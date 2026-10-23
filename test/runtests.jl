using Test, DigitalSignalProcessing
@testset "DSP" begin
    fs=8000.0
    t,x=tone(fs,1.0,[(500.0,1.0,0.0)])
    @test length(x)==8000
    s=one_sided_spectrum(x,fs)
    idx=argmax(s.amplitude)
    @test s.frequency_hz[idx]≈500.0
    @test s.amplitude[idx]≈1.0 atol=1e-10
    @test maximum(abs.(x-reconstruct_from_spectrum(x)))<1e-10
    @test moving_average([1.0,2.0,3.0,4.0],2)≈[1.5,2.5,3.5]
    w=windowed_spectrum(x,fs)
    @test w.frequency_hz[idx]≈500.0
    @test w.amplitude[idx]≈1.0 atol=1e-3
    @test spectral_centroid(zeros(16),fs)==0
    @test_throws ArgumentError tone(8000,1.0,[(5000.0,1.0,0.0)])
end
