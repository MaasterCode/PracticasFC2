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
**	int mul(int a, int b) {
**	    int res = 0;
**	    while (b > 0) {
**	        res += a;
**	        b--;
**	    }
**	    return res;
**	}
**
**	int dotprod(int[] V, int[] W, int n) {
**	    int acc = 0;
**	    for (int i = 0; i < n; i++) {
**	        acc += mul(V[i], W[i]);
**	    }
**	    return acc;
**	}
**
**	#define N 4
**	int[] A = {3, 5, 1, 9}
**	int[] B = {1, 6, 2, 3}
**
**	int res;
**
**	void main() {
**	    int normA = dotprod(A, A, N);
**	    int normB = dotprod(B, B, N);
**	    if (normA > normB)
**	        res = 0xa;
**	    else
**	        res = 0xb;
**	}
**
**-------------------------------------------------------------------*/
.extern _stack
.global main
.data
	A: .word 3, 5, 1, 9
	B: .word 1, 6, 2, 3
.equ N, 4
.bss
	res: .space 4

.text
main:
	la sp, _stack	// Inicializa la pila

	la s1, A	// Cargo la direccion base de A
	la s2, B	// Cargo la direccion base de B
	li s3, N	// Cargo el valor de N

	mv a0, s1	// Paso como primer parametro la direccion base de A
	mv a1, s1	// Paso como segundo parametro la direccion base de A
	mv a2, s3	// Paso como tercer parametro el valor de N
	call dotprod	// Llamo a la funcion dotprod

	mv s4, a0	// Guardo el valor de retorno

	mv a0, s2				// Paso como primer parametro la direccion base de B
	mv a1, s2				// Paso como segundo parametro la direccion base de B
	mv a2, s3				// Paso como tercer parametro el valor de N
	call dotprod			// Llamo a la funcion dotprod

	mv s5, a0				// Guardo el valor de retorno
	la t1, res				// Guardo la direccion de res
	if:
		ble	s4, s5, else	// if (normA > normB) (s4 > s5)
		li t0, 0xa			// Guardo en un registro temporal 0xa para guardarlo en res
		sw t0, 0(t1)		// Guarda res
		j fif
	else:
		li t0, 0xb			// Guardo en un registro temporal 0xb para guardarlo en res
		sw t0, 0(t1)		// Guarda res
	fif:
fin:
	j .

dotprod:
	// CARGA EN PILA PARA DOTPROD
	// Guardo los registros que se usarán en la función
	// También ra porque dentro de la función se llama a otra
	addi sp, sp, -20		// Reservo espacio en la pila para los 4 registros salvados y ra
	sw s1, 0(sp)			// Guardo en pila s1
	sw s2, 4(sp)			// Guardo en pila s2
	sw s3, 8(sp)			// Guardo en pila s3
	sw s4, 12(sp)			// Guardo en pila s4
	sw ra, 16(sp)			// Guardo en pila la direccion de retorno

	// REGISTROS PARA LA FUNCION
	mv s1, a0				// Guardo la direccion de V
	mv s2, a1				// Guardo la direccion de W
	mv s3, a2				// Guardo n
	mv s4, zero 			// acc = 0
	mv s5, zero 			// i = 0

	fordot:
		bge s5, s3, efordot // i < n

		// CALCULO DE LOS ELEMENTOS DE LOS VECTORES
		slli t0, s5, 2		// i * 4
		add t2, s1, t0		// Calculo la direccion de v[i]
		lw a0, 0(t2)		// Guardo en el primer parametro el valor de V[i]
		add t3, s2, t0		// Calculo la direccon de W[i]
		lw a1, 0(t3)		// Guardo en el segundo parametro el valor de W[i]

		call mul			// Llamo a la funcion mul

		add s4, s4, a0		// acc += mul(V[i], W[i])
		addi s5, s5, 1		// i++
		j fordot
	efordot:
	mv a0, s4				// Muevo al registro de retorno el valor de acc

	// RECUPERACION DE LA PILA DESPUES DE DOTPROD
	lw s1, 0(sp)			// Recupero de la pila s1
	lw s2, 4(sp)			// Recupero de la pila s2
	lw s3, 8(sp)			// Recupero de la pila s3
	lw s4, 12(sp)			// Recupero de la pila s4
	lw ra, 16(sp)			// Recupero de la pila pila la direccion de retorno
	addi sp, sp, 20			// Restauro el puntero de la pila
	ret

mul:
	// GUARDA EN PILA PARA MUL
	addi sp, sp, -4			// Reservo el espacio para el registro salvado que usaré
	sw s1, 0(sp)

	mv s1, zero				// res = 0
	while:
		blez a1, ewhile 	// while(b > 0)
		add s1, s1, a0		// res += a
		addi a1, a1, -1		// b--
		j while
	ewhile:
	mv a0, s1				// Muevo res al registro de retorno
	// RECUPERA LA PILA
	lw s1, 0(sp)			// Recupero de la pila s1
	addi sp, sp, 4			// Restauro el puntero de la pila
	ret
