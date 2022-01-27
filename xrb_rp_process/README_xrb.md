# CaNPAN X-ray burst (XRB) project

In the main ``README.md`` file, read how to make ``MESA`` and ``NuGrid`` codes run on ``Astrohub`` web servers.

For simulations of  XRBs on an accreting neutron star and ensuing rp-process nucleosynthesis, use the ``MESA`` revision 7624 **only** and your copy of the directory ``/xrb_rp_process/xrb_mesa_canpan`` from the ``canpan_projects`` github repository as the corresponding mesa work directories.

The file ``inlist_ns_h`` uses the cut-off rp-process reaction network ``rp_153.net`` that is sufficient to relatively well simulate both rp-process nucleosynthesis and energetics in ``MESA``. Using the larger network ``rp.net`` leads to much longer execution times for ``MESA`` XRB simulation runs. 

Avoid running ``MESA`` XRB simulations with the command ``./rn`` that computes a large number of subsequent XRBs and therefore takes about 24 hours to complete. Instead, copy the model structure file ``x100`` from the directory ``photos_start_file`` to ``photos`` and run the ``MESA`` simulation for one XRB with the command ``./re x100``. Its results, as well as results of a longer run with a number of XRBs, can be analyzed with the notebook ``mesa_xray_burst.ipynb`` that lives in the directory
``xrb_rp_process/xrb_notebooks``. 

``MESA`` XRB simulations save neutron star envelope structure data files for a following multi-zone post-processing nucleosynthesis computations with the ``NuGrid`` ``mppnp`` code (setup of the multi-zone computations is still a work in progress) in the directory ``ns_star_hdf``. These data are also used by the XRB analysis notebook ``mesa_xray_burst.ipynb`` to extract a temperature and density trajectory for a selected XRB and output it into a file with the default name ``trajectory.input``. When this file is copied to the directory ``xrb_rp_process/ppn_xrb_canpan``  it can be used to run there one-zone post-processing computations of rp-process nucleosynthesis with the ``NuGrid`` code ``ppn``.
To use this code on the ``NuGrid WENDI`` (``wendi2``) hub server, first change, unless it has already been done, the default path ``PCD=../CODE`` to ``PCD=/user/scratch14_wendi3/dpa/nuppn_xrb/frames/ppn/CODE`` in the file ``Makefile`` in your copy of the directory ``ppn_xrb_canpan``. Then execute the commands

* ``make distclean``, and
* ``make``

They should not report any errors. The one-zone simulation starts with the command ``./ppn.exe``.