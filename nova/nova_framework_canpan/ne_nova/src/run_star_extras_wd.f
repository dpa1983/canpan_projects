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
      
      use alert_lib
      use mlt_def
      
      implicit none
      
      ! these routines are called by the standard run_star check_model
      contains
      
      subroutine extras_controls(s, ierr)
         type (star_info), pointer :: s
         integer, intent(out) :: ierr
         ierr = 0
         
         ! this is the place to set any procedure pointers you want to change
         ! e.g., other_wind, other_mixing, other_energy  (see star_data.dek)

         s % other_mixing => pavel_mixing_wd

      end subroutine extras_controls
      
      
      integer function extras_startup(s, id, restart, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id
         logical, intent(in) :: restart
         integer, intent(out) :: ierr
         ierr = 0
         extras_startup = 0
         if (.not. restart) then
            call alloc_extra_info(s)
         else ! it is a restart
            call unpack_extra_info(s)
         end if
      end function extras_startup
      

      ! returns either keep_going, retry, backup, or terminate.
      integer function extras_check_model(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         extras_check_model = keep_going         
         if (.false. .and. s% star_mass_h1 < 0.35d0) then
            ! stop when star hydrogen mass drops to specified level
            extras_check_model = terminate
            write(*, *) 'have reached desired hydrogen mass'
            return
         end if
      end function extras_check_model


      integer function how_many_extra_log_columns(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         how_many_extra_log_columns = 0
      end function how_many_extra_log_columns
      
      
      subroutine data_for_extra_log_columns(s, id, id_extra, n, names, vals, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra, n
         character (len=maxlen_log_column_name) :: names(n)
         double precision :: vals(n)
         integer, intent(out) :: ierr
         ierr = 0
      end subroutine data_for_extra_log_columns

      
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
         ! here is an example for adding a profile column
         !if (n /= 1) stop 'data_for_extra_profile_columns'
         !names(1) = 'beta'
         !do k = 1, nz
         !   vals(k,1) = s% Pgas(k)/s% P(k)
         !end do
      end subroutine data_for_extra_profile_columns
      

      ! returns either keep_going or terminate.
      integer function extras_finish_step(s, id, id_extra)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         integer :: ierr
         extras_finish_step = keep_going
         call store_extra_info(s)

         ! to save a profile, 
            ! s% need_to_save_profiles_now = .true.
         ! to update the star log,
            ! s% need_to_update_logfile_now = .true.
            
      end function extras_finish_step
      
      
      subroutine extras_after_evolve(s, id, id_extra, ierr)
         type (star_info), pointer :: s
         integer, intent(in) :: id, id_extra
         integer, intent(out) :: ierr
         ierr = 0
      end subroutine extras_after_evolve
      
      
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


      ! examples of other_mixing subroutines
 
      
      ! examples
                  
      
      subroutine pavel_mixing_wd(id, ierr)

         use chem_def, only: ih1

         integer, intent(in) :: id
         integer, intent(out) :: ierr         
         integer :: i, k, nz, k_bce, h1
         type (star_info), pointer :: s
         double precision :: gradmu_alt, gradr, grada, &
            dq00, dqm1, dqsum, T, kap, rho, cp, thermal_diffusivity, &
            bce_r, bce_Hp, bce_D
         logical, parameter :: dbg = .false.

         include 'formats.dek'

         ierr = 0
         call get_star_ptr(id, s, ierr)
         if (ierr /= 0) return

       ! if (s% model_number < 100 .or. s% model_number > 320) return
         if (s% model_number < 100) return

         h1 = s% net_iso(ih1)

       ! find the bottom of the convective envelope (k_bce)
         k_bce = 0
         do i = 1, s% num_conv_boundaries
            if (s% top_conv_bdy(i)) cycle
            k = s% conv_bdy_loc(i)
            if (k_bce == 0) then
               k_bce = k
            else if (s% q(k) < s% q(k_bce) .and. &
               s% xa(h1,k_bce+1) > 0.1d0) then
            k_bce = k
            end if
         end do
         if (k_bce == 0) then
            if (dbg) write(*,1) 'pavel_mixing_wd: no convective zone'
               return
         end if

         if (s% mixing_type(k_bce) /= convective_mixing) then
            k_bce = k_bce-1
            if (s% mixing_type(k_bce) /= convective_mixing) then
               write(*,*) &
                  'confusion in search for H burn convection zone'
               stop 1
            end if
         end if

         bce_r = s% r(k_bce)
         bce_Hp = bce_r
         bce_D = s% x_ctrl(2)

         if (dbg) write(*,2) 'pavel_mixing_wd: k_bce', &
             k_bce, s% r(k_bce)/Rsun, s% q(k_bce), bce_Hp/Rsun, bce_D

         nz = s% nz

         do k = 2, nz ! start at 2 since no mixing across surface
            if (k <= k_bce) cycle
            ! k > k_bce
            ! interpolate values at face
            dq00 = s% dq(k)
            dqm1 = s% dq(k-1)
            dqsum = dq00 + dqm1
            kap = (dqm1*s% opacity(k) + dq00*s% opacity(k-1))/dqsum
            rho = (dqm1*s% rho(k) + dq00*s% rho(k-1))/dqsum
            cp = (dqm1*s% cp(k) + dq00*s% cp(k-1))/dqsum
            T = (dqm1*s% T(k) + dq00*s% T(k-1))/dqsum
            thermal_diffusivity = 4*crad*clight*T**3/(3*kap*rho**2*cp)
            s% D_mix(k) = bce_D*dexp(-(bce_r-s% r(k))/(s% x_ctrl(3)*bce_Hp))
            s% mixing_type(k) = overshoot_mixing
            if (s% D_mix(k) < 0.001d0*bce_D) then
               s% D_mix(k) = 0d0
               s% mixing_type(k) = no_mixing
            end if
         end do     

      end subroutine pavel_mixing_wd
                  

      end module run_star_extras
      
      
      
      
