/*---------------------------------------------------------------------
**
**  Fichero:
**    p1.asm  19/10/2022
**
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la practica 1
**
**-------------------------------------------------------------------*/

.global main
.data
	res: .word 0
.equ n,10

.text
main:
	lw t0, res 		// Cargo el valor de res
	li t1, n		// Cargo el valor de n
	li t2, 0 		// i = 0
for:
	bge t2, t1, endfor // i < n
	add s1, s1, t2	// res += i
	addi t2, t2, 1	// i++
	j for
endfor:
	sw t0, 0(s1)		// Guardo el valor de res en su direccion de memoria inicial
fin:
	j .				// Final del programa
.end
