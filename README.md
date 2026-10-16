# CSVM: MATLAB code of the published model

This repository holds the MATLAB code of CSVM, a grid-based, discrete-time
stochastic model of the reproductive phenology of co-flowering plant species,
as used for the article

> Machado et al. (2026). *Ecological Modelling*, manuscript ECOMOD-26-1574
> (in revision). The full reference and DOI will be added on publication.

The files are published as they were used to produce the results of the
article, with one exception: the field data are not included (see
[Field data](#field-data)). This repository is an archive and is not developed
further.

## The model in brief

Four co-flowering cerrado species (*Banisteriopsis malifolia*, *Peixotoa tomentosa*,
*B. laevifolia* and *B. campestris*) are placed on a grid of 100 × 100 cells of
0.5 m and simulated with 48 steps per year over 5 years. In each occupied cell,
a species moves from vegetative condition to floral buds, open flowers and
fruits, driven by rainfall, leaf-sprouting and flowering-initiation forcing
built from monthly field data. Herbivory and pollination act through random
cell masks, and a community co-flowering modifier links the species. The
parameters were calibrated by adaptive differential evolution followed by local
sequential quadratic programming.

## Requirements

- MATLAB (the analyses of the 2026 revision were run with R2016a).
- Signal Processing Toolbox (`interp`, used to build the forcing series).
- Optimization Toolbox (`fmincon`, used by `OTIMIZADOR.m` for calibration only).

## Running

The scripts read the field data from `field_data.mat`, which is not part of
this repository (see [Field data](#field-data)); place it in this folder first.

One simulation with the published parameters, with figures and statistics:
open MATLAB in this folder and run

```matlab
CSV_Method
```

Batch runs without figures or files written (replicates, scenarios), from this
folder:

```matlab
addpath('REVISION_2026')
out = csvm_core(struct('seed', 1));   % published settings
out.mse      % objective: mean of the 12 integrated squared errors (buds, flowers, fruits)
```

The options of `csvm_core` (parameters, grid, years, flowering and rainfall
shifts, noise switches, community modifier switches) are listed at the top of
`REVISION_2026/csvm_core.m`.

Calibration: `main.m` runs differential evolution for one species and writes
`OPT_<species>.xls`; `OTIMIZADOR.m` refines a solution with `fmincon`.

## Files

| File | Role |
|---|---|
| `CSV_Method.m` | Main script: settings, published parameters and the order of the calls of one simulation |
| `chuvas.m` | Rainfall forcing (monthly rainfall, 2008–2012) |
| `botoes.m` | Flowering-initiation forcing (monthly floral-bud counts) |
| `brotamentos.m` | Leaf-sprouting forcing (monthly leaf scores) |
| `cenario_plantas.m`, `cenario_global.m` | Plant placement and initial state |
| `evolucao.m` | One time step: herbivory and pollination masks, stage transitions, community modifier |
| `campo_real.m` | Field reference curves of each stage and species |
| `resposta_stat.m` | Statistics: integrated squared error, objective, moments |
| `resposta_plot.m`, `confidence_interval.m`, `cenario_plot.m`, `plot_cerrado.m` | Figures |
| `resposta_export.m` | Export of the results to Excel |
| `statistical_error.m` | Replicate runs |
| `PLOTTER_PARA_ARTIGO.m` | Figures of the article (data typed into the script) |
| `main.m`, `differential_evolution.m`, `popsize.m`, `eval_objective.m` | Calibration by adaptive differential evolution |
| `OTIMIZADOR.m` | Local refinement by sequential quadratic programming (`fmincon`) |
| `X_ENTRIES.m`, `entry_tester.m`, `program_tester.m` | Candidate parameter sets from the calibration runs, and their ranking |
| `XstDE_1.mat`, `XstDE_2.mat`, `XstDE_3.mat`, `XstDE_6.mat` | Saved calibration results (parameter vectors `xDE`, objective values `yDE`) |
| `OPT_camp.xls`, `OPT_laev.xls`, `OPT_mali.xls`, `OPT_tome.xls` | Calibration results per species, written by `main.m` |
| `process.txt` | Convergence history of the last differential-evolution run (generation, best objective), plotted by `main.m` |
| `Data6.xls` | Simulated outputs exported by `CSV_Method.m` (the export lines are now commented out) |
| `StatCrop.m`, `StatCrop.fig` | Unused graphical interface stub |
| `REVISION_2026/csvm_core.m` | Batch version of `CSV_Method.m`, written for the 2026 revision: the same model and outputs for the same random state, without figures or files, plus stage fluxes and scenario switches |
| `REVISION_2026/verify_core.m` | Check that `csvm_core.m` reproduces `CSV_Method.m` |

## Field data

The field data used by the model belong to the people who collected them and
are not published here: monthly rainfall 2008–2012 from the weather station of
the Instituto de Geografia, Universidade Federal de Uberlândia; monthly
floral-bud counts, leaf scores and field curves of each stage and species
collected by A. A. Vilela and H. M. T. Silingardi (LECI/INBIO, Universidade
Federal de Uberlândia); and the field maxima derived from them. Readers who
need the data can contact the authors of the article.

In the published files each data table was replaced by a reference to the same
values in `field_data.mat`, which the scripts load with
`FIELD=load('field_data.mat');`. For example, in `botoes.m`

```matlab
mali1=[ ... 12 monthly counts ... ];   % original line
mali1=FIELD.botoes.mali1;               % published line
```

Nothing else in the code was changed. With `field_data.mat` in the folder the
scripts compute exactly what the original code computed. The file holds one
structure per source file:

| Field of `FIELD` | Size | Content |
|---|---|---|
| `chuvas.a2008` … `chuvas.a2012` | 12 × 1 | Monthly rainfall of each year, January to December (mm) |
| `botoes.mali1` … `botoes.camp3` | 1 × 12 | Monthly floral-bud counts per species (`mali`, `peix`, `laev`, `camp`) and season (1 = 2008/09, 2 = 2012/13, 3 = 2013/14) |
| `brotamentos.malifolia`, `.peixotoa`, `.laevifolia`, `.campestris` | 12 × 1 | Monthly leaf scores, season 2012/13 (the model uses their reciprocal) |
| `campo_real.<curve>` (56 curves) | 1 × 12 | Field curves named stage (`V` vegetative, `B` buds, `F` flowers, `S` fruits), species (`m`, `p`, `l`, `c`), year (`05`, `08`, `12`, `13`) and observer (`a`, `m`), e.g. `Bm08a` |
| `CSV_Method.REF` | 4 × 3 | Field maxima of buds, flowers and fruits; rows malifolia, peixotoa, laevifolia, campestris |

## Notes

- Comments in the code are in Portuguese; reports printed on screen are in
  English.
- The files are encoded in Windows-1252. Accented characters look wrong in
  GitHub's web view but are correct when the files are opened with that
  encoding, as MATLAB does on Windows.
- `REVISION_2026/verify_core.m` compares `csvm_core.m` with reference runs of
  `CSV_Method.m` saved as `ref_<seed>.mat`; those reference files are not
  included.

## Authors

The code was developed by Vergílio T. S. Del Claro, with theoretical support
from Andréa A. Vilela, Helena Maura T. Silingardi and Kleber Del Claro
(Universidade Federal de Uberlândia), as listed in `CSV_Method.m`. The software
is registered at the Brazilian National Institute of Industrial Property (INPI)
in the name of Vergílio T. S. Del Claro.

## License

MIT; see `LICENSE`. If you use this code, please cite the article above.
