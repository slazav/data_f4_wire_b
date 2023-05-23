## Measurements of vibrating wire thermometers in He3-B.

This is a consistent measurements of non-linear corrections and
temperature calibration.

#### Wires:

* w1a -- D=4.5um L=1.4mm in cell1
* w2a -- D=4.5um L=1.4mm in cell2
* w1b -- D=0.315um L=1.0mm in cell1
* w1bt -- D=4.5um L=1.49mm in a bolometer inside cell 1
* w2bt -- D=4.5um L=1.43mm in a bolometer inside cell 2

All are NbTi wires. 

#### Measurements

Wires are driven with AC current via "drive boxes" (transformer 6.4:1 +
100 kOhm current source + 20dB attenuator). Measured with cold
transformer (1:100 for w2bt, 1:30 for other wires), Femto lock-in
amplifiers and, PicoADC card.

Recorded data can be found in `<wire_name>_sweeps` databases, they have 5 columns:
* time, unix seconds
* drive frequency, Hz
* lock-in output X, V
* lock-in output Y, V
* drive voltage, V

Each measurement is an "amplitude sweep in tracking mode, with frequency
adjustment": first a resonance is recorded as a function of frequency.
Then frequency is set to the resonance value, amplitude in swept up and
down. On each step new resonance frequency is calculated in assumption
that resonance is linear, drive frequency is adjusted to the new
resonance.

Frequency adjustment (and assumption that the resonance is linear) is not
important for further processing, it is possible to work at any frequency.
At the resonance we have better accuracy and simpler force-velocity data.

Measurements are repeated as a function of temperature at different magnetic
fields and pressures.


#### Data processing, step 1

General ideas are described in https://arxiv.org/abs/2303.01189

Drive voltage is converted to amps (not important here), measured voltage
is converted to voltage on the wire, and then to wire velocity, using
some values of magnetic field and wire length. Values of field and length
are not precise, but it's OK if we use same values in all calculations.

Pre-measured background is subtracted. Exact value of the background and
its possible drifts are not important, because in each measurement we use
additional offset (complex linear function, 4 parameters) when fitting
the resonance curve.

As described in the Arxiv paper, from each amplitude sweep we obtain
velocity-dependent damping and represent it as `delta(v) = delta0 *
S(|v|)` where `S(0) = 1`. Then we use this non-linear damping to re-fit
the resonance curve and repeat this procedure a few times until it
converges.

For fitting velocity-dependent damping we use formula
`delta(v) = delta_0 * [ Sth(v/v0) + Si]` with 3 fitting parameters:

* `delta_0` -- Dampung at zero velocity, extrapolation of `delta(v)` to `v=0`.
* `v0` -- We use theoretical S-function for 1D scattering model `S_th`. `v0` is velocity scaling.
* `Si` -- Additional fitting parameter. At low temperature it will include field-dependent
intrinsic damping of the wire.

Script `proc1` reads file with timestamps `<wire_name>.tab` and writes
file `<wire name>.res` with fitting parameters. Input files contain 2 or
3 values in each line: two timestamps and optional maximum drive limit.
Velocity-dependent damping `delta(v)` is recorded to `<wire
name>/<timestamp>.dat` files. Numpy cache with original data and png plot
is also saved (but not added to git).

Example of data processing (wire w1a, field 158 mT, pressure 2.0 bar):
![data1](https://raw.githubusercontent.com/slazav/data_f4_wire_b/main/example/1682522772.png)

Example of data in one folder (wire w1a, field 158 mT, pressure 2.0 bar):
![data1](https://raw.githubusercontent.com/slazav/data_f4_wire_b/main/20230425-02bar-158mT/w2a.png)
Red points are used for fiting


#### Data processing, step 2

We want to find function `S(v)` for a given temperature, pressure, magnetic field.
This will allow us to convert damping measured at a non-zero velocity to the
zero-velocity limit. Also it will be possible to fit non-linear resonance curves.

Theoretical temperature dependencies are: `delta0 = A*exp(-Delta/T) + delta_i`, `v0 = B*T`,
where `A` and `B` depend on wire geometry, mass and Fermi momentum of He quasiparticles.
We can exclude temperature from these two expressions and write:
`v0 = B*Delta/log(A) - log(delta0-delta_i))`.

Next step will be to fit all data for a single pressure with this formula, assuming
following field dependencies: `Delta(B) = Delta(0)*(1 + a*B^2)`, `delta_i(B) = delta_i(0) + b*B^2`.
We have 5 parameters: `A, B, a, b, delta_i(0)`.




