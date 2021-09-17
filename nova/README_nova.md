# CaNPAN Nova project

For CO and ONe nova evolution simulations, use the ``MESA`` revision 5329 **only** and your copies of the directories ``/nova_framework_canpan/co_nova`` and  ``/nova_framework_canpan/ne_nova`` from the ``CaNPAN_projects`` github repository as the corresponding mesa work directories.

The files ``/co_nova/inlist_co_nova*.template`` all use the nova reaction network ``nova_ext.net``, while the larger network ``nova_weiss.net`` is used in the files ``/ne_nova/inlist_ne_nova*.template``, which usually leads to longer execution times for ``MESA`` ONe nova evolution runs. 

In the main ``README.md`` file, read how to make ``MESA`` and ``NuGrid`` codes run on ``astrohub``.

First, as a test, try to do in your mesa work directory ``ne_nova`` a relatively fast (it still may take an hour) ``MESA`` ONe nova evolution computation with the command ``./run_mesa 1.3 30 X 2010``, where 1.3 is the ONe WD mass, 30 is its central temperature in MK, X is the symbol coding the mass accretion rate $$2\times 10^{-10}\ M_\odot\mathrm{yr}^{-1}$$, and 2010 is the number of models to compute.
When the script will ask you a few questions, skip (by answering *no*) the option of taking into account convective boundary mixing, select (by answering *yes*) the option of using a mixture of equal amounts of WD and solar-composition materials, and skip the option of saving results in a separate directory. When the computation starts, use the notebook ``nova_mesa.ipynb`` from the directory ``/nova_framework_canpan/nova_notebooks`` to track the progress of the computation.

For available combinations of the WD mass and central temperature, look in the CO and ONe WD model directories ``co_wd_models`` and ``ne_wd_models``. Note that not all of these combinations (WD models)  can be used to produce a smooth, converged and not too long-lasting ``MESA`` nova evolution simulation. Try different combinations to see which ones work well. The symbols **A, B, C, X, Z** taken by the ``run_mesa`` script code the mass accretion rates $$10^{-10}$$, $$10^{-11}$$, $$10^{-9}$$, $$2\times 10^{-10}$$, and $$6\times 10^{-8}\ M_\odot\mathrm{yr}^{-1}$$, respectively. The script will check if a desired combination of nova model parameters is available.

``MESA`` nova simulations save stellar structure data files for a following post-processing with the ``mppnp`` code in blocks of 1000 models in the directory ``co_nova_hdf`` or ``ne_nova_hdf``. Therefore, always run these simulations for a number of models slightly exceeding, say by 10, a multiple of 1000, i.e. 1010 (this is probably a minimum number), 2010, 3010, etc. At the end of a ``MESA`` nova evolution simulation, go to the directory ``co_nova_hdf`` or ``ne_nova_hdf`` and create there a file ``co_nova_hdf.idx`` or ``ne_nova_hdf.idx`` that contains an ordered list of all other files saved in this directory by ``MESA``, e.g. ``ne_nova_hdf.0000001.se.h5``, etc. These data will be used by the code ``mppnp``.

To do multi-zone post-processing nucleosynthesis computations with the ``NuGrid`` multi-zone code ``mppnp`` for finished ``MESA`` nova evolution runs use the ``NuPPN`` branch ``nova_Cl34_isomer`` that includes the treatment of Cl-34 isomers as described in this [paper](https://ui.adsabs.harvard.edu/abs/2020PhRvC.102b5801R/abstract). 
It may also be necessary to comment ``stop`` operator following the command ``write(*,*)'careful at the diffusion subroutine! '`` in the fortran code ``/nuppn/frames/mppnp/CODE/mppnp.f.``

When using the one-zone and multi-zone ``NuGrid`` codes ``ppn`` and ``mppnp``, always check first that in the directory ``nuppn/physics/phys08/CODE`` the code ``ppn_physics.F`` has opening and closing parentheses for the entire sum of various terms contributing to the rate of the reaction ``N13(P,G)O14``.

On the outreach hub server the ``NuPPN`` branch ``nova_Cl34_isomer`` is already installed and tested, so that you can ignore the above two comments. To use it, first change the default path ``PCD=../CODE`` to ``PCD=/user/scratch14_outreach/Pavel/nuppn/frames/mppnp/CODE`` in the file ``Makefile`` in your copy of the directory ``run_nova_canpan``. Then execute the commands

* ``make distclean``, and
* ``make``

They should not report any errors.

## Important technical details
``MESA`` and ``NuGrid`` ``mppnp`` CO and ONe nova computations can be done for different combinations of the initial WD mass, central temperature, and mass-accretion rate. Also, there are three ways to model mixing between the accreted H-rich and WD material: 

1. no mixing, 
2. convective boundary mixing (overshoot), and 
3. using a WD pre-mixed composition for the accreted material. 

The first and second mixing options assume that the accreted material has a solar composition, while the third options uses a mixture (usually, of equal amounts) of the solar and WD compositions.
The directories ``co_nova`` and ``ne_nova`` contain small fortran programs, such as ``co_wd_iniab.f`` and ``ne_wd_iniab_weiss.f``, that should be used to prepare necessary chemical composition files for both ``MESA`` and ``mppnp`` nova simulations (**for details, consult Pavel Denisenkov**).

**Note** that the ``mppnp`` nova code in the ``NuPPN`` branch ``nova_Cl34_isomer`` uses a list of 70 isotopes cut off at ``ni 64``.