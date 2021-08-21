# CaNPAN_projects

### Tutorials, notebooks and other files for CaNPAN projects

To run ``MESA`` simulations on ``astrohub`` server go to ``astrohub/PPMstar`` and load ``MESA`` latest lab. Then, in a terminal window go to the directory ``/user/scratch14_ppmstar/Pavel/work_mesa_5329`` and execute the following commands:

* ``export MESA_DIR=/user/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``
* ``export MESASDK_ROOT=/home/user/mesasdk``

The last command is needed only for ``MESA`` installation.
After that, run ``MESA`` with the command ``nice -n 19 ./rn``

If necessary, the ``MESA`` revision 5329 can be replaced with 7624, in which case a different ``mesasdk`` package will probably be required for the ``MESA`` code installation.

To run ``MESA`` simulations from ``astrohub/CSA`` choose ``MESA`` latest lab, go to ``/user/scratch14_wendi3/dpa/my_mesa_5329/work`` and execute the following commands:

* ``export MESA_DIR=/user/scratch14_ppmstar/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``