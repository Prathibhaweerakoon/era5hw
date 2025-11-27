module dataanalyses
   use types
   implicit none
contains

   subroutine diff1(x, dx)
      real(kind=rkind), intent(in)  :: x(:)
      real(kind=rkind), intent(out) :: dx(size(x))
      integer(kind=ikind) :: i

      dx(1) = x(1)
      do i = 2, size(x)
         dx(i) = x(i) - x(i-1)
      end do
   end subroutine diff1

   subroutine correct_era5_daily_cum(tp_cum, e_cum, tp_inc, e_inc)
      real(kind=rkind), intent(in)  :: tp_cum(:), e_cum(:)
      real(kind=rkind), intent(out) :: tp_inc(size(tp_cum)), e_inc(size(e_cum))

      real(kind=rkind), allocatable :: tp_diff(:), e_diff(:)
      integer(kind=ikind) :: i, hrs, n

      n = size(tp_cum)
      allocate(tp_diff(n), e_diff(n))

      call diff1(tp_cum, tp_diff)
      call diff1(e_cum, e_diff)

      hrs = 0
      tp_inc = 0.0_rkind
      e_inc = 0.0_rkind

      do i = 1, n
         hrs = hrs + 1
         if (hrs > 1) then
            tp_inc(i) = tp_diff(i)
            e_inc(i) = e_diff(i)
         end if

         if (hrs == 24) hrs = 0

         if (tp_inc(i) < 0.0_rkind) tp_inc(i) = 0.0_rkind
         if (e_inc(i) > 0.0_rkind)  e_inc(i) = 0.0_rkind
      end do
   end subroutine correct_era5_daily_cum

end module dataanalyses
