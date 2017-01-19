This directory contains the analysis of all batches of the full
triplicate cascade experiments.

Controls:
  built a control with each bead/control set (except for time series, where I only selected one)
  compared all bead files to find degree of variation
    Channel:   Close Sets:
    Blue       1     4 5 6 7 8 9
    Red	         2 3 4 5   7     10
    Yellow     1     4 5 6 7   9 10
  choose #5: 11/07 T58 as the apparently least different on all three channels
    max difference is around 10%, except from 10/31 beads #2 Red channel, which is worse

Devices:
  TAL14: OK
  TAL21: only 2 data sets, some spots have only 1 good point
  LmrA:  OK

Cascades:
  LmrA-TAL14:	OK - though some high-plasmid outliers should be trimmed
  LmrA-TAL21:	OK - though some high-plasmid outliers should be trimmed
  TAL14-LmrA:	OK
  TAL14-TAL21:	OK
  TAL21-LmrA:	OK
  TAL21-TAL14:	OK

Series Analysis:
  Constitutive	OK
     note that const for characterization circuits is 0.5x of controls, 
     which is consistent w. DNA dose (50ng vs. 100ng)
  Gal4		OK
  rtTA		OK
  
  All devices have approximately the same peaking curve.

  What this means is that rtTA acts effectively at extremely low
  concentration, such that the effective delay between constitutive
  production of protein and the production of Dox-controlled protein
  is effectively nil.  Thus, we can treat the Dox curve as though
  it is already in place.


Predictions:
  Basic approaches get us fairly close, but then we run into a barrier
  where the predictions are almost uniformly:
  - too flat
  - bunched together, so the high is too high and the low too low
  Considering first just TAL14 and TAL21, we find there is no chance of
  this being a cross-experiment effect, since TAL14 and TAL21 were
  measured at the same time as one another and their cascade.

  Approach:
  - calibrate based on observed mean expression levels -- all Dox induction
    should be the same, and also all plain Gal4 expression
  - simulate dynamics light-weight - linear 

---------------
Additional availables:

* "8/24/2012 new dna conc" has the same protocols. These are the ones
  we based the new predictions results on.

* also TAL21 time series from 9/11 are good as well. So you can use
  the later time points as a quadruplicate. AND you can use a TAL21 72
  hours from this recent time series as 5 and 6 for TAL21
