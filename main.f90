program main
    use types
    use dataanalyses
    implicit none

    integer :: n, i, ios
    character(len=200) :: line
    character(len=40)  :: timestamp
    real(kind=rkind)   :: tp, ev
    real(kind=rkind), allocatable :: tp_cum(:), e_cum(:), tp_inc(:), e_inc(:)

    ! Count valid lines
    n = 0
    open(10,file="era5_input.txt",status="old")
    do
        read(10,'(A)',iostat=ios) line
        if (ios /= 0) exit
        if (len_trim(line) > 5) n = n + 1
    enddo
    close(10)

    allocate(tp_cum(n), e_cum(n), tp_inc(n), e_inc(n))

    ! Read data safely: first word = timestamp, next 2 words = numbers
    i = 0
    open(10,file="era5_input.txt",status="old")
    do
        read(10,'(A)',iostat=ios) line
        if (ios /= 0) exit

        read(line,*,err=500) timestamp, tp, ev
        i = i + 1
        tp_cum(i) = tp
        e_cum(i)  = ev
        cycle

500     continue
        ! skip bad lines without stopping program
    enddo
    close(10)

    call correct_era5_daily_cum(tp_cum, e_cum, tp_inc, e_inc)

    open(20,file="era5_corrected.txt",status="replace")
    do i=1,n
        write(20,'(F12.6,1X,F12.6)') tp_inc(i), e_inc(i)
    enddo
    close(20)

    print *, "========================================"
    print *, "      ✔ PROCESSING COMPLETED SUCCESSFULLY"
    print *, "========================================"
    print *, " First 10 hourly increments:"
    print *, "----------------------------------------"
    do i=1,min(n,10)
        print '(I4,2F14.6)', i, tp_inc(i), e_inc(i)
    enddo
    print *, "Output saved to: era5_corrected.txt"
    print *, "========================================"
end program main
