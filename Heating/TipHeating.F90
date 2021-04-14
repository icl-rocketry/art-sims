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
    double precision :: Ma=0, V=379.66, rn=46.0, rho=1.1655, e=0.92
    !delta => leading edge sweep; X => nose tip-fins length; phi => local body angle (small impact)
    double precision :: delta=30.252, X=0.777, phi1=0, phi2 = 89.99
    !OTHER VARIABLES
    !Tw=> final temperature; to=> max' stagnation temperature
    !N, Z => useufl constants (see below); C1, C2 => variable constants; i => iteration counter
    double precision :: Tw, to, N, Z, C1=0.00000000000001, C2, tol=1.0, Tw1, Tw2
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
        print *, 'Body radius (mm): '
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
    to=((1+(0.2*(Ma**2)))*288.15)
    


    ! ------------ NOSE CALCULATIONS || C-BASED --------------
    !Calculate useful constants N and Z
    !These will be used in every iteration, but only need calculating once, reducing computation time
    N = (((rn/1000)**(-0.5))*((1.83)*10.0**(-8)))
    Z = (((rho**0.5)*(V**3))/((e)*((5.67)*10.0**(-12))))

    !Iterate until change in temperature for each iteration is less than 10^-12
    do while (tol > 10.0**(-12))
        !Computes a new value for constant C
        C2 = (((1-C1/N)*to)**4)/Z
        !Calculates tolerance based on change in estimated temperature over each iteration
        tol = abs(C2-C1)
        !Re-assigns calculated value of C to 'old' value
        C1 = C2
        !Increase iteration count by 1
        i = i+1
    end do
    !Calculate final temperature
    Tw = ((Z*C1)**0.25)


    ! ------------ FIN CALCULATIONS || C-BASED --------------
    !Calculate min estimated leading edge heating
    qo = C1*(rho**0.5)*(V**3)
    !Calculates constant C (explicitly)
    C1 = 2.53*(10.0**(-9))*((cosd(phi1))**(0.5))*(sind(phi1))*(X**(-0.5))*(1-(Tw/to))
    !Calculates corresponding heat transfer for a flat plate
    qfp = C1*(rho**(0.5))*(V**(3.2))
    !Calculates heat transfer to leading edge
    qle = sqrt((0.5*(qo**2)*((cosd(delta))**2))+((qfp**2)*((sind(delta))**2)))
    !Calculates temperature based on heat transfers
    Tle1 = (qle/(e*((5.67)*(10.0**(-12)))))**0.25
    !Calculate max estimated leading edge heating (repeats above process)
    C1 = 2.53*(10.0**(-9))*((cosd(phi2))**(0.5))*(sind(phi2))*(X**(-0.5))*(1-(Tw/to))
    qfp = C1*(rho**(0.5))*(V**(3.2))
    qle = sqrt((0.5*(qo**2)*((cosd(delta))**2))+((qfp**2)*((sind(delta))**2)))
    Tle2 = (qle/(e*((5.67)*(10.0**(-12)))))**0.25


    ! ------------ DATA OUTPUT --------------
    call fdate(date)
    print '(/, a54)', '           --ROCKET HEATING CALCULATOR--               '
    print '(a51)', '----------------------------------------------------------------'
    print '(a3, f3.1, a6, f5.1, a6, f4.1, a8, f5.3, a6, f5.2)', 'M: ', Ma, ' | V: ', V, ' | R: ', rn, ' | rho: ', rho, ' | e: ', e
    print '(a51)', '----------------------------------------------------------------'
    print '(a32, i3)', '                   Iterations: ', i
    print '(a33, e11.5, a2)', '                     Tolerance:  ±', tol, ' k'
    !rint '(a32, f7.3, a2)', 'Maximum stagnation temperature: ', to, ' k'
    print '(a32, f7.3, a4)', 'Maximum stagnation temperature: ', (to-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '             Nose  Temperature: ', Tw, ' k'
    print '(a32, f7.3, a4)', '             Nose Temperature: ', (Tw-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '          Min Fin  Temperature: ', Tle1, ' k'
    print '(a32, f7.3, a4)', '          Min Fin Temperature: ', (Tle1-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '          Max Fin  Temperature: ', Tle2, ' k'
    print '(a32, f7.3, a4)', '          Max Fin Temperature: ', (Tle2-273.15), ' ºc'
    print '(a51, /)', '----------------------------------------------------------------'

    tol = 1.0
    Tw1=to
    !Iterate until change in temperature for each iteration is less than 10^-12
    do while (tol > 10.0**(-12))
        !Computes a new value for constant C
        Tw2 = to*(1-(Tw1**4)/(N*Z))
        !Calculates tolerance based on change in estimated temperature over each iteration
        tol = abs(Tw2-Tw1)
        !Re-assigns calculated value of C to 'old' value
        Tw1=Tw2
        !Increase iteration count by 1
        i = i+1
    end do
    print *, Tw1
    print *, (Tw1-273.15)


    ! ------------ NOSE CALCULATIONS || DIRECT --------------
    !Calculate useful constants N and Z
    !These will be used in every iteration, but only need calculating once, reducing computation time
    N = (((rn/1000)**(-0.5))*((1.83)*10.0**(-8)))
    Z = (((rho**0.5)*(V**3))/((e)*((5.67)*10.0**(-12))))
    ! Initialises variables
    Tw1=to
    tol = 1.0
    !Iterate until change in temperature for each iteration is less than 10^-12
    do while (tol > 10.0**(-12))
        !Computes a new value for constant C
        Tw2 = to*(1-(Tw1**4)/(N*Z))
        !Calculates tolerance based on change in estimated temperature over each iteration
        tol = abs(Tw2-Tw1)
        !Re-assigns calculated value of C to 'old' value
        Tw1=Tw2
        !Increase iteration count by 1
        i = i+1
    end do
    Tw = Tw1


    ! ------------ FIN CALCULATIONS || DIRECT? --------------
    ! UNDER REVIEW


    ! ------------ DATA OUTPUT --------------
    call fdate(date)
    print '(/, a54)', '  --ROCKET HEATING CALCULATOR || DIRECT METHOD--      '
    print '(a51)', '----------------------------------------------------------------'
    print '(a3, f3.1, a6, f5.1, a6, f4.1, a8, f5.3, a6, f5.2)', 'M: ', Ma, ' | V: ', V, ' | R: ', rn, ' | rho: ', rho, ' | e: ', e
    print '(a51)', '----------------------------------------------------------------'
    print '(a32, i3)', '                   Iterations: ', i
    print '(a33, e11.5, a2)', '                     Tolerance:  ±', tol, ' k'
    !rint '(a32, f7.3, a2)', 'Maximum stagnation temperature: ', to, ' k'
    print '(a32, f7.3, a4)', 'Maximum stagnation temperature: ', (to-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '             Nose  Temperature: ', Tw, ' k'
    print '(a32, f7.3, a4)', '             Nose Temperature: ', (Tw-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '          Min Fin  Temperature: ', Tle1, ' k'
    print '(a32, f7.3, a4)', '          Min Fin Temperature: ', (Tle1-273.15), ' ºc'
    !print '(a32, f7.3, a2)', '          Max Fin  Temperature: ', Tle2, ' k'
    print '(a32, f7.3, a4)', '          Max Fin Temperature: ', (Tle2-273.15), ' ºc'

end program Tipheating
