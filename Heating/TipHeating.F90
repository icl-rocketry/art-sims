program TipHeating
    !-----------------------------------------------
    !Estimates maximum heating at the tip of a rocket nosecone
    !Using ICLR wiki article posted by Devansh Agarwal (2020), consolidating paper by Tauber (1987)
    !Based on MATLAB script by Ishaan Aldina (2021)
    !Nathanael Jenkins (2021)
    !-----------------------------------------------


    implicit none
    !USER DEFINED VARIABLES
    !Ma => instantaneous mach number; V => instantaneous velocity; rn => body nose radius; rho => atmospheric density; e => emissivity
    double precision :: Ma=0, V=379.66, rn=0.5, rho=1.1655, e=0.92
    !delta => leading edge sweep; X => nose tip-fins length; phi => local body angle (small impact)
    double precision :: delta=30.252, X=0.777, phi1=0, phi2 = 89.99
    !OTHER VARIABLES
    !Tw=> final temperature; T_0=> max' stagnation temperature
    !N, Z => useufl constants (see below); C1, C2 => variable constants; i => iteration counter
    double precision :: Tw, T_0, N, Z, C1=0.00000000000001, C2, tol=1.0, Tw1, Tw2
    !qo => heat transfer max; qfp => flat plate heat transfer; qle => leading edge heat transfer; Tle => leading edge heat
    double precision :: qo, qfp, qle, Tle1, Tle2
    !Date and time variables for diaplay
    character(24) :: date
    integer :: i=0


    !USER VARIABLE DEFINITION
    print '(/, a46)', 'If using pre-programmed conditions, enter Ma=0'
    print '(a21)', 'Maximum mach number: '
    read (*,*)  Ma
    if (Ma /= 0) then
        print *, ''
        print *, 'Maximum velocity (m/s): '
        read (*,*) V
        print *, ''
        print *, 'Nose radius (mm): '
        read (*,*) rn
        print *, ''
        print *, 'Air density (kg/m^3): '
        read (*,*) rho
        print *, ''
        print *, 'Fin leading edge sweep (º): '
        read (*,*) delta
        print *, ''
        print *, 'Fin position (m from nose tip): '
        read (*,*) X
        print *, ''
    else
        Ma = 1.1232
    end if
    !Calculates maximum stagnation temperature
    T_0=((1+(0.2*(Ma**2)))*288.15)



    !Calculate useful constants N and Z
    !These will be used in every iteration, but only need calculating once, reducing computation time
    N = (((rn/1000)**(-0.5))*((1.83)*10.0**(-8)))
    Z = (((rho**0.5)*(V**3))/((e)*((5.67)*10.0**(-12))))
    ! Initialises variables
    Tw1=T_0+25
    tol = 1.0
    N = N*Z
    Z = N/T_0
    !Iterate until change in temperature for each iteration is less than 10^-12
    do while (tol > 10.0**(-12))

        !Computes a new value for Tw
        Tw2 = T_0*(1-(Tw1**4)/(N*Z))          ! FPM
        ! Tw2 = sqrt(sqrt((N*Z*(1-Tw1/T_0))))   ! FPM
        !Tw2 = Tw1 - (Tw1**4+Z*Tw1-N)/(4*Tw1**3 + Z)

        !Computes a new value for Tw (fixed point method)
        Tw2 = (N*Z - Tw1**4)/(N*Z/T_0)

        !Calculates Tolerance based on change in estimated temperature over each iteration
        tol = abs(Tw2-Tw1)
        !Re-assigns calculated value of Tw to 'old' value
        Tw1=Tw2
        !Increase iteration count by 1
        i = i+1
    end do
    Tw = Tw1
    C1 = (Tw**4)/Z



    ! NEED UPDATING -- ITERATIVE APPROACH FOR FIN TEMPERATURES
    !Calculate min estimated leading edge heating
    qo = C1*(rho**0.5)*(V**3)
    !Calculates constant C (explicitly)
    C1 = 2.53*(10.0**(-9))*((cosd(phi1))**(0.5))*(sind(phi1))*(X**(-0.5))*(1-(Tw/T_0))
    !Calculates corresponding heat transfer for a flat plate
    qfp = C1*(rho**(0.5))*(V**(3.2))
    !Calculates heat transfer T_0 leading edge
    qle = sqrt((0.5*(qo**2)*((cosd(delta))**2))+((qfp**2)*((sind(delta))**2)))
    !Calculates temperature based on heat transfers
    Tle1 = (qle/(e*((5.67)*(10.0**(-12)))))**0.25
    !Calculate max estimated leading edge heating (repeats above process)
    C1 = 2.53*(10.0**(-9))*((cosd(phi2))**(0.5))*(sind(phi2))*(X**(-0.5))*(1-(Tw/T_0))
    qfp = C1*(rho**(0.5))*(V**(3.2))
    qle = sqrt((0.5*(qo**2)*((cosd(delta))**2))+((qfp**2)*((sind(delta))**2)))
    Tle2 = (qle/(e*((5.67)*(10.0**(-12)))))**0.25



    call fdate(date)
    print *, '          --ROCKET HEATING CALCULAT0R--              '
    print '(a51)', '----------------------------------------------------------------'
    print '(a3, f3.1, a6, f5.1, a6, f4.1, a8, f5.3, a6, f5.2)', 'M: ', Ma, ' | V: ', V, ' | R: ', rn, ' | rho: ', rho, ' | e: ', e
    print '(a51)', '----------------------------------------------------------------'
    print '(a32, i3)', '                   Iterations: ', i
    print '(a33, e11.5, a2)', '                     tolerance:  ±', tol, ' k'
    !rint '(a32, f7.3, a2)', 'Maximum stagnation temperature: ', T_0, ' k'
    print '(a32, f7.3, a4)', 'Maximum stagnation temperature: ', (T_0-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '             Nose  Temperature: ', Tw, ' k'
    print '(a32, f7.3, a4)', '             Nose Temperature: ', (Tw-273.15), ' ºc'
!    !print '(a32, f7.3, a2)', '          Min Fin  Temperature: ', Tle1, ' k'
    print '(a32, f7.3, a4)', '          Min Fin Temperature: ', (Tle1-273.15), ' ºc'
!    !print '(a32, f7.3, a2)', '          Max Fin  Temperature: ', Tle2, ' k'
    print '(a32, f7.3, a4)', '          Max Fin Temperature: ', (Tle2-273.15), ' ºc'

end program Tipheating
