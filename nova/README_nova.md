# CaNPAN Nova project

In the main ``README.md`` file, read how to make ``MESA`` and ``NuGrid`` codes running on ``Astrohub`` web servers.

For CO and ONe nova evolution simulations, use the ``MESA`` revision 5329 **only** and your copies of the directories ``/nova_framework_canpan/co_nova`` and  ``/nova_framework_canpan/ne_nova`` from the ``canpan_projects`` github repository as the corresponding mesa work directories.

The files ``/co_nova/inlist_co_nova*.template`` all use the nova reaction network ``nova_ext.net``, while the larger network ``nova_weiss.net`` is used in the files ``/ne_nova/inlist_ne_nova*.template``, which usually leads to longer execution times for ``MESA`` ONe nova evolution runs. 

First, as a test, try to do in your mesa work directory ``ne_nova`` a relatively fast (it still may take one to two hours) ``MESA`` ONe nova evolution computation with the command ``./run_mesa 1.3 30 X 2010``, where 1.3 is the ONe WD mass, 30 is its central temperature in MK, X is the symbol coding the mass accretion rate $$2\times 10^{-10}\ M_\odot\,\mathrm{yr}^{-1},$$ and 2010 is the number of models to compute.
When the script will ask you 4 questions, skip (by answering *no*) the option of taking into account convective boundary mixing, select (by answering *yes*) the option of using a mixture of equal amounts of WD and solar-composition materials, and skip the option of saving results in a separate directory. When the computation starts, use the notebook ``nova_mesa.ipynb`` from the directory ``/nova_framework_canpan/nova_notebooks`` to track the progress of the computation.

