        .data                               # Sección de datos
msg_fib_count:   .asciiz "¿Cuántos números de la serie Fibonacci desea generar?: "
msg_invalid:     .asciiz "Por favor, ingrese un número mayor que 0.\n"
msg_fib_result:  .asciiz "La serie Fibonacci es: "
msg_fib_sum:     .asciiz "\nLa suma de la serie es: "

        .text                               # Sección de código
        .globl main

main:
        # Preguntar cuántos números de la serie Fibonacci desea generar
ask_count:
        li $v0, 4               # Syscall para imprimir string
        la $a0, msg_fib_count   # Cargar el mensaje de cuántos números
        syscall

        li $v0, 5               # Syscall para leer entero
        syscall
        move $t4, $v0           # Mover la cantidad ingresada a $t4

        # Verificar si el número es mayor que 0
        li $t5, 1               # Mínimo número permitido
        blt $t4, $t5, invalid_count  # Si es menor que 1, volver a pedir
        j start_fibonacci        # Si es válido, proceder con la generación

invalid_count:
        li $v0, 4               # Imprimir mensaje de número inválido
        la $a0, msg_invalid     # Cargar el mensaje de error
        syscall
        j ask_count             # Volver a preguntar cuántos números generar

start_fibonacci:
        # Inicialización de los primeros valores de Fibonacci
        li $t0, 0               # Primer número de Fibonacci (F(0))
        li $t1, 1               # Segundo número de Fibonacci (F(1))
        li $t2, 0               # Variable para el siguiente número en la serie
        li $t3, 0               # Contador de iteraciones
        li $t6, 0               # Acumulador para la suma de la serie

        # Imprimir mensaje de resultado de la serie
        li $v0, 4               # Syscall para imprimir string
        la $a0, msg_fib_result  # Cargar el mensaje de la serie
        syscall

print_fibonacci:
        # Mostrar el valor de Fibonacci actual (t0)
        li $v0, 1               # Syscall para imprimir entero
        move $a0, $t0           # Cargar el número actual de Fibonacci
        syscall

        # Sumar el valor actual a la suma acumulada
        add $t6, $t6, $t0       # Sumar el número actual a la suma total

        # Calcular el siguiente número de Fibonacci
        add $t2, $t0, $t1       # Siguiente número es la suma de los dos anteriores
        move $t0, $t1           # Actualizar F(n-1) con F(n)
        move $t1, $t2           # Actualizar F(n) con el siguiente número

        # Incrementar el contador
        addi $t3, $t3, 1

        # Verificar si ya se generaron todos los números
        blt $t3, $t4, print_fibonacci  # Si el contador es menor a $t4, continuar la serie

        # Imprimir la suma de la serie
        li $v0, 4               # Syscall para imprimir string
        la $a0, msg_fib_sum     # Cargar el mensaje de la suma
        syscall

        li $v0, 1               # Syscall para imprimir entero
        move $a0, $t6           # Cargar la suma total en $a0
        syscall

        # Finalizar el programa
        li $v0, 10              # Syscall para salir
        syscall
