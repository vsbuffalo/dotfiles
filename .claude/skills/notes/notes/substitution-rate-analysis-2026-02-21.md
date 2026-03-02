# Substitution Rate Analysis: DFE Identifiability and Divergence Comparison

**Date**: 2026-02-21
**Context**: Testing whether BGS model predictions of substitution rates (via pfix/alpha) match observed human-chimp-orangutan divergence patterns across CADD conservation bins, as groundwork for a paper figure.

## Method

### Profile fit baseline
The starting point was the existing profile likelihood fit at N=3500 (constant DFE):
- N=3500, s=5.88e-4, γ=4.11, β=8.129 (×1e-8), π₀=0.006098
- R²=67.62% on diversity
- B-map: `bench_results/profile_fit/bmaps_cached/bmap_N3500.tsv`

### Fitting a non-constant DFE
Attempted Grid DFE (6 bins, top 6%) with N/β/π₀ fixed at profile MLE:
```bash
# Makefile target: grid-dfe
bgstk fit-grid --dfe grid --popsize 3500 --beta 8.129 --pi0 0.006098 \
  --pi0-scale 10000 --log10-popsize --scale-mutrate \
  --pre-starts 200 --use-lhs --seed 42 --window-size 10
```
Result: R²=68.06%, but 2 of 6 bins pegged at upper bound (s=0.5). Poorly constrained.

Switched to wider features (20 bins, top 20% by CADD) with interpolation DFE (5 knots):
```bash
# Copied features_yri_20pct.tsv from ponderosa preprocessed data
# Makefile target: interp-dfe
bgstk fit-grid --dfe interp --num-knots 5 --popsize 3500 --beta 8.129 \
  --pi0 0.006098 --pi0-scale 10000 --log10-popsize --scale-mutrate \
  --pre-starts 200 --use-lhs --seed 42 --window-size 10 \
  --features features_yri_20pct.tsv
```
Result: R²=68.58%, beautiful monotonic s gradient across bins.

### DFE identifiability test
Compared per-window residuals between constant DFE and interp DFE, binned by multiple conditioning variables (B, ŷ, y_obs, conservation density, |residual|).

### Substitution rate comparison
Computed model-predicted substitution rates (1 − α) per conservation bin from interp DFE output. The alpha model is Tanh: α = tanh(NsB) where γ = 2NsB.

Generated 50-bin (2% quantile resolution) observed substitution rates from existing ponderosa pipeline:
```bash
cd "/Volumes/Backup 2/human_bgs_ponderosa/data/hg38/subrates"
# Input file already existed:
# multiz100way_stats/joined_with_scores/binned_scores_stats_cadd_linear_50_nbins_sorted.tsv.gz
duckdb -c "COPY (WITH imported_data AS (SELECT * FROM read_csv_auto(...)) ...) TO 'substitution_rates_by_bin_50.tsv'"
```

Observed ratio: d(human-chimp) / d(chimp-orangutan), normalized to least-conserved bin (bin 0).

## Results

### Interp DFE per-bin selection coefficients

| Model bin | s | α (weighted mean) | Predicted sub rate |
|-----------|---|----|----|
| Top 0-1% | 7.52e-04 | 0.959 | 0.041 |
| Top 1-2% | 6.94e-04 | 0.951 | 0.049 |
| Top 2-3% | 6.40e-04 | 0.937 | 0.063 |
| Top 3-4% | 5.90e-04 | 0.920 | 0.080 |
| Top 4-5% | 5.44e-04 | 0.900 | 0.100 |
| Top 5-6% | 3.27e-04 | 0.717 | 0.283 |
| Top 6-7% | 1.28e-04 | 0.342 | 0.658 |
| Top 7-8% | 4.99e-05 | 0.139 | 0.861 |
| Top 8-9% | 1.95e-05 | 0.054 | 0.946 |
| Top 9-10% | 7.62e-06 | 0.021 | 0.979 |
| Top 10-11% | 2.57e-06 | 0.007 | 0.993 |
| Top 11-12% | 7.49e-07 | 0.002 | 0.998 |
| Top 12-13% | 2.18e-07 | 0.001 | 0.999 |
| Top 13-14% | 6.36e-08 | 0.000 | 1.000 |
| Top 14-20% | 1.00e-08 (floor) | 0.000 | 1.000 |

Constant DFE: s=5.88e-04, mean α=0.892, predicted sub rate=0.108 (flat for all bins).

### DFE identifiability: diversity cannot distinguish DFE shape

| Metric | Constant DFE | Interp DFE |
|--------|-------------|------------|
| R² | 67.62% | 68.58% |
| Parameters (DFE) | 1 | 5 |
| Mean \|residual\| | identical | identical |
| Interp better in N/total windows | — | 49.9% (coin flip) |

Binned residual improvement (|resid_const| − |resid_interp|) by B, ŷ, y, conservation density, and |residual| was **flat at zero with 95% CI crossing zero everywhere**. No signal in any conditioning.

### Observed substitution rates at 2% resolution (top 20%)

| Sub bin | % from top | Observed HC/CO ratio | Model prediction |
|---------|-----------|---------------------|-----------------|
| 49 | 1% | 0.807 | 0.045 |
| 48 | 3% | 0.790 | 0.072 |
| 47 | 5% | **0.775** (minimum) | 0.184 |
| 46 | 7% | 0.780 | **0.756** (crossing) |
| 45 | 9% | 0.789 | 0.963 |
| 44 | 11% | 0.797 | 0.995 |
| 43 | 13% | 0.815 | 1.000 |
| 42 | 15% | 0.843 | 1.000 |
| 41 | 17% | 0.874 | 1.000 |
| 40 | 19% | 0.897 | 1.000 |

Pearson r (observed vs predicted, 10 bins): **0.491**

Sample sizes: ~35-40M aligned sites per 2% bin. All patterns statistically unambiguous.

### Observed U-shape in substitution rates

The observed double ratio shows a **U-shaped curve** with:
- Gradual decline from ~0.90 (top 19%) to minimum 0.775 (top 5%)
- **Uptick** at most conserved sites: 0.775 → 0.790 → 0.807 (top 5% → 3% → 1%)

The model predicts **monotonic decline** — misses the uptick entirely.

### Bins 4-6 in 10-bin data showed obs_ratio > 1.0
Middle bins (40-70th percentile of CADD) showed d(HC)/d(CO) ratios up to 1.05, significantly above neutral baseline. Possible GC-biased gene conversion or lineage-specific positive selection.

## Observations

### DFE identifiability is a hard wall
The interp DFE recovers a 5-order-of-magnitude gradient in s across 20 conservation bins, yet produces **zero** improvement in diversity predictions. This is because:
- Diversity (π) depends on the aggregate B across all linked selected sites
- The aggregate is insensitive to how selection is distributed across bins
- B is what matters for diversity; the per-bin decomposition is unidentifiable from π alone

**This motivates substitution rate analysis as independent information.**

### The double ratio d(HC)/d(CO) partially cancels selection
If purifying selection acts similarly on human-chimp and chimp-orangutan lineages (same conserved sites, similar N), the selection effect largely cancels in the ratio. The observed 0.775 minimum likely underestimates true selection. The model's predicted 0.045 at the most conserved bin may be closer to "truth" than the observed ratio suggests.

### Model-data crossing at top ~7%
The model and observed data cross at approximately the top 7% (both ≈ 0.76). Below this threshold (more conserved), the model overpredicts selection; above it (less conserved), the model underpredicts. The model concentrates selection into a cliff at top 5% while the real signal is spread more gradually across the top 20%.

### U-shape implies positive selection or gBGC at most constrained sites
Possible explanations for the uptick in substitution rates at the very most conserved sites (top 1-3%):
1. **Adaptive substitutions** concentrated at the most functionally important sites
2. **GC-biased gene conversion** at CpG-rich conserved regions
3. **Hill-Robertson interference** reducing selection efficiency at the most constrained loci
4. Artifact of CADD score calibration at the extreme tail

### Data availability
- 10-bin subrates: `/Volumes/Backup 2/human_bgs_ponderosa/data/hg38/subrates/substitution_rates_by_bin.tsv`
- 50-bin subrates: `/Volumes/Backup 2/human_bgs_ponderosa/data/hg38/subrates/substitution_rates_by_bin_50.tsv`
- Also available: 20-bin version (`cadd_linear_20_nbins`) and GPN-scored versions
- Interp DFE output with per-window alpha columns: `bench_results/interp_dfe_fit/interp_dfe.tsv`

### Scripts produced
- `bench_results/plot_subrate_fig.py` — Clean 3-panel paper figure (DFE, raw comparison, shape comparison)
- `bench_results/plot_subrate_comparison.py` — 4-panel exploratory figure
- `bench_results/plot_alpha_subrates.py` — Alpha vs B with constant DFE
- `bench_results/plot_residual_comparison.py` — Genome-wide residual comparison
- `bench_results/plot_residual_by_condition.py` — Residual improvement by conditioning variable

### Next steps
- Try comparison without double ratio normalization (need independent per-bin mutation rate estimate)
- Investigate the U-shape uptick more carefully (split by functional annotation?)
- Consider fitting with substitution rate data as additional constraint (joint diversity + divergence likelihood)
- The 50-bin observed data could also be used with GPN scores instead of CADD
