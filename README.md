# Thermal Comfort

This repository currently has available two thermal comfort assessment methods:

   * PMV
   * Adaptive Method
 
## PMV
 
The PMV method is mostly based of [CBE Comfort Tool](https://github.com/CenterForTheBuiltEnvironment/comfort_tool). It uses R code to wrap around the `pmvElevatedAirSpeed` javascript function (which in turn depend on a few other javascript functions also available on this repository pmv folder to be self contained but authored by the CBE Comfort Tool group), making PMV/PPD calculation scriptable.

`pmv/calculate_pmv_ppd.R` contains a simple script, and `frog_uhm_thermal_comfort.Rmd` a notebook explaining the steps. See [Rpubs](http://rpubs.com/carlosandrade/frogs_pmv) for a readable version showing plots and code. 

## Adaptive Method

The adaptive method is based purely of ASHRAE55, and does not use CBE Comfort Tool code.

The R code is currently only available as a notebook on `adaptive_method.Rmd`.  You can find a readable version also on [Rpubs](http://rpubs.com/carlosandrade/adaptive_method).

http://rpubs.com/carlosandrade/frogs_pmv
