      program wd2_iniab
      implicit none
      integer, parameter :: nsp = 286, m = 11, n = 77
      integer i, j, zone
      integer z(nsp), a(nsp)
      double precision x(nsp), xmix(nsp), xsum, xdeut
      character*4 symb1
      character*2 symb(nsp)
      double precision  lnd, lnT, lnR, L, dq, v,
     &   xh1, xhe3, xhe4, xli7, xbe7, xb8, xb11, 
     &   xc12, xc13, xc14, xn13, xn14, xn15,
     &   xo14, xo15, xo16, xo17, xo18, xf17, xf18, xf19,
     &   xne18, xne19, xne20, xne21, xne22, xna20, xna21, xna22, 
     &   xna23, xmg21, xmg22, xmg23, xmg24, xmg25, xmg26,
     &   xal23, xal24, xal25, xal26, xal27, xsi24, xsi25, xsi26,
     &   xsi27, xsi28, xsi29, xsi30, xp27, xp28, xp29, xp30, xp31,
     &   xs29, xs30, xs31, xs32, xs33, xs34, xcl32, xcl33, xcl34,
     &   xcl35, xcl36, xcl37, xar33, xar34, xar35, xar36, xar37,
     &   xar38, xk36, xk37, xk38, xk39, xca39, xca40
      double precision fmix, q, mwd

!-------------------------------------------------------
! parameters, input and output files
!-------------------------------------------------------
! fraction of wd material in the accreted envelope
      fmix = 0.5d0

! input white-dwarf abundances
      open( 9, file = '../ne_wd_models/' //
     &   'ne_wd_1.3_30_mixed.mod')

! input solar abundances
      open( 8, file = '/user/scratch14_wendi3/dpa/nuppn/' //
     &   'frames/mppnp/USEEPP/iniab2.0E-02GN93.ppn')

! output mixed initial abundances
      open(14, file = 'ne_wd_iniab.ppn')
      open(15, file = 'accreted_ab.out')
      open(16, file = 'relaxed_composition')
