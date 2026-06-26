# Project Notes

This project was created during a Data Mining course.

The main focus was to practice statistical data analysis with R on biological measurement data. The workflow included data preparation, visualization, statistical modelling and interpretation of results.

The analysis helped me understand how R can be used to compare biological response patterns between different experimental groups.


# Project Summary

## Differential Response of Plasmodium to Bites from Competent and Incompetent Vectors

This project was created as part of a university Data Mining with R course.  
The aim was to analyze biological data related to *Plasmodium relictum* infections in birds and to investigate whether parasite and host response patterns differ after exposure to different mosquito vectors.

The original dataset is not included in this public repository because it was provided in the context of a university course project and is not publicly shared.

---

## Background

Avian malaria parasites of the genus *Plasmodium* depend on both replication inside the host and the production of gametocytes, which are the stages that can infect mosquitoes.

In this project, the main question was whether *Plasmodium* responds differently to bites from:

- a competent mosquito vector (*Culex*)
- an incompetent mosquito vector (*Anopheles*)
- a non-bitten control condition

The analysis also considered host physiological markers such as corticosterone, C-reactive protein and IgY antibodies.

---

## Data Overview

The analysis was based on several biological measurement datasets:

- parasite measurements, including parasitemia and gametocytemia
- corticosterone measurements
- C-reactive protein measurements
- IgY antibody measurements

The dataset included different treatment groups and repeated measurements over time.

The original data files are not included in this repository.

---

## Methods

The analysis was performed in R.

The workflow included:

- importing biological measurement data
- checking and preparing the data
- calculating changes from baseline
- visualizing parasite and immune response patterns
- applying linear mixed models
- comparing treatment groups over time
- interpreting the statistical results in a biological context

The main R packages used were:

- `dplyr`
- `ggplot2`
- `lme4`
- `lmerTest`
- `effects`

For the statistical analysis, linear mixed models were used.  
Treatment group and time were used as fixed effects, including their interaction.  
Bird identity was used as a random effect to account for repeated measurements.

---

## Results Summary

### Parasitemia

The overall interaction between treatment and time was not statistically significant.  
However, the *Anopheles* group showed a significant increase in parasitemia over time.

This suggests that parasite load tended to increase more strongly after exposure to the incompetent vector compared with the other groups, although the overall evidence was weaker than for gametocytemia.

### Gametocytemia

Gametocytemia showed a significant interaction between treatment and time.

The strongest increase was observed in the *Anopheles* group.  
The *Culex* group remained relatively stable, while the non-stimulated control group showed a decline over time.

This was one of the most important findings of the analysis, because the increase occurred after exposure to the incompetent vector rather than the natural competent vector.

### Corticosterone

Corticosterone showed a strong time effect but no clear difference between treatment groups.

This indicates a general short-term stress response after handling and exposure, rather than a treatment-specific response.

### C-reactive Protein

C-reactive protein did not show strong treatment-specific effects.  
There was only a weak trend over time, but no clear group difference.

### IgY Antibodies

IgY antibody levels did not show significant changes over time or between groups.

This may be related to the short observation period, because antibody responses often need more time to develop.

---

## Main Interpretation

The most important result was that gametocyte production increased after exposure to *Anopheles*, an incompetent mosquito vector.

This was unexpected, because the initial expectation was that the parasite would increase transmission stages mainly after exposure to the competent vector *Culex*.

One possible explanation is that mosquito saliva may influence host responses differently depending on the mosquito species.  
The parasite may not directly recognize the mosquito species, but may respond to physiological signals in the host that are triggered by mosquito bites.

---

## Limitations

Some limitations of the analysis were:

- small sample size for some physiological markers
- missing values in the CRP dataset
- limited observation period of seven days
- possible individual variation between birds

These limitations should be considered when interpreting the results.

---

## Conclusion

This project showed how R can be used to analyze biological response data with visualization and statistical modelling.

The results suggest that *Plasmodium relictum* may respond differently to bites from different mosquito species.  
Unexpectedly, the strongest gametocyte response was observed after exposure to an incompetent vector.

From a data analysis perspective, the project helped me practice:

- structured data preparation
- biological data visualization
- linear mixed models
- interpretation of statistical outputs
- scientific documentation of results

---

## Repository Content

```text
methods/          R script used for the analysis
results/figures/  Selected visualizations generated during the analysis
results/tables/   Selected result summaries
docs/             Short project documentation
