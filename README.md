# CaNPAN_projects

## Introduction

[https://github.com/dpa1983/canpan_projects.git](https://github.com/dpa1983/canpan_projects.git) is a ``github`` public repository with tutorials, Python 3 Jupyter notebooks and other files that are being developed for CaNPAN projects in computational nuclear astrophysics. These projects may require doing both [MESA](http://mesa.sourceforge.net) stellar evolution simulations and [NuGrid](https://nugrid.github.io) one- or multi-zone post-processing nucleosynthesis computations. For some projects conducting Monte Carlo sensitivity and uncertainty studies for selected reaction rates may also be necessary.

Here are **basic instructions** on how to get started using ``canpan_projects`` tools on ``Astrohub`` web servers:

1. Preferably, use the [Google Chrome](https://www.google.com/intl/en_ca/chrome/) internet browser.
2. If you have not done this before, go to the site [github.com](http://github.com) and register there for free, e.g. as a student or a teacher.
3. Go to [Astrohub Gateway](https://astrohub.uvic.ca) that offers an access to  **NuGrid WENDI hub** (click on the *red hub* there). It can be used **only by NuGrid members** (all others can access **TINA hub** that makes it possible to use ``canpan_projects`` tools for beginners). Spawn (by clicking on the *orange bar*) the Jupyter Lab Application: *MESAHub: Run and analyse MESA/NuGrid simulations*. Then, in the Jupyter Lab Launcher window click *Terminal*.
4. In an opened linux terminal window, go to the directory ``/user/scratch14_outreach``, make there a directory with your name and go to it.
5. Inside the new directory ``your_name`` execute the following command: ``git clone https://github.com/dpa1983/canpan_projects.git``. It will clone the github repository ``canpan_projects`` in your directory.

## Running MESA and NuGrid codes on astrohub 

### Running MESA and NuGrid codes on NuGrid WENDI (wendi2) hub server

To run stellar evolution simulations with the ``MESA`` code revision 5329 on ``astrohub/wendi2``, go to a mesa work directory, e.g. to ``/user/scratch14_outreach/your_name/canpan_projects/nova/nova_framework_canpan/ne_nova``, and execute the following commands:

* ``export MESA_DIR=/user/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=4``

**Note** that these commands must be executed in **every** ``MESA`` work directory where you are going to run stellar evolution simulations.

After that, try to first execute the command ``./clean`` and then ``./mk`` to see that everything is set up correctly, otherwise there will be some error messages. **Make sure** that the mesa work directory has the sub-directories ``LOGS``, ``photos``, ``co_nova_hdf`` (in ``co-nova``) or ``ne_nova_hdf`` (in ``ne_nova``), and ``co_nova_plots`` (in ``co-nova``) or ``ne_nova_plots`` (in ``ne_nova``), and if it does not, make them. For ``MESA`` custom stellar evolution simulations, run the code with the command ``nice -n 19 ./rn``. For ``MESA`` **nova simulations**, use the special script with desired nova model parameters, e.g. for an ONe nova case try to use 
``./run_mesa 1.3 30 X 2010``, where 1.3 is the ONe WD mass, 30 is its central temperature in MK, X is the symbol coding the mass accretion rate $$2\times 10^{-10}\ M_\odot\mathrm{yr}^{-1}$$, and 2010 is the number of models to compute (for more details on MESA nova simulations, see ``README_nova.md`` file in the ``nova`` directory). 

To simulate nova nucleosynthesis with a larger nuclear reaction network than in ``MESA``, run the NuGrid multi-zone post-processing nucleosynthesis code ``mppnp`` from your copy of the directory ``run_nova_canpan``. To do this on the ``wendi2`` hub server first change, unless it has already been done, the default path ``PCD=../CODE`` to ``PCD=/user/scratch14_wendi3/dpa/nuppn_nova/frames/mppnp/CODE`` in the file ``Makefile`` in the directory ``run_nova_canpan``. Then execute the commands

* ``make distclean``, and
* ``make``

They should not report any errors. For further details, see the ``README_nova.md`` file in the ``nova`` directory. For NuGrid one-zone post-processing nucleosynthesis computations, the same things have to be done in the directory ``ppn_nova_canpan``.

For NuGrid one-zone post-processing computations of nucleosynthesis in the ``rp-process`` during Type-I X-ray bursts on an accreting neutron star use the path ``PCD=/user/scratch14_wendi3/dpa/nuppn_xrb/frames/mppnp/CODE`` in the file ``Makefile`` in the directory ``ppn_xrb_canpan``.

### Running MESA on PPMstar hub server

To run ``MESA`` on ``astrohub/PPMstar`` load ``MESA`` latest lab. Then, in a terminal window go to a mesa work directory, e.g. to ``/user/scratch14_ppmstar/Pavel/work_mesa_5329``, and execute the following commands:

* ``export MESA_DIR=/user/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=4``
* ``export MESASDK_ROOT=/home/user/mesasdk``

The last command is needed only for ``MESA`` code installation.
If it is necessary, the ``MESA`` revision 5329 can be replaced with the revision 7624, in which case a different ``mesasdk`` package will probably be required for the ``MESA`` code installation.

### Running MESA on CSA hub server

To run ``MESA`` simulations on ``astrohub/CSA`` choose ``MESA`` latest lab, go to a mesa work directory, e.g. to ``/user/scratch14_wendi3/dpa/my_mesa_5329/work``, and execute the following commands:

* ``export MESA_DIR=/user/scratch14_ppmstar/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=4``