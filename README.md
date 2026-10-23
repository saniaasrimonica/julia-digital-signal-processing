# Julia Digital Signal Processing

A reproducible educational DSP project with Julia and FFTW.jl.

## Features
- Multi-tone signal synthesis
- One-sided FFT amplitude spectrum with correct DC/Nyquist handling
- Hann-windowed spectrum with coherent-gain correction
- Moving-average filtering
- FFT/inverse-FFT reconstruction
- Spectral centroid
- Unit tests and GitHub Actions

## Run
```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=. examples/demo.jl
julia --project=. test/runtests.jl
```

## Notes
The simple amplitude estimator is best suited to bin-centered sinusoidal signals; windowing reduces leakage but does not remove all spectral-estimation limitations. Moving average uses valid windows and reduces output length. All examples use synthetic data.

## Extensions
Add FIR/IIR filters, Welch PSD, real CSV ingestion, and noise/SNR measurements. Benchmark Julia vs Python for large signals.

MIT licensed. Educational starter code.
