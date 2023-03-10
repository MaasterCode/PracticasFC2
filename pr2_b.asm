/*---------------------------------------------------------------------
**
**  Fichero:
**    pr2_b.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 2b
**
**  Notas de diseño:
**
**	# define N 8
**	# define INT_MAX 65536
**	int V [ N ] = { -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3};
**	int W [ N ];
**	int min , index ;
**	for ( j = 0; j < N ; j ++) {
**		min = INT_MAX ;
**		for ( i = 0; i < N ; i ++) {
**			if ( V [ i ] < min ) {
**				min = V [ i ];
**				index = i ;
**			}
**		}
**		W [ j ] = V [ index ];
**		V [ index ] = INT_MAX ;
**	}
**
**-------------------------------------------------------------------*/
.global main
.equ N , 8
.equ INT_MAX , 65536

.data
V: 	 .word -7 ,3 , -9 ,8 ,15 , -16 ,0 ,3
.bss
W: 	 .space N *4
min: .space 4
ind: .space 4

.text
main :
    li s1, N			// Carga la constante N en s1
    la s2, V			// Carga la direccion base del vector V
    li s3, INT_MAX		// Carga en t0 (min) el valor de INT_MAX ***
    la s4, W			// Carga la direccion base del vector W **

	mv t5, zero					// j = 0
	forj:
		bge t5, s1, eforj 		// j < N
	    mv t1, zero				// i = 0
	    mv t4, s3				// min = INT_MAX ***
		fori:
			bge t1, s1, efori // i < N
			slli t2, t1, 2			// i * 4
			add t2, s2, t2		// Direccion v[i]
			lw t3, 0(t2)		// Carga valor v[i]
			ifmin:
				bge t3, t4, endifmin	// Salta si v[i] >= min
				mv t4, t3		// min = v[i]
				mv s6, t1		// index = i
			endifmin:
			addi t1, t1, 1		// i++
			j fori
		efori:
		//  Aqui puedo reutilizar los registros usados dentro del bucle interior
		slli t2, t5, 2		// j * 4
		add t2, s4, t2		// direccion de W[j]

		slli t3, s6, 2		// index * 4
		add t3, s2, t3		// direccion de V[index]
		lw t0, 0(t3)		// Carga el valor de V[index]

		sw t0, 0(t2) 		// W[j] = V[index]

		sw s3, 0(t3)		// V[index] = INT_MAX
		addi t5, t5, 1 		// j++
		j forj
	eforj:
	fin:
		j .