!-------------------------------------------------------

      read( 8,100) z(1), symb1, x(1)
  100 format(1x,i2,1x,a4,10x,1pe16.10)
      a(1) = 1d0
      do i=2,nsp
      read( 8,110) z(i),symb(i),a(i),x(i)
  110 format(1x,i2,1x,a2,i3,9x,1pe16.10)
      end do

      close( 8)

      do i=1,5
      read( 9,120)
      end do

      read( 9,130) mwd
  130 format(37x,1pe23.16)
      write( *,131) mwd
  131 format(//' total mass = ',1pe23.16)

      do i=1,7
      read( 9,120)
      end do

      q = 0d0
   10 continue
c     read( 9,120) zone, lnd, lnT, lnR, L, dq, v,
      read( 9,120) zone, lnd, lnT, lnR, L, dq,
     &   xh1, xhe3, xhe4, xli7, xbe7, xb8, xb11,
     &   xc12, xc13, xc14, xn13, xn14, xn15,
     &   xo14, xo15, xo16, xo17, xo18, xf17, xf18, xf19,
     &   xne18, xne19, xne20, xne21, xne22, xna20, xna21, xna22,
     &   xna23, xmg21, xmg22, xmg23, xmg24, xmg25, xmg26,
     &   xal23, xal24, xal25, xal26, xal27, xsi24, xsi25, xsi26,
     &   xsi27, xsi28, xsi29, xsi30, xp27, xp28, xp29, xp30, xp31,
     &   xs29, xs30, xs31, xs32, xs33, xs34, xcl32, xcl33, xcl34,
     &   xcl35, xcl36, xcl37, xar33, xar34, xar35, xar36, xar37,
     &   xar38, xk36, xk37, xk38, xk39, xca39, xca40
c 120 format(i5,39(4x,1pe23.16))
  120 format(i5,82(4x,1pe23.16))
      q = q + dq
      if(xhe4 > 0d0) go to 10
      mwd = mwd - q + dq

      write( *,132) mwd
  132 format(//' WD core mass = ',1pe23.16)

      xsum = xh1 + xhe3 + xhe4 + xli7 + xbe7 + xb8 + xb11 +
     &   xc12 + xc13 + xc14 + xn13 + xn14 + xn15 + 
     &   xo14 + xo15 + xo16 + xo17 + xo18 + xf17 + xf18 + xf19 + 
     &   xne18 + xne19 + xne20 + xne21 + xne22 + xna20 + xna21 + xna22 +
     &   xna23 + xmg21 + xmg22 + xmg23 + xmg24 + xmg25 + xmg26 +
     &   xal23 + xal24 + xal25 + xal26 + xal27 + xsi24 + xsi25 + xsi26 +
     & xsi27 + xsi28 + xsi29 + xsi30 + xp27 + xp28 + xp29 + xp30 + xp31+
     & xs29 + xs30 + xs31 + xs32 + xs33 + xs34 + xcl32 + xcl33 + xcl34 +
     &   xcl35 + xcl36 + xcl37 + xar33 + xar34 + xar35 + xar36 + xar37 +
     &   xar38 + xk36 + xk37 + xk38 + xk39 + xca39 + xca40
      write( *,210) xsum

      close( 9)

      xmix(1) = (1d0-fmix)*x(1) + fmix*xh1
      do i=2,nsp
      xmix(i) = (1d0-fmix)*x(i)
      if (symb(i) == 'he' .and. a(i) == 3d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xhe3
      if (symb(i) == 'he' .and. a(i) == 4d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xhe4
      if (symb(i) == 'li' .and. a(i) == 7d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xli7
      if (symb(i) == 'be' .and. a(i) == 7d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xbe7
      if (symb(i) == 'b' .and. a(i) == 8d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xb8
      if (symb(i) == 'b' .and. a(i) == 11d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xb11
      if (symb(i) == 'c ' .and. a(i) == 12d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xc12
      if (symb(i) == 'c ' .and. a(i) == 13d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xc13
      if (symb(i) == 'c ' .and. a(i) == 14d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xc14
      if (symb(i) == 'n ' .and. a(i) == 13d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xn13
      if (symb(i) == 'n ' .and. a(i) == 14d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xn14
      if (symb(i) == 'n ' .and. a(i) == 15d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xn15
      if (symb(i) == 'o ' .and. a(i) == 14d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xo14
      if (symb(i) == 'o ' .and. a(i) == 15d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xo15
      if (symb(i) == 'o ' .and. a(i) == 16d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xo16
      if (symb(i) == 'o ' .and. a(i) == 17d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xo17
      if (symb(i) == 'o ' .and. a(i) == 18d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xo18
      if (symb(i) == 'f ' .and. a(i) == 17d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xf17
      if (symb(i) == 'f ' .and. a(i) == 18d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xf18
      if (symb(i) == 'f ' .and. a(i) == 19d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xf19
      if (symb(i) == 'ne' .and. a(i) == 18d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xne18
      if (symb(i) == 'ne' .and. a(i) == 19d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xne19
      if (symb(i) == 'ne' .and. a(i) == 20d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xne20
      if (symb(i) == 'ne' .and. a(i) == 21d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xne21
      if (symb(i) == 'ne' .and. a(i) == 22d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xne22
      if (symb(i) == 'na' .and. a(i) == 20d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xna20
      if (symb(i) == 'na' .and. a(i) == 21d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xna21
      if (symb(i) == 'na' .and. a(i) == 22d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xna22
      if (symb(i) == 'na' .and. a(i) == 23d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xna23
      if (symb(i) == 'mg' .and. a(i) == 21d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xmg21
      if (symb(i) == 'mg' .and. a(i) == 22d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xmg22
      if (symb(i) == 'mg' .and. a(i) == 23d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xmg23
      if (symb(i) == 'mg' .and. a(i) == 24d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xmg24
      if (symb(i) == 'mg' .and. a(i) == 25d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xmg25
      if (symb(i) == 'mg' .and. a(i) == 26d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xmg26
      if (symb(i) == 'al' .and. a(i) == 23d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xal23
      if (symb(i) == 'al' .and. a(i) == 24d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xal24
      if (symb(i) == 'al' .and. a(i) == 25d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xal25
      if (symb(i) == 'al' .and. a(i) == 26d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xal26
      if (symb(i) == 'al' .and. a(i) == 27d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xal27
      if (symb(i) == 'si' .and. a(i) == 24d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi24
      if (symb(i) == 'si' .and. a(i) == 25d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi25
      if (symb(i) == 'si' .and. a(i) == 26d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi26
      if (symb(i) == 'si' .and. a(i) == 27d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi27
      if (symb(i) == 'si' .and. a(i) == 28d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi28
      if (symb(i) == 'si' .and. a(i) == 29d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi29
      if (symb(i) == 'si' .and. a(i) == 30d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xsi30
      if (symb(i) == 'p' .and. a(i) == 27d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xp27
      if (symb(i) == 'p' .and. a(i) == 28d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xp28
      if (symb(i) == 'p' .and. a(i) == 29d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xp29
      if (symb(i) == 'p' .and. a(i) == 30d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xp30
      if (symb(i) == 'p' .and. a(i) == 31d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xp31
      if (symb(i) == 's' .and. a(i) == 29d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xs29
      if (symb(i) == 's' .and. a(i) == 30d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xs30
      if (symb(i) == 's' .and. a(i) == 31d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xs31
      if (symb(i) == 's' .and. a(i) == 32d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xs32
      if (symb(i) == 's' .and. a(i) == 33d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xs33
      if (symb(i) == 's' .and. a(i) == 34d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xs34
      if (symb(i) == 'cl' .and. a(i) == 32d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xcl32
      if (symb(i) == 'cl' .and. a(i) == 33d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xcl33
      if (symb(i) == 'cl' .and. a(i) == 34d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xcl34
      if (symb(i) == 'cl' .and. a(i) == 35d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xcl35
      if (symb(i) == 'cl' .and. a(i) == 36d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xcl36
      if (symb(i) == 'cl' .and. a(i) == 37d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xcl37
      if (symb(i) == 'ar' .and. a(i) == 33d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xar33
      if (symb(i) == 'ar' .and. a(i) == 34d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xar34
      if (symb(i) == 'ar' .and. a(i) == 35d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xar35
      if (symb(i) == 'ar' .and. a(i) == 36d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xar36
      if (symb(i) == 'ar' .and. a(i) == 37d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xar37
      if (symb(i) == 'ar' .and. a(i) == 38d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xar38
      if (symb(i) == 'k' .and. a(i) == 36d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xk36
      if (symb(i) == 'k' .and. a(i) == 37d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xk37
      if (symb(i) == 'k' .and. a(i) == 38d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xk38
      if (symb(i) == 'k' .and. a(i) == 39d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xk39
      if (symb(i) == 'ca' .and. a(i) == 39d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xca39
      if (symb(i) == 'ca' .and. a(i) == 40d0)
     &   xmix(i) = (1d0-fmix)*x(i) + fmix*xca40
      end do

      xsum = x(1)
!     write(14,100) z(1), symb1, x(1)
      do i=2,nsp
      xsum = xsum + x(i)
!     write(14,110) z(i),symb(i),a(i),x(i)
      end do
      write( *,200) xsum

      xsum = xmix(1)
      write(14,100) z(1), symb1, xmix(1)
      do i=2,nsp
      xsum = xsum + xmix(i)
      write(14,110) z(i),symb(i),a(i),xmix(i)
      end do
      write( *,220) xsum

      close(14)

  200 format(//' xsum (NuGrid) = ',1pe16.10)
  210 format(//' xsum (MESA) = ',1pe16.10)
  220 format(//' xsum (mix) = ',1pe16.10)

      write(15,230) nsp, xmix(1)
  230 format('      accrete_same_as_surface = .false.' /
     &       '      accrete_given_mass_fractions = .true.' /
     &       '      num_accretion_species = ',i3 /
     &       '      accretion_species_id(1) = ''h1''' /
     &       '      accretion_species_xa(1) = ',e16.10)
      do i=2,nsp
      if (symb(i) == 'h ' .and. a(i) == 2d0) then
         xdeut = xmix(i)
         xmix(i) = 0d0
      end if
      if (symb(i) == 'he' .and. a(i) == 3d0)
     &   xmix(i) = xmix(i) + xdeut
      write(15,240) i,symb(i),int(a(i)),i,xmix(i)
  240 format('      accretion_species_id(',i3,') = ''',a2,i3,'''' /
     &       '      accretion_species_xa(',i3,') = ',e16.10)
      end do

      close(15)

      j = 1
      xmix(1) = x(1)

      do i=2,nsp
      if (symb(i) == 'he' .and. a(i) == 3d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'he' .and. a(i) == 4d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'li' .and. a(i) == 7d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'be' .and. a(i) == 7d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'b' .and. a(i) == 8d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'b' .and. a(i) == 11d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'c' .and. a(i) == 12d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'c' .and. a(i) == 13d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'c' .and. a(i) == 14d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'n' .and. a(i) == 13d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'n' .and. a(i) == 14d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'n' .and. a(i) == 15d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'o' .and. a(i) == 14d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'o' .and. a(i) == 15d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'o' .and. a(i) == 16d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'o' .and. a(i) == 17d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'o' .and. a(i) == 18d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'f' .and. a(i) == 17d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'f' .and. a(i) == 18d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'f' .and. a(i) == 19d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ne' .and. a(i) == 18d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ne' .and. a(i) == 19d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ne' .and. a(i) == 20d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ne' .and. a(i) == 21d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ne' .and. a(i) == 22d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'na' .and. a(i) == 20d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'na' .and. a(i) == 21d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'na' .and. a(i) == 22d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'na' .and. a(i) == 23d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'mg' .and. a(i) == 21d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'mg' .and. a(i) == 22d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'mg' .and. a(i) == 23d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'mg' .and. a(i) == 24d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'mg' .and. a(i) == 25d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'mg' .and. a(i) == 26d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'al' .and. a(i) == 23d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'al' .and. a(i) == 24d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'al' .and. a(i) == 25d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'al' .and. a(i) == 26d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'al' .and. a(i) == 27d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 24d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 25d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 26d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 27d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 28d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 29d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'si' .and. a(i) == 30d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'p' .and. a(i) == 27d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'p' .and. a(i) == 28d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'p' .and. a(i) == 29d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'p' .and. a(i) == 30d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'p' .and. a(i) == 31d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 's' .and. a(i) == 29d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 's' .and. a(i) == 30d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 's' .and. a(i) == 31d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 's' .and. a(i) == 32d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 's' .and. a(i) == 33d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 's' .and. a(i) == 34d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'cl' .and. a(i) == 32d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'cl' .and. a(i) == 33d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'cl' .and. a(i) == 34d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'cl' .and. a(i) == 35d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'cl' .and. a(i) == 36d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'cl' .and. a(i) == 37d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ar' .and. a(i) == 33d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ar' .and. a(i) == 34d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ar' .and. a(i) == 35d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ar' .and. a(i) == 36d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ar' .and. a(i) == 37d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ar' .and. a(i) == 38d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'k' .and. a(i) == 36d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'k' .and. a(i) == 37d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'k' .and. a(i) == 38d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'k' .and. a(i) == 39d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ca' .and. a(i) == 39d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      if (symb(i) == 'ca' .and. a(i) == 40d0) then
         j = j+1
         xmix(j) = x(i)
      end if
      end do
      
      write(16,260) m,n
  260 format(i2,1x,i2)

      xh1 = 0d0
      xhe3 = 0d0
      xhe4 = 0d0
      xli7 = 0d0
      xbe7 = 0d0
      xb8 = 0d0
      xb11 = 0d0
      xc12 = 0.5d0
      xc13 = 0d0
      xc14 = 0d0
      xn13 = 0d0
      xn14 = 0d0
      xn15 = 0d0
      xo14 = 0d0
      xo15 = 0d0
      xo16 = 0.5d0
      xo17 = 0d0
      xo18 = 0d0
      xf17 = 0d0
      xf18 = 0d0
      xf19 = 0d0
      xne18 = 0d0
      xne19 = 0d0
      xne20 = 0d0
      xne21 = 0d0
      xne22 = 0d0
      xna20 = 0d0
      xna21 = 0d0
      xna22 = 0d0
      xna23 = 0d0
      xmg21 = 0d0
      xmg22 = 0d0
      xmg23 = 0d0
      xmg24 = 0d0
      xmg25 = 0d0
      xmg26 = 0d0
      xal23 = 0d0
      xal24 = 0d0
      xal25 = 0d0
      xal26 = 0d0
      xal27 = 0d0
      xsi24 = 0d0
      xsi25 = 0d0
      xsi26 = 0d0
      xsi27 = 0d0
      xsi28 = 0d0
      xsi29 = 0d0
      xsi30 = 0d0
      xp27 = 0d0
      xp28 = 0d0
      xp29 = 0d0
      xp30 = 0d0
      xp31 = 0d0
      xs29 = 0d0
      xs30 = 0d0
      xs31 = 0d0
      xs32 = 0d0
      xs33 = 0d0
      xs34 = 0d0
      xcl32 = 0d0
      xcl33 = 0d0
      xcl34 = 0d0
      xcl35 = 0d0
      xcl36 = 0d0
      xcl37 = 0d0
      xar33 = 0d0
      xar34 = 0d0
      xar35 = 0d0
      xar36 = 0d0
      xar37 = 0d0
      xar38 = 0d0
      xk36 = 0d0
      xk37 = 0d0
      xk38 = 0d0
      xk39 = 0d0
      xca39 = 0d0
      xca40 = 0d0

      do i=1,m
      q = (i-1)*0.1d0
      if (i.eq.1) write(16,121) q,(xmix(j),j=1,n)
      write(16,121) q, xh1, xhe3, xhe4, xli7, xbe7, xb8, xb11,
     &   xc12, xc13, xc14, xn13, xn14, xn15,
     &   xo14, xo15, xo16, xo17, xo18, xf17, xf18, xf19,
     &   xne18, xne19, xne20, xne21, xne22, xna20, xna21, xna22,
     &   xna23, xmg21, xmg22, xmg23, xmg24, xmg25, xmg26,
     &   xal23, xal24, xal25, xal26, xal27, xsi24, xsi25, xsi26,
     &   xsi27, xsi28, xsi29, xsi30, xp27, xp28, xp29, xp30, xp31,
     &   xs29, xs30, xs31, xs32, xs33, xs34, xcl32, xcl33, xcl34,
     &   xcl35, xcl36, xcl37, xar33, xar34, xar35, xar36, xar37,
     &   xar38, xk36, xk37, xk38, xk39, xca39, xca40
! 121 format(f3.1,33(2x,1pe23.16))
  121 format(f3.1,77(2x,1pd9.3))
      end do

      close(16)

      write( *,250)
  250 format(//' The program has created the following files:' //
     &   ' ne_wd_iniab.ppn'/' accreted_ab.out'/
     &   ' relaxed_composition'//)

      end program wd2_iniab
      
