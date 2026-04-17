# ceTDP-cons-SPM

**ceTDP-cons-SPM** is a Stage 2 SPM extension that enables **quantitative cluster inference** by estimating the **True Discovery Proportion (TDP)** within each cluster using the **ceTDP-cons** approach.

It enhances traditional cluster-based inference by quantifying how much activation is present within each significant cluster, rather than only detecting whether a cluster contains any signal.

## Introduction

Cluster extent inference is widely used in fMRI analysis. However, it suffers from the spatial specificity paradox:

> A significant cluster guarantees at least one active voxel, but does not tell you where the activation is located or how much of it is present.

The ceTDP-cons method (Goeman et al., 2023) addresses this by:

- Estimating a lower bound of the proportion of truly active voxels (TDP) in each cluster
  
- Providing more informative and interpretable cluster-level results

## Why Should You Use?

Use **ceTDP-cons-SPM** instead of standard cluster extent inference to:

- Provide more informative cluster interpretation
- Quantify activation within clusters
- Improve reporting beyond: *This is a significant cluster*

## Key Features

- Fully integrated with SPM12
  
- Provides TDP lower bounds for each cluster

- Compatible with standard SPM results tables

- Supports:
	- Interactive GUI
 	- Script-based workflows
  	- CSV export

## Installation

1. Prerequisites

   Make sure you have MATLAB and SPM12.

   Add SPM12 to MATLAB path:
   ```matlab
   addpath(genpath('path/to/spm12'));
   ```
  
2. Install ceTDP-cons-SPM

   Clone the repository:
   ```bash
   git clone https://github.com/xuchen312/ceTDP-cons-SPM.git
   ```

   Add it to MATLAB path:
   ```matlab
   addpath(genpath('path/to/ceTDP-cons-SPM'));
   ```
    
## Quick Start

### Option 1: Interactive mode (recommended)

```matlab
spm_ceTDP_cons;
```

- Select your SPM results via GUI
- Choose thresholding options
- Input cluster extent threshold *k* (derived from Stage 1)
- View results directly in SPM

### Option 2: Using existing `xSPM`

```matlab
spm_ceTDP_cons(xSPM);
```

### Option 3: Export results to CSV

```matlab
spm_ceTDP_cons('results.csv');
```

### Option 4: Full usage (allowing interactive exploration)

```matlab
[hReg,xSPM,SPM,TabDat] = spm_ceTDP_cons(xSPM, 'results.csv');
```

## Usage

```matlab
[hReg,xSPM,SPM,TabDat] = spm_ceTDP_cons([xSPM,file]);
```

### Inputs (*optional*)

- ```xSPM``` Thresholded `SPM` structure. `SPM` must be generated using `spm_getSPM`
- ```file``` Character string specifying a filename (for CSV export).

### Outputs (*optional*)

- `hReg` Handle to the results GUI
- `xSPM` Thresholded SPM structure
- `SPM` Standard SPM structure
- `TabDat` Result summary table

*Note: Outputs must be used either all together or not at all to enable/disable interactive exploration.*

### Output table

The key output is a results table (TabDat) shown in the SPM graphics window and optionally exported to CSV.

**Important columns**:
Column	| Description
--------|------------
k		| Cluster size (number of voxels)
p(FWE)	| Family-wise error (FWE) corrected p-value
p(FDR)	| False discovery rate (FDR) corrected p-value
TDP(lb)	| Lower bound of true discovery proportion
T / Z	| Peak statistics
x,y,z	| MNI coordinates

### How to Interpret TDP

- TDP(lb) = 0.20 &rarr; At least 20% of voxels in the cluster are truly active
- Higher TDP &rarr; stronger, more spatially specific activation
- TDP helps avoid over-interpreting large clusters with sparse signal

## Running from Terminal (optional)

```bash
matlab -nodesktop -nosplash -r "cd('.../ceTDP-cons-SPM'); spm_ceTDP_cons; exit"
```

## Example Results Table

