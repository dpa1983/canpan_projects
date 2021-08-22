# Nova project

For CO or ONe nova evolution simulations, use the ``MESA`` revision 5329 **only** and the directories ``/nova_framework_canpan/co_nova`` or  ``/nova_framework_canpan/ne_nova``from this repository as the corresponding mesa work directory.

The files ``/co_nova/inlist_co_nova_*.template`` all use the nova reaction network ``nova_ext.net``, while the larger network ``nova_weiss.net`` is used in the files ``/ne_nova/inlist_ne_nova_*.template``, which usually leads to longer execution times for ``MESA`` ONe nova evolution runs. 

First, try to do a relatively fast ``MESA`` ONe nova evolution computation with the command ``./run_mesa 1.3 30 X 2010`` in the mesa work directory ``/ne_nova``, skipping (by answering *no*) the option of taking into account convective boundary mixing, selecting (by answering *yes*) the option of using a mixture of equal amounts of WD and solar-composition materials, and also skipping the option of saving results in a separate directory. When the computation starts, use the notebook ``nova_mesa.ipynb`` from the directory ``/nova_framework_canpan/nova_notebooks`` to track the progress of the computation.

To do multi-zone post-processing nucleosynthesis computations with the ``NuGrid`` code ``mppnp`` for finished ``MESA`` nova evolution runs use the ``NuPPN`` branch ``nova_Cl34_isomer`` that includes the treatment of Cl-34 isomers as described in [paper](https://ui.adsabs.harvard.edu/abs/2020PhRvC.102b5801R/abstract). 
It may also be necessary to comment ``stop`` operator following the command ``write(*,*)'careful at the diffusion subroutine! '`` in the fortran code ``/nuppn/frames/mppnp/CODE/mppnp.f.``

When using the one-zone and multi-zone ``NuGrid`` codes ``ppn`` and ``mppnp``, always check first that in the directory ``nuppn/physics/phys08/CODE`` the code ``ppn_physics.F`` has opening and closing parentheses for the entire sum of various terms contributing to the rate of the reaction ``N13(P,G)O14``.

``MESA`` nova simulations save stellar structure data files for a following post-processing with the ``mppnp`` code in blocks of 1000 models. Therefore, always run these simulations for a number of models slightly exceeding, say by 10, a multiple of 1000, i.e. 1010 (this is probably a minimum number), 2010, 3010, etc.

## Important technical details
``MESA`` and ``NuGrid`` ``mppnp`` CO and ONe nova computations can be done for different combinations of the initial WD mass, central temperature, and mass-accretion rate. Also, there are three ways to model mixing of accreted H-rich and WD material: 

1. no mixing, 
2. convective boundary mixing (overshoot), and 
3. using a WD pre-mixed composition for the accreted material. 

The directories ``co_nova`` and ``ne_nova`` contain small fortran programs, such as ``co_wd_iniab.f`` and ``ne_wd_iniab_weiss.f``, that should be used to prepare necessary chemical composition files for both ``MESA`` and ``mppnp`` nova simulations.

Our ``mppnp`` nova code uses a list of 70 isotopes cut off at ``ni 64``.