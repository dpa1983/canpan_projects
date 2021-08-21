! ***********************************************************************
!
!   Copyright (C) 2010  Bill Paxton
!
!   this file is part of mesa.
!
!   mesa is free software; you can redistribute it and/or modify
!   it under the terms of the gnu general library public license as published
!   by the free software foundation; either version 2 of the license, or
!   (at your option) any later version.
!
!   mesa is distributed in the hope that it will be useful, 
!   but without any warranty; without even the implied warranty of
!   merchantability or fitness for a particular purpose.  see the
!   gnu library general public license for more details.
!
!   you should have received a copy of the gnu library general public license
!   along with this software; if not, write to the free software
!   foundation, inc., 59 temple place, suite 330, boston, ma 02111-1307 usa
!
! ***********************************************************************
 
      module run_star_extras

      use star_lib
      use star_def
      use const_def

!     use alert_lib
      use mlt_def
      
      implicit none
      
      integer :: time0, time1, clock_rate
      double precision, parameter :: expected_runtime = 120 ! minutes

      
      contains
      
      
      subroutine extras_controls(s, ierr)
         type (star_info), pointer :: s
         integer, intent(out) :: ierr
         ierr = 0

         ! this is the place to set any procedure pointers you want to change
         ! e.g., other_wind, other_mixing, other_energy  (see star_data.inc)

         s % other_mixing => pavel_mixing_CBM

      end subroutine extras_controls
      
      
      integer function extras_startup(s, id, restart, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id
         logical, intent(in) :: restart
         integer, intent(out) :: ierr
         ierr = 0
         extras_startup = 0
         call system_clock(time0,clock_rate)
         if (.not. restart) then
            call alloc_extra_info(s)
         else ! it is a restart
            call unpack_extra_info(s)
         end if
      end function extras_startup
      
      
      subroutine extras_after_evolve(s, id, id_extra, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         integer, intent(out) :: ierr
         double precision :: dt
         ierr = 0
         call system_clock(time1,clock_rate)
         dt = dble(time1 - time0) / clock_rate / 60
         if (dt > 10*expected_runtime) then
            write(*,'(/,a30,2f18.6,a,/)') '>>>>>>> EXCESSIVE runtime', &
               dt, expected_runtime, '   <<<<<<<<<  ERROR'
         else
            write(*,'(/,a30,2f18.6,2i10/)') 'runtime, retries, backups', &
               dt, expected_runtime, s% num_retries, s% num_backups
         end if
      end subroutine extras_after_evolve
      

      ! returns either keep_going, retry, backup, or terminate.
      integer function extras_check_model(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         extras_check_model = keep_going         

         if (s% log_surface_luminosity > 4d0) then
            s% overshoot_f_above_burn_h = 0d0
            s% overshoot_f_below_burn_h = 0d0
            s% mass_change = 0d0
         end if

       ! if (s% log_surface_luminosity > 4.3d0) then
       !    s% mixing_length_alpha = 0.01d0
       !    s% l1_coef = 0d0
       !    s% mix_factor = 1d-3
       !    s% mass_change = 0d0
       ! end if

         if (s% log_surface_luminosity > 4d0) then
            s% mixing_length_alpha = 1d0
         end if

       ! if (s% log_surface_luminosity > 4d0 .and. s% Teff < 5d5) then
       !    s% mixing_length_alpha = 0.5d0
       !    s% mass_change = 0d0
       ! end if

      end function extras_check_model


      integer function how_many_extra_history_columns(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         how_many_extra_history_columns = 0
      end function how_many_extra_history_columns
      
      
      subroutine data_for_extra_history_columns(s, id, id_extra, n, names, vals, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra, n
         character (len=maxlen_history_column_name) :: names(n)
         real(dp) :: vals(n)
         integer, intent(out) :: ierr
         ierr = 0
      end subroutine data_for_extra_history_columns

      
      integer function how_many_extra_profile_columns(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         how_many_extra_profile_columns = 0
      end function how_many_extra_profile_columns
      
      
      subroutine data_for_extra_profile_columns(s, id, id_extra, n, nz, names, vals, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra, n, nz
         character (len=maxlen_profile_column_name) :: names(n)
         double precision :: vals(nz,n)
         integer, intent(out) :: ierr
         integer :: k
         ierr = 0
      end subroutine data_for_extra_profile_columns
      

      ! returns either keep_going or terminate.
      integer function extras_finish_step(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         integer :: ierr
         extras_finish_step = keep_going
         call store_extra_info(s)
      end function extras_finish_step
      
      
      ! routines for saving and restoring extra data so can do restarts
         
         ! put these defs at the top and delete from the following routines
         !integer, parameter :: extra_info_alloc = 1
         !integer, parameter :: extra_info_get = 2
         !integer, parameter :: extra_info_put = 3
      
      
      subroutine alloc_extra_info(s)
         integer, parameter :: extra_info_alloc = 1
         type (star_info), pointer :: s
         call move_extra_info(s,extra_info_alloc)
      end subroutine alloc_extra_info
      
      
      subroutine unpack_extra_info(s)
         integer, parameter :: extra_info_get = 2
         type (star_info), pointer :: s
         call move_extra_info(s,extra_info_get)
      end subroutine unpack_extra_info
      
      
      subroutine store_extra_info(s)
         integer, parameter :: extra_info_put = 3
         type (star_info), pointer :: s
         call move_extra_info(s,extra_info_put)
      end subroutine store_extra_info
      
      
      subroutine move_extra_info(s,op)
         integer, parameter :: extra_info_alloc = 1
         integer, parameter :: extra_info_get = 2
         integer, parameter :: extra_info_put = 3
         type (star_info), pointer :: s
         integer, intent(in) :: op
         
         integer :: i, j, num_ints, num_dbls, ierr
         
         i = 0
         ! call move_int or move_flg    
         num_ints = i
         
         i = 0
         ! call move_dbl       
         
         num_dbls = i
         
         if (op /= extra_info_alloc) return
         if (num_ints == 0 .and. num_dbls == 0) return
         
         ierr = 0
         call star_alloc_extras(s% id, num_ints, num_dbls, ierr)
         if (ierr /= 0) then
            write(*,*) 'failed in star_alloc_extras'
            write(*,*) 'alloc_extras num_ints', num_ints
            write(*,*) 'alloc_extras num_dbls', num_dbls
            stop 1
         end if
         
         contains
         
         subroutine move_dbl(dbl)
            double precision :: dbl
            i = i+1
            select case (op)
            case (extra_info_get)
               dbl = s% extra_work(i)
            case (extra_info_put)
               s% extra_work(i) = dbl
            end select
         end subroutine move_dbl
         
         subroutine move_int(int)
            integer :: int
            i = i+1
            select case (op)
            case (extra_info_get)
               int = s% extra_iwork(i)
            case (extra_info_put)
               s% extra_iwork(i) = int
            end select
         end subroutine move_int
         
         subroutine move_flg(flg)
            logical :: flg
            i = i+1
            select case (op)
            case (extra_info_get)
               flg = (s% extra_iwork(i) /= 0)
            case (extra_info_put)
               if (flg) then
                  s% extra_iwork(i) = 1
               else
                  s% extra_iwork(i) = 0
               end if
            end select
         end subroutine move_flg
      
      end subroutine move_extra_info

      subroutine pavel_mixing_CBM(id, ierr)

         use chem_def, only: ihe4

       !
       ! with the most recent versions of MESA use this
       !
       ! use star_lib, only: star_ptr, star_adjust_gradT_fraction, &
       !                     star_adjust_gradT_excess

         integer, intent(in) :: id
         integer, intent(out) :: ierr
         integer :: k, nz
         double precision ::  D_mlt, fac, fac2, Gam, a0
         double precision :: dq00, dqm1, dqsum, T, kap, rho, cp, &
           thermal_diffusivity
         type (star_info), pointer :: s
         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return

         nz = s% nz

         a0 = 9d0/4d0     !  see MLT in Cox & Guili's Principles of Stellar
         fac2 = 2d0/3d0   !  Structure by Weiss et al. 2004

         do k = 2, nz ! start at 2 since no mixing across surface
            if (s% mixing_type(k) .ne. overshoot_mixing) cycle
           ! interpolate values at face
            dq00 = s% dq(k)
            dqm1 = s% dq(k-1)
            dqsum = dq00 + dqm1
            kap = (dqm1*s% opacity(k) + dq00*s% opacity(k-1))/dqsum
            rho = (dqm1*s% rho(k) + dq00*s% rho(k-1))/dqsum
            cp = (dqm1*s% cp(k) + dq00*s% cp(k-1))/dqsum
            T = (dqm1*s% T(k) + dq00*s% T(k-1))/dqsum
            thermal_diffusivity = 4*crad*clight*T**3/(3*kap*rho**2*cp)
            Gam = fac2 * s% D_mix(k)/thermal_diffusivity
            fac = a0*Gam**2/(1d0+Gam*(1d0+a0*Gam))   !  see arXiv:1305.2649 [astro-ph.SR]
            if (Gam > 1d3 ) fac = 0.999d0
            if (Gam < 0.1d0 ) fac = 0d0
            if (fac > 1d0) fac = 1d0
            if (fac < 0d0) fac = 0d0

            s% adjust_mlt_gradT_fraction(k) = fac

          !
          ! with the most recent versions of MESA use this
          !
          ! call star_adjust_gradT_fraction(id, k, fac)
          ! call star_adjust_gradT_excess(id, k)

         end do

      end subroutine pavel_mixing_CBM

      end module run_star_extras
      