The main **ceTDP-cons-SPM** results are summarized with a result table ```TabDat``` that can be visualised from the graphics window in SPM, returned to the workspace, and exported to a CSV file. An example of such summary tables is as below.
```
Statistics: p-values adjusted for search volume
================================================================================
set	set	cluster	cluster	cluster	cluster	peak	peak	peak	peak	peak	
p	c	p(FWE)	p(FDR)	k	TDP(lb)	p(FWE)	p(FDR)	T	Z	p(unc)	x,y,z {mm}
--------------------------------------------------------------------------------
0.994	25	0.000	0.000	6422	0.205	0.000	0.000	 12.27	 7.22	0.000	 60 -12   2 	
											0.000	0.000	  9.45	 6.34	0.000	 58   0  -2 	
											0.000	0.000	  8.78	 6.09	0.000	 54   8 -12 	
			0.000	0.000	4655	0.223	0.000	0.000	 11.15	 6.90	0.000	-60 -24   4 	
											0.000	0.000	 10.61	 6.73	0.000	-58 -14   2 	
											0.000	0.000	 10.56	 6.71	0.000	-60  -6   0 	
			0.083	0.014	114		0.000	0.011	0.002	  7.21	 5.41	0.000	 18  -4 -14 	
			0.134	0.018	100		0.000	0.334	0.038	  5.60	 4.57	0.000	-42  28  -2 	
			0.750	0.108	46		0.000	0.700	0.074	  5.11	 4.28	0.000	-38  -4 -38 	
											1.000	0.434	  3.97	 3.52	0.000	-38   2 -44 	
			0.958	0.169	30		0.000	0.761	0.084	  5.03	 4.23	0.000	  8  -2  -2 	
			0.831	0.108	41		0.000	0.790	0.089	  4.99	 4.21	0.000	 40   4 -46 	
			0.183	0.021	91		0.000	0.825	0.097	  4.94	 4.18	0.000	 52   2  48 	
											1.000	0.773	  3.58	 3.23	0.001	 52  10  54 	
			0.845	0.108	40		0.000	0.892	0.109	  4.83	 4.10	0.000	-10  -8 -12 	
			0.000	0.000	329		0.018	0.920	0.121	  4.77	 4.07	0.000	-58  16  28 	
											0.984	0.178	  4.55	 3.92	0.000	-40  16  24 	
											0.985	0.178	  4.54	 3.91	0.000	-48  18  20 	
			0.211	0.022	87		0.000	0.988	0.182	  4.51	 3.89	0.000	  8  10  62 	
											0.999	0.289	  4.26	 3.72	0.000	  8  22  60 	
			1.000	0.689	7		0.000	1.000	0.400	  4.04	 3.57	0.000	-14 -24  -6 	
			0.799	0.108	43		0.000	1.000	0.425	  3.99	 3.53	0.000	 14  -6  10 	
			1.000	0.623	9		0.000	1.000	0.486	  3.90	 3.46	0.000	 48   0  58 	
			1.000	0.771	2		0.000	1.000	0.585	  3.77	 3.37	0.000	-10 -20  -8 	
			1.000	0.763	4		0.000	1.000	0.628	  3.73	 3.34	0.000	-50  -8  56 	
			1.000	0.763	4		0.000	1.000	0.636	  3.72	 3.33	0.000	-36  24 -28 	
			1.000	0.771	2		0.000	1.000	0.684	  3.67	 3.30	0.000	-64  14  28 	
			1.000	0.763	5		0.000	1.000	0.753	  3.61	 3.25	0.001	 64 -54  14 	
			1.000	0.771	2		0.000	1.000	0.815	  3.55	 3.21	0.001	  8  48  38 	
			1.000	0.771	2		0.000	1.000	0.939	  3.46	 3.14	0.001	-24  10 -22 	
			1.000	0.771	1		0.000	1.000	0.993	  3.41	 3.10	0.001	-22 -88 -38 	
			1.000	0.771	1		0.000	1.000	0.993	  3.41	 3.10	0.001	 -4   2  62 	
			1.000	0.771	1		0.000	1.000	0.993	  3.41	 3.10	0.001	 68  12   4 	
			1.000	0.771	1		0.000	1.000	0.993	  3.40	 3.09	0.001	-58  12  48 	

table shows 3 local maxima more than 8.0mm apart
--------------------------------------------------------------------------------
Height threshold: T = 3.40, p = 0.001 (1.000)
Extent threshold: k = 0 voxels
Expected voxels per cluster, <k> = 10.007
Expected number of clusters, <c> = 39.23
FWEp: 6.518, FDRp: 5.475, FWEc: 329, FDRc: 87
Degrees of freedom = [1.0, 29.0]
FWHM = 10.0 9.8 8.9 mm mm mm; 5.0 4.9 4.4 {voxels}
Volume: 2902952 = 362869 voxels = 3132.9 resels
Voxel size: 2.0 2.0 2.0 mm mm mm; (resel = 109.19 voxels)
================================================================================
```
Here, this summary table is compatible with the SPM12 statistics results table, and the summary variable ```TDP(lb)``` shows the lower bound of the TDP, derived using **ceTDP-cons**, for each supra-threshold cluster.

## References

Goeman, J.J., Górecki, P., Monajemi, R., Chen, X., Nichols, T.E. and Weeda, W. (2023). Cluster extent inference revisited: quantification and localisation of brain activity. *Journal of the Royal Statistical Society Series B: Statistical Methodology*, 85(4):1128–1153. [[Method Paper](https://doi.org/10.1093/jrsssb/qkad067)]

## Found bugs, or any questions/suggestions?

Please contact Xu Chen at xuchen312@gmail.com.
