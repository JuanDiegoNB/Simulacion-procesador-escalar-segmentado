        .data                               # Sección de datos
msg_input:   .asciiz "Ingrese un número: "  
msg_count:   .asciiz "¿Cuántos números desea comparar (entre 3 y 5)?: "
msg_invalid: .asciiz "Por favor, ingrese un número entre 3 y 5.\n"
msg_result:  .asciiz "El número mayor es: " 

        .text                               # Sección de código
        .globl main

main:
        # Preguntar cuántos números desea comparar
ask_count:
        li $v0, 4               # Syscall para imprimir string
        la $a0, msg_count       # Cargar el mensaje de cuántos números
        syscall

        li $v0, 5               # Syscall para leer entero
        syscall
        move $t4, $v0           # Mover la cantidad ingresada a $t4

        # Verificar si el número está entre 3 y 5
        li $t5, 3               # Mínimo número permitido
        li $t6, 5               # Máximo número permitido
        blt $t4, $t5, invalid_count  # Si es menor que 3, volver a pedir
        bgt $t4, $t6, invalid_count  # Si es mayor que 5, volver a pedir
        j start_comparison       # Si es válido, proceder con la comparación

invalid_count:
        li $v0, 4               # Imprimir mensaje de número inválido
        la $a0, msg_invalid     # Cargar el mensaje de error
        syscall
        j ask_count             # Volver a preguntar cuántos números comparar

start_comparison:
        # Inicializar el contador y el mayor número
        li $t0, 0               # Contador de iteraciones
        li $t1, -2147483648     # Inicializar el número mayor con el menor posible

ask_numbers:
        # Pregunta al usuario por el número
        li $v0, 4               # Syscall para imprimir string
        la $a0, msg_input       # Cargar el mensaje para pedir número
        syscall

        li $v0, 5               # Syscall para leer entero
        syscall
        move $t2, $v0           # Mover el número leído a $t2

        # Comparar si el número ingresado es mayor que el actual mayor
        ble $t2, $t1, skip      # Si $t2 <= $t1, no actualizar el mayor
        move $t1, $t2           # Si $t2 es mayor, actualizar $t1 con $t2

skip:
        addi $t0, $t0, 1        # Incrementar el contador
        blt $t0, $t4, ask_numbers  # Si el contador es menor a la cantidad ingresada, repetir

        # Mostrar el número mayor
        li $v0, 4               # Syscall para imprimir string
        la $a0, msg_result       # Cargar el mensaje del resultado
        syscall

        li $v0, 1               # Syscall para imprimir entero
        move $a0, $t1           # Cargar el número mayor en $a0
        syscall

        # Finalizar el programa
        li $v0, 10              # Syscall para salir
        syscall