For available combinations of the WD mass and central temperature, look in the CO and ONe WD model directories ``co_wd_models`` and ``ne_wd_models``. Note that not all of these combinations (WD models)  can be used to produce a smooth, converged and not too long-lasting ``MESA`` nova evolution simulation. Try different combinations, e.g. those used in this [paper](https://ui.adsabs.harvard.edu/abs/2014MNRAS.442.2058D/abstract), to see which ones work well. The symbols **A, B, C, X, Z** taken by the ``run_mesa`` script code the mass accretion rates $10^{-10}$, $10^{-11}$, $10^{-9}$, $2\times 10^{-10}$, and $6\times 10^{-8}\ M_\odot\mathrm{yr}^{-1}$, respectively. The script will check if a desired combination of nova model parameters is available.

``MESA`` nova simulations save stellar structure data files for following multi-zone post-processing nucleosynthesis computations with the ``NuGrid`` ``mppnp`` code in blocks of either 100 or 1000 models in the directory ``co_nova_hdf`` or ``ne_nova_hdf``. Therefore, always run these simulations for a number of models slightly exceeding, say by 10, a multiple of 100 or 1000, i.e. 1010 (this is probably a minimum number), 2010, 3010, etc. 

At the end of a ``MESA`` nova evolution simulation, go to the directory ``co_nova_hdf`` or ``ne_nova_hdf`` and create there a file ``co_nova_hdf.idx`` or ``ne_nova_hdf.idx`` that contains an ordered list of all other files saved in this directory by ``MESA``, e.g. ``ne_nova_hdf.0000001.se.h5``, etc. These data will be used by the code ``mppnp``, for which a right path to the corresponding nova hdf directory must be provided in the file ``mppnp_frame.input`` in the directory ``run_nova_canpan``.

**The next two paragraphs are a reminder to the computational coordinator**

To do post-processing nucleosynthesis computations with the ``NuGrid`` multi-zone code ``mppnp`` for finished ``MESA`` nova evolution runs use the ``NuPPN`` branch ``nova_Cl34_isomer`` that includes the treatment of Cl-34 isomers as described in this [paper](https://ui.adsabs.harvard.edu/abs/2020PhRvC.102b5801R/abstract). 
It may also be necessary to comment the ``stop`` operator following the command ``write(*,*)'careful at the diffusion subroutine!'`` in the fortran code ``/nuppn/frames/mppnp/CODE/mppnp.f.``

When using the one-zone and multi-zone ``NuGrid`` codes ``ppn`` and ``mppnp``, always check first that in the directory ``nuppn/physics/phys08/CODE`` the code ``ppn_physics.F`` has opening and closing parentheses for the entire sum of various terms contributing to the rate of the reaction ``N13(P,G)O14``. Also,
check that the parameter ``IPPIV`` in this code is assigned the value 1, rather than 0. 

For those using ``NuGrid WENDI`` (``wendi2``) hub server, the ``NuPPN`` branch ``nova_Cl34_isomer`` is already installed and tested, so that you can ignore the above three comments. To use it, first change, unless it has already been done, the default path ``PCD=../CODE`` to ``PCD=/user/scratch14_wendi3/dpa/nuppn_nova/frames/mppnp/CODE`` in the file ``Makefile`` in your copy of the directory ``run_nova_canpan``. Then execute the commands

* ``make distclean``, and
* ``make``

They should not report any errors. The same thing has to be done in the directory ``ppn_nova_canpan`` if you want to use the one-zone code ``ppn`` for nova model post-processing as well.

Most other NuGrid computations, e.g. one-zone simulations of nucleosynthesis in the ``rp-process`` occurring during X-ray bursts on an accreting neutron star, can be done using the ``NuPPN`` ``master`` branch the path to which is ``PCD=/user/scratch14_wendi3/dpa/nuppn_xrb/frames/mppnp/CODE``. This path has to be provided in the file ``Makefile`` in the corresponding ``mppnp`` and ``ppn`` run directories.

## Important technical details
``MESA`` and ``NuGrid`` ``mppnp`` CO and ONe nova computations can be done for different combinations of the initial WD mass, central temperature, and mass-accretion rate. Also, there are three ways to model mixing between the accreted H-rich and WD material: 

1. no mixing, 
2. using a WD pre-mixed composition for the accreted material, and 
3. convective boundary mixing (overshoot).

The first and third mixing options assume that the accreted material has a solar composition, while the second option uses a mixture (usually, of equal amounts, but this can be changed) of the solar and WD compositions.

For nova models, ``NuGrid`` multi-zone post-processing nucleosynthesis computations are always done with the parameter ``iabuini = 20``, as specified in the file ``ppn_frame.input``. In all cases, both a file with chemical composition of the accreted material, ``iniab_ne_nova_mwd_tc_mixed.dat_cut``, and a file with the WD chemical composition, ``ne_wd_mwd_tc_mixed.ppn_cut``, have to be prepared and placed in the ``run_nova_canpan`` directory.

``mppnp`` computations can be launched with the command ``nice -n 19 mpirun -np 4 ./mppnp.exe 1> log 2> err  &``. Before each start check that the file ``last_restart.out`` contains ``0 1`` in its first and only raw. The progress of ``mppnp`` computations can be seen with the command ``tail -n 100 summaryinfo.dat``. Its results are placed in the directories ``H5_out`` and ``H5_surf``.  

**Note** that the ``mppnp`` code in the ``NuPPN`` branch ``nova_Cl34_isomer`` uses a list of 70 stable isotopes cut off at ``ni 64``. The total number of isotopes in the computation, including unstable ones, is 147.

If you want to complement multi-zone post-processing with one-zone post-processing of a same nova model, an additional chemical composition file, ``initial_abundance.dat``, has to be created and placed in the directory ``ppn_nova_canpan``. It differs from its corresponding file ``iniab_ne_nova_mwd_tc_mixed.dat_cut`` by a larger number of stable isotopes, 286 instead of 70. A right ``trajectory.input`` file has also to be placed in the directory ``ppn_nova_canpan``.
It can be prepared with the notebook ``nova_mppnp.ipynb`` using results of the corresponding multi-zone post-processing. ``ppn`` computations are launched with the command ``ppn.exe``, and their results can be deleted with the command ``./clean_output``, both executed in the directory ``ppn_nova_canpan``.

For nova multi-zone post-processing, a value of the minimum mass coordinate, ``xmrmin``, in the file ``ppn_frame.input`` has to be **negative**,
with its absolute value providing a mass coordinate of the boundary separating WD and accreted envelope. This value can be estimated using the notebook ``nova_mesa.ipynb``.

For the second mixing case, a file with chemical composition representing a mixture of CO (ONe) WD and solar-composition materials, ``co(ne)_nova_mwd_mixed_comp``, has also to be created in the directory ``co(ne)_nova`` for ``MESA`` nova evolution simulations. 
In the names of these files, ``mwd`` is the WD mass, and ``tc`` is its central temperature.

**Note** that for CO nova models with the CO WD masses 1.0, 1.15, and 1.2, as well as for the ONe nova models with the ONe WD masses 1.15 and 1.3 the files ``co_nova_mwd_mixed_comp`` and ``ne_nova_mwd_mixed_comp`` are already present in the corresponding directories.

If it is necessary, all four chemical composition files can be prepared with the small fortran programs, ``co_wd_iniab.f`` and ``ne_wd_iniab_weiss.f``, available in the directories ``co_nova`` and ``ne_nova``, respectively. In these programs you will only need to specify the name of a selected WD model, e.g. ``co_wd_1.15_12_mixed.mod``, and the fraction of WD material in the accreted envelope, e.g. ``fmix = 0.0`` or ``fmix = 0.5`` for the first and second mixing cases. The value of ``fmix = 1.0`` can be used to prepare a file with WD chemical composition.  