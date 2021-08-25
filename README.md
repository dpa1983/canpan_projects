# CaNPAN_projects

### Tutorials, notebooks and other files for CaNPAN projects

To run stellar evolution simulations with the ``MESA`` code revision 5329 on ``astrohub/outreach`` server, go to a mesa work directory, e.g. ``/user/scratch14_outreach/Pavel/canpan_projects/nova/nova_framework_canpan/ne_nova``, and execute the following commands:

* ``export MESA_DIR=/user/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``

After that, try to first execute the command ``./mk`` to see that everything is set up correctly, otherwise there will be some error messages. **Make sure** that the mesa work directory has the sub-directories ``LOGS``, ``photos``, ``co_nova_hdf`` or ``ne_nova_hdf``, ``co_nova_plots`` or ``ne_nova_plots``, ``png_main``, and ``png_abund``. If not, make them, then run ``MESA`` with the command ``nice -n 19 ./rn``
For nova evolution simulations, use the special script with desired nova model parameters, e.g. for ONe nova try to use 
``./run_mesa 1.3 30 X 2010``, where 1.3 is the ONe WD mass, 30 is its central temperature in MK, X is the symbol for the mass accretion rate $$2\times 10^{-10}\ M_\odot/\mathrm{yr}$$, and 2010 is the number of models to compute (for details, see ``README_nova.md`` file in the ``nova`` directory). 

To run ``mppnp`` nova simulations from a copy of the directory ``run_nova_canpan`` on ``astrohub/outreach``, change the default path ``PCD=../CODE`` to ``PCD=/user/scratch14_outreach/Pavel/nuppn/frames/mppnp/CODE`` in the file ``Makefile``. Then execute the commands

* ``make distclean``, and
* ``make``

For further details, see the ``README_nova.md`` file in the ``nova`` directory.

To run ``MESA`` on ``astrohub/PPMstar`` load ``MESA`` latest lab. Then, in a terminal window go to a mesa work directory, e.g. ``/user/scratch14_ppmstar/Pavel/work_mesa_5329``, and execute the following commands:

* ``export MESA_DIR=/user/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``
* ``export MESASDK_ROOT=/home/user/mesasdk``

The last command is needed only for ``MESA`` code installation.
If it is necessary, the ``MESA`` revision 5329 can be replaced with the revision 7624, in which case a different ``mesasdk`` package will probably be required for the ``MESA`` code installation.

To run ``MESA`` simulations from ``astrohub/CSA`` choose ``MESA`` latest lab, go to a mesa work directory, e.g. ``/user/scratch14_wendi3/dpa/my_mesa_5329/work``, and execute the following commands:

* ``export MESA_DIR=/user/scratch14_ppmstar/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``