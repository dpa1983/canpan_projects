# CaNPAN_projects

### Tutorials, notebooks and other files for CaNPAN projects

To run stellar evolution simulations with the ``MESA`` revision 5329 code on ``astrohub`` server go to ``astrohub/PPMstar`` and load ``MESA`` latest lab. Then, in a terminal window go to a mesa work directory, e.g. ``/user/scratch14_ppmstar/Pavel/work_mesa_5329``, and execute the following commands:

* ``export MESA_DIR=/user/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``
* ``export MESASDK_ROOT=/home/user/mesasdk``

The last command is needed only for a ``MESA`` installation.
After that, try to first execute the command ``./mk`` to see that everything is set up correctly, otherwise there will be some error messages, then run ``MESA`` with the command ``nice -n 19 ./rn``

If it is necessary, the ``MESA`` revision 5329 can be replaced with the revision 7624, in which case a different ``mesasdk`` package will probably be required for the ``MESA`` code installation.

To run ``MESA`` simulations from ``astrohub/CSA`` choose ``MESA`` latest lab, go to a mesa work directory, e.g. ``/user/scratch14_wendi3/dpa/my_mesa_5329/work``, and execute the following commands:

* ``export MESA_DIR=/user/scratch14_ppmstar/mesa/mesa_5329``
* ``export OMP_NUM_THREADS=8``