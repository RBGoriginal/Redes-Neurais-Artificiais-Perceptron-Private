.data 
	#declarando mensagens
	msg_pulalinha: .asciiz "\n"
	msg_pula2linhas: .asciiz "\n\n"
	msg_separa: .asciiz "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-"
	msg_peso1: .asciiz "Peso 1 atual: "
	msg_peso2: .asciiz "Peso 2 atual: "
	msg_taxa: .asciiz "Taxa de aprendizado: "
	msg_esperado: .asciiz "Resultado Esperado: "
	msg_obtido: .asciiz "Resultado Obtido: "
	msg_erro: .asciiz "Taxa de erro:"
	msg_soma: .asciiz " + "
	msg_sub: .asciiz " - "
	msg_igual: .asciiz " = "

	#declarando variáveis
	peso1 : .float 0.0
	peso2 : .float 0.8
	taxaAp : .float 0.02
	entrada : .word 1
.text
main:	#Inicio programa
	l.s $f0,peso1 # peso 1
	l.s $f1,peso2 # peso 2
	l.s $f2,taxaAp # taxa de aprendizado

	lw $s3,entrada #Valores Entrada
	add $s4,$s3,$s3 #Valores Esperados

FOR: 	slti $s8,$s3,11
	beq $s8,$zero,ENDFOR

	#Mensagens	
	li $v0, 4
	la $a0, msg_separa
	syscall
	li $v0, 4
	la $a0, msg_pula2linhas
	syscall  
	li $v0, 4
	la $a0, msg_peso1
	syscall 
	li $v0, 2
	mov.s $f12, $f0
	syscall 
	li $v0, 4
	la $a0, msg_pulalinha
	syscall 
	li $v0, 4
	la $a0, msg_peso2
	syscall 
	li $v0, 2
	mov.s $f12, $f1
	syscall 
	li $v0, 4
	la $a0, msg_pulalinha
	syscall 
	li $v0, 4
	la $a0, msg_taxa
	syscall
	li $v0, 2
	mov.s $f12, $f2
	syscall 
	li $v0, 4
	la $a0, msg_pula2linhas
	syscall 
	li $v0, 4
	la $a0, msg_esperado
	syscall 
	li $v0, 4
	la $a0, msg_pulalinha
	syscall 
	li $v0,1
	move $a0, $s3
	syscall 
	li $v0, 4
	la $a0, msg_soma
	syscall 
	li $v0,1
	move $a0, $s3
	syscall 
	li $v0, 4
	la $a0, msg_igual
	syscall 
	li $v0, 1
	move $a0, $s4
	syscall 
	li $v0, 4
	la $a0, msg_pula2linhas
	syscall 

	#Convertendo entrada de word para float
	mtc1 $s3,$f3
	cvt.s.w $f3,$f3
	mtc1 $s4,$f4
	cvt.s.w $f4,$f4
	
	#Resultado obtido com os pesos
	mul.s $f5,$f0,$f3 # Multiplicando o peso 1 com entrada
	mul.s $f6,$f1,$f3 # Multiplicando o peso 2 com entrada
	add.s $f6,$f5,$f6 # Somando o resultado dos pesos	

	sub.s $f7,$f4,$f6 #Calculando o erro
	mov.s $f8,$f7 

	#Parte da multiplicação da fórmula
	mul.s $f7,$f7,$f2 #Erro x Taxa
	mul.s $f7,$f7,$f3 #Erro x Entrada 

	#Treinamento1_peso1: 
	add.s $f0,$f0,$f7 #Peso1 +Erro x Taxa x Entrada

	#Treinamento1_peso2:
	add.s $f1,$f1,$f7 #Peso2 +Erro x Taxa x Entrada

	#Mensagens
 	li $v0, 4
	la $a0, msg_obtido
	syscall 
	li $v0, 4
	la $a0, msg_pulalinha
	syscall 
	li $v0, 1
	move $a0, $s3
	syscall 
	li $v0, 4
	la $a0, msg_soma
	syscall 
	li $v0, 1
	move $a0, $s3
	syscall 
	li $v0, 4
	la $a0, msg_igual
	syscall 
	li $v0, 2
	mov.s $f12, $f6
	syscall 
	li $v0, 4
	la $a0, msg_pula2linhas
	syscall 
	li $v0, 4
	la $a0, msg_erro
	syscall 
	li $v0, 4
	la $a0, msg_pulalinha
	syscall 
	li $v0, 2
	mov.s $f12, $f4
	syscall 
	li $v0, 4
	la $a0, msg_sub
	syscall 
	li $v0, 2
	mov.s $f12, $f6
	syscall 
	li $v0, 4
	la $a0, msg_igual
	syscall 
	li $v0, 2
	mov.s $f12, $f8
	syscall 
	li $v0, 4
	la $a0, msg_pula2linhas
	syscall 
	
	addi $s3,$s3,1
	add $s4,$s3,$s3

	j FOR
ENDFOR: jr $ra