Cls
Screen 12
Randomize Timer
Dim ciel(1190)
Dim ciel2(74732)
Dim ciel1(194871996)

'varaible
'haut = Int(Rnd * 5) + 2
'angle = Int(Rnd * 64) * 10
'zoom = (Int(Rnd * 5) + 1) * 5

laser = 4: r = 5
laser2 = 2: r2 = 5
ground = 8
cadre = 8
grille = 9

max = 30
limit = 975
haut = max
angle = 320
rdv = 1

'Espace
Line (0, 0)-(640, 480), cadre, B
For etoile = 0 To 98
    PSet (Int(Rnd * 638) + 1, Int(Rnd * 118) + 1), Int(Rnd * 3) + 7
Next etoile
deadx = Int(Rnd * 540) + 50
deady = Int(Rnd * 60) + 30
Get (1, 1)-(639, 479), ciel1()

0 'Decore
Line (1, 120)-(639, 479), ground, BF

'Grille
For i = -limit To limit Step 15 'zoom
    Line (i + angle, 120)-((i * haut) + angle, 480), grille
Next i

If engin = 0 Then
    iii = 0
Else
    iii = iii + .005 'vitesse vole
    If iii > .50 Then iii = 0 'limite
End If
ii = 2 + iii

For i = 120 To 480
    Line (0, ii + 120)-(640, ii + 120), grille
    ii = ii + ii / 3
Next i

'Ship
Line (320, 420)-(380, 480), 7
Line (320, 420)-(260, 480), 7
Paint (320, 455), 7, 7
v = 0
For l = 0 To 60
    Circle (r2 + v, 480 - l), r2, 7
    Circle (640 - r2 - v, 480 - l), r2, 7
    v = v + .89
Next l

If rdv < 1 Then rdv = 4
If rdv > 4 Then rdv = 1
If rdv = 1 Then GoSub dead
If (deadx < 25 And deadx > -25) Or (deadx > 615 And deadx < 665) Then
    For dead = 0 To 25
        'complet loop gauche
        Circle (deadx - 639, deady), dead, 0
        Circle (deadx - 639 + 1, deady), dead, 0
        'centre
        Circle (deadx, deady), dead, 0
        Circle (deadx + 1, deady), dead, 0
        'complet loop droite
        Circle (deadx + 639, deady), dead, 0
        Circle (deadx + 639 + 1, deady), dead, 0
    Next dead
    Line (1, 1)-(639, 119), 0, BF
    Put (1, 1), ciel1(), Or
End If
'Locate 1, 1: Print angle, haut, deadx, rdv

Do
    1 A$ = InKey$
    If A$ = Chr$(27) Then
        Color grille
        Locate 9, 15: Print "OPTION"
        Locate 10, 15: Print "Esc) Retour Simulateur"
        Locate 11, 15: Print "A) COULEURS ARMEMENT"
        Locate 12, 15: Print "Z) COULEURS PLANETE"
        Color ground
        Locate 14, 15: Print "TOUCHES:"
        Locate 15, 15: Print "Espace) Fly/Landing"
        Locate 16, 15: Print "Arrows) Turn Left/Right"
        Locate 17, 15: Print "Enter) Feux"
        Locate 18, 15: Print "1) Front Laser"
        Locate 19, 15: Print "2) Wings Laser"
        Do
            A$ = InKey$
            If A$ = Chr$(27) Then GoTo 0
            If A$ = "a" Then Locate 11, 36: Input "Color [0-15], [0,15] > ", laser, laser2
            If A$ = "z" Then Locate 12, 36: Input "Color [0-15], [0-15] > ", ground, grille
        Loop
    End If

    'Attaque ennemi
    If A$ = Chr$(9) Then
        GoSub Ennemi
        GoTo 0
    End If

    'Laser
    If A$ = Chr$(13) Then
        GoSub laser
        If alt = 0 Then alt = 1: GoTo 0
        If alt = 1 Then alt = 0: GoTo 0
    End If
    If A$ = "1" Then
        GoSub laser
        alt = 0: GoTo 0
    End If
    If A$ = "2" Then
        GoSub laser
        alt = 1: GoTo 0
    End If

    'Monter Descendre
    If A$ = Chr$(0) + "H" And haut > 2 Then haut = haut - 1: GoTo 0
    If A$ = Chr$(0) + "P" Then haut = haut + 1: GoTo 0

    'Diriger
    If A$ = Chr$(0) + "M" Then
        Get (1, 1)-(9, 119), ciel()
        Get (10, 1)-(639, 119), ciel2()
        Line (1, 1)-(639, 119), 0, BF
        Put (629, 1), ciel(), Or
        Put (1, 1), ciel2(), Or

        'deadx = deadx - 9
        'If deadx < -limit Then rdv = rdv - 1

        If angle > -limit Then
            deadx = deadx - 9
            angle = angle - 10: GoTo 0
        Else
            angle = limit
            deadx = limit
            rdv = rdv - 1
        End If
    End If
    If A$ = Chr$(0) + "K" Then
        Get (629, 1)-(639, 119), ciel()
        Get (1, 1)-(628, 119), ciel2()
        Line (1, 1)-(639, 119), 0, BF
        Put (1, 1), ciel(), Or
        Put (10, 1), ciel2(), Or

        'deadx = deadx + 9
        'If deadx > limit Then rdv = rdv + 1

        If angle < limit Then
            deadx = deadx + 9
            angle = angle + 10: GoTo 0
        Else
            angle = -limit
            deadx = -limit
            rdv = rdv + 1
        End If
    End If

    'Alumage des moteurs
    If A$ = " " Then
        If engin = 0 Then engin = 1: GoTo 0
        If engin = 1 Then engin = 0: GoTo 0
    End If
    If engin = 1 Then
        If haut > 7 Then haut = haut - .01
        GoTo 0
    Else
        If haut < max Then haut = haut + .01
        If haut <> max Then GoTo 0
    End If
Loop

laser:
v = 0: vr = 1
For l = 120 + r To 420 Step vr '480
    'Laser centre
    If alt = 0 Then Circle (320, 600 + r - l - 60), r, laser

    If alt = 1 Then
        'Laser gauche
        Circle (r + v + 53, 600 + r - l - 60), r2, laser2 '+55 -60 canon
        'Laser droite
        Circle (640 - r2 - v - 53, 600 + r2 - l - 60), r2, laser2
    End If

    v = v + .89 * vr
    _Limit (18000)
Next l
_Limit (60)
Return

Ennemi:
'xnm = Int(Rnd * 638) + 1
'ynm = Int(Rnd * 118) + 1
xnm = deadx + 6
ynm = deady - 12
shoot = (Int(Rnd * 2) + 1) * 7

'pluie de laser
ix = 0: jy = 0
For att = 1 To shoot
    2 inm = (Rnd * 3) - 1: jnm = (Rnd * 3) - 1
    If inm = 0 Or jnm = 0 Then GoTo 2
    Do
        ix = ix + inm: jy = jy + jnm
        Circle (xnm + ix, ynm + jy), r, 4
        _Limit (36000)
        If xnm + ix < 0 Or ynm + jy < 0 Or xnm + ix > 640 Or ynm + jy > 480 Then
            Put (1, 1), ciel1()
            ix = 0: jy = 0
            GoTo 3
        End If
    Loop
    3 Line (1, 1)-(639, 119), 0, BF
    Put (1, 1), ciel1(), Or
Next att
'Put (1, 1), ciel1(), Or
_Limit (60)
Return

dead:
'DeadStar
For dead = 0 To 25
    Circle (deadx, deady), dead, 8
    Circle (deadx + 1, deady), dead, 8
Next dead
Line (deadx - 25, deady)-(deadx + 26, deady), 0
Circle (deadx + 6, deady - 12), 10, 0
Circle (deadx + 6, deady - 12), 1, 4
PSet (deadx + 6, deady - 12), 12
Return
