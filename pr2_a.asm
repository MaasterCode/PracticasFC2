/*---------------------------------------------------------------------
**
**  Fichero:
**    pr2_a.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 2a
**
**  Notas de diseño:
**
** 	# define N 8
** 	# define INT_MAX 65536
**	int V [ N ] = { -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3};
**	int min = INT_MAX ;
**	for ( i = 0; i < N ; i ++) {
**		if ( V [ i ] < min )
**			min = V [ i ];
**	}
**
**-------------------------------------------------------------------*/

.global main
.equ N, 8
.equ INT_MAX, 65536
.data
V:   .word -7,3,-9,8,15,-16,0,3

.bss
min: .space 4

.text
main:
    la s1, min			// Carga en s0 la direccion de min
    li t0, INT_MAX		// Carga en t0 el valor de INT_MAX
    sw t0, 0(s1)		// Guarda en la direccion de memoria de min(s1) el valor de INT_MAX(t0)
    li t1, N			// Carga de la constante N en t1
    la t2, V			// Carga de la direccion base del vector V

    mv t3, zero			// i = 0
	fori:
		bge t3, t1, efori // i < N
		slli t4, t3, 2	// i * 4
		add t5, t4, t2	// Direccion v[i]
		lw t6, 0(t5)		// Carga valor v[i]
		ifmin:
			bge t6, t0, endifmin	// Salta si v[i] >= min
			mv t0, t6	// min = v[i]
		endifmin:
		addi t3, t3, 1	// i++
		j fori
	efori:
	sw t0, 0(s1)		// Guarda en memoria el ultimo valor de min
	fin:
		j .





