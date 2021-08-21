# Nova project

For ``MESA`` CO nova simulations, use the directory ``//user/scratch14_wendi3/dpa/nova_framework_astrohub/co_nova``

In files ``inlist_co_nova_*.template`` a nova reaction network can be selected between ``nova.net``, ``nova_ext.net`` and ``nova_weiss.net``, in the order of an increasing number of included isotopes and reactions and, correspondingly, an increasing execution time. 

When using the ``ppn`` and ``mppnp`` ``NuGrid`` codes, always check first that in the directory ``nuppn/physics/phys08/CODE`` the code ``ppn_physics.F`` has opening and closing parentheses for the entire sum of various terms contributing to the rate of the reaction ``N13(P,G)O14``.

It is better to use the ``NuPPN`` branch ``nova_Cl34_isomer`` that includes the treatment of Cl-34 isomers as in this [paper](https://ui.adsabs.harvard.edu/abs/2020PhRvC.102b5801R/abstract).
When post-processing ``MESA`` nova simulations with the ``NuGrid`` code ``mppnp``, it may be necessary to comment ``stop`` operator following the command ``write(*,*)'careful at the diffusion subroutine! '``.

``MESA`` nova simulations save stellar structure data files for a following post-processing with the ``mppnp`` code in blocks of 1000 models. Therefore, always run these simulations for a number of models slightly exceeding, say by 10, a multiple of 1000, i.e. 1010 (this is probably a minimum number), 2010, 3010, etc.

## Important technical details
``MESA`` and ``NuGrid`` ``mppnp`` CO and ONe nova computations can be done for different combinations of the initial WD mass, central temperature, and mass-accretion rate. CO and ONe nova computations use the nuclear reaction networks ``nova_ext.net`` and ``nova_weiss.net``, respectively. The second network includes more isotopes and reactions, therefore ONe nova computations take longer execution times that can reach a few hours. Also, there are three ways to model mixing of accreted H-rich and WD material: no mixing, convective boundary mixing (overshoot), and using a WD pre-mixed composition for the accreted material. The directories ``co_nova`` and ``ne_nova`` contain small fortran programs, such as ``co_wd_iniab.f`` and ``ne_wd_iniab.f``, that should be used to prepare necessary chemical composition files for both ``MESA`` and ``mppnp`` nova simulations.

Our ``mppnp`` nova code uses a list of 70 isotopes cut off at ``ni 64``.