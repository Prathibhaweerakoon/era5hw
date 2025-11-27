# ERA5 Daily Cumulative → Hourly Increment Converter (Fortran)

This program converts ERA5 cumulative daily precipitation & evaporation into hourly increments.
It resets every 24 hours and clips negatives/positives as required.

## Files

- types.f90
- dataanalyses.f90
- main.f90
- era5_input.txt
- era5_corrected.txt

## How to compile

gfortran -Wall -Wextra -g -fbounds-check -fimplicit-none \
  -ffree-line-length-none types.f90 dataanalyses.f90 main.f90 -o era5_proc

## How to run

./era5_proc

The output will be written to:

era5_corrected.txt
