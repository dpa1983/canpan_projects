# select one of the nova trajectories from the nova_cases directory (just uncomment below):
#
# trajectory                         Tmax (MK)  Fig # in arXiv:1303.6265 [astro-ph.SR]
#
#case=co_nova_1.15_10_B_mixed        # 257          1
#case=ne_nova_1.3_20_X_weiss_mixed   # 316          3
#case=ne_nova_1.3_7_B_weiss_mixed    # 436          4
case=ne_nova_1.15_12_X_weiss_mixed  # 263          7 (pre-mixed)
#case=co_nova_1.15_12_X_mixed        # 236          8 (pre-mixed)
#case=ne_nova_1.3_12_X_Barcelona     # 355         13
#case=ne_nova_1.3_15_X_Barcelona     # 315         13
#case=ne_nova_1.3_20_X_Barcelona     # 278         13
#
# The first number in the file name is the WD mass (in Msun), the second
# is its initial central temperature (in MK), the letter X means the
# mass accretion rate 2e-10 Msun/yr, while B means 1e-11 Msun/yr.

#### most of the time no intervention required below this line #####

# link nova case (see README file)$ 
rm -f trajectory.input initial_abundance.dat
ln -s nova_cases/$case/trajectory_$case.input  trajectory.input
ln -s nova_cases/$case/iniab_$case.dat initial_abundance.dat

#./ppn.exe |tee OUT
./ppn.exe

echo
echo Finished ppn run. Use nova_results jupyter notebook in the directory nova_notebooks to plot the results.
