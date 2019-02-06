#_______________________________#
#  Batuhan TOPALOÐLU 151044026  #
#_______________________________#

.data  
	filename: .asciiz "input_asm.txt"      # text in okunamacaðý dosyanýn adý
	
	str0: .asciiz "zero"
	str1: .asciiz "one"
	str2: .asciiz "two"
	str3: .asciiz "three"
	str4: .asciiz "four"
	str5: .asciiz "five"
	str6: .asciiz "six"
	str7: .asciiz "seven"
	str8: .asciiz "eight"
	str9: .asciiz "nine"
	
	Bstr0: .asciiz "Zero"
	Bstr1: .asciiz "One"
	Bstr2: .asciiz "Two"
	Bstr3: .asciiz "Three"
	Bstr4: .asciiz "Four"
	Bstr5: .asciiz "Five"
	Bstr6: .asciiz "Six"
	Bstr7: .asciiz "Seven"
	Bstr8: .asciiz "Eight"
	Bstr9: .asciiz "Nine"
					
	rakam0: .byte '0'
	
	dot: .byte '.' 		#cümle baþlangýçlarýný kontrol ederken kullandýðým nokta iþareti
	spaceK: .byte ' '
	buffer: .space 256 

.text
	
	main:
	li   $v0, 13       #Dosyanýn açýlmasý
	la   $a0, filename #dosya adý
	li   $a1, 0      
	li   $a2, 0
	syscall            
	add $s2,$zero, $v0      

	li   $v0, 14       # dosyadan text in okunmasý
	move $a0, $s2     
	la   $a1, buffer  
	li   $a2, 256    
	syscall           
	
	move $t2, $v0     #dosyadaki text'in uzunluðu kaydedilir , bu deðere göre döngü döndürülecek
	lb $a3 , rakam0   #rakam olup olmadýðýný kontrol ederken kullandýðým deðer
  	add $s4,$zero,$a1 #Text in baþlangýçýný yedekliyorum
   	li $t1, 0         # dosyanýn sonun gelip gelmediðimi kontrol etmek için kullanýlan counter
	
	addi $s5 ,$zero,2
	
  	Loop:
  		beq $t2, $t1, Exit   # dosyadaki text'in bitmesi koþulu
    	addi $t1, $t1,1      # döngü counter ý
  		add $s1 ,$zero ,$a3  #loop her dönüþünde ilk kontrol rakamý tekrar 0 a formatlanýr.
  		lbu $s3,0($s4)	
  		  		
  		jal CheckNumber  # okunan karakterin rakam olup olmadýðý kontrol edilir.
		addi $s4,$s4,1   # Kontrol etmek üzere bir sonraki karaktere geçilir.

		j Loop
		
  	Exit: #programýn sonu    		
		li   $v0, 16       # dosya kapatýlma komutu
		move $a0, $s2    
		syscall  		
		li $v0 ,10         #programýn bittiði belitilir
		syscall
  
  	CheckNumber:	     #tek tek hangi rakam olduðu kontrol edilir.	
		
		addi $t3,$s4,-2 # '.' kontrolü için
		addi $t5,$s4,-1 # ' ' space karakter kontrolü için
		lbu $t4,1($s4)	# bir sonraki karakater noktamý diye kontrol etmek için
		lbu $t6,2($s4)  # iki sonraki karakter space mi diye( *** 7. -> gibi biten cümleler için)
		lbu $t9,0($t3)	
		lbu $t7,0($t5)
		
		lb $t3,dot
		lb $t5,spaceK
		
		beq $t4,$t3,checkAfterTwoC  # '.' ile bir sonraki eleman
		beq $t3,$t7,print           # '.' ile bir önceki eleman
		beq $t5,$t7,checkRightSpace # sol space ise saða bakýyor
		beq $t5,$t4,checkLeftSpace  # sað space ise sola bakýyor
		jumpPoint0:
		beq $s3,$s1,print0
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print1
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print2
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print3
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print4
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print5
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print6
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print7
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print8
  		addi $s1 ,$s1,1
  		beq $s3,$s1,print9
		bne $s3,$s1, print  #eldeki karakterin rakam olmama durumu
	    jr $ra  
  
	checkAfterTwoC:
		bne $t6,$t5,print  # ' ' ile iki sonraki
		j jumpPoint0
		
	checkAfterOneC:
		beq $t9,'1',print
		j jumpPoint0		
	checkRightSpace:
		beq $t4,$t5,jumpPoint0	
		j print
	checkLeftSpace:	
		beq $t7,$t5,jumpPoint0	
		j print
	print:   #rakam harici karakterleri ekrana basan fonksiyon
		p:
		li $v0 ,11
		move $a0,$s3
		syscall		
		jr $ra 	

	target0: #dosyanýn ikinci karakterinde büyük/küçük harf seçiminde bir problem 
			 # oluþuyordu onu çözmek için kullandýðým koþullar
		beq $t3,$t9,SpaceCheck0
		j a0
	SpaceCheck0:
		beq $t5,$t7,printB0 
		j p	
	print0:
		bgt $t1,$s5,target0 # nokta kontrolü için current karakterin önünde en az 2 karakter 
							# olmasý gerekiyor onun kontrol edildiði koþul.
		a0:
		bne $t7,$t5,print   # saðýnda solunda boþluk olmazsa rakam deðildir.
		bne $t4,$t5,print	#
		beq $a1,$s4,printB0 #Dosyanýn ilk karakteri olmasý			
		li $v0,4  
		la $a0, str0        # küçük harfle baþlanmasý durumu
		syscall		
		jr $ra		 	  	  	  		
	target1:
		beq $t3,$t9,SpaceCheck1
		j a1
	SpaceCheck1:
		beq $t5,$t7,printB1
		j p					
	print1:				
		bgt $t1,$s5,target1
	    a1: 
	    bne $t7,$t5,print
		bne $t4,$t5,print				
		beq $a1,$s4,printB1  		
		li $v0,4
		la $a0,str1 
		syscall		
		jr $ra		
	target2:
		beq $t3,$t9,SpaceCheck2
		j a2
	SpaceCheck2:
		beq $t5,$t7,printB2
		j p
	print2:	
		bgt $t1,$s5,target2
	    a2:
	    bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB2		
		li $v0,4
		la $a0,str2
		syscall		
		jr $ra
	target3:
		beq $t3,$t9,SpaceCheck3
		j a3
	SpaceCheck3:
		beq $t5,$t7,printB3
		j p
	print3:	
		bgt $t1,$s5,target3
	    a3:		
	    bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB3	
		li $v0,4
		la $a0,str3		
		syscall		
		jr $ra
	target4:
		beq $t3,$t9,SpaceCheck4 
		j a4
	SpaceCheck4:
		beq $t5,$t7,printB4
		j p
	print4:
		bgt $t1,$s5,target4
	    a4:	    
	    bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB4		
		li $v0,4
		la $a0,str4
		syscall
		jr $ra
	target5:
		beq $t3,$t9,SpaceCheck5
		j a5
	SpaceCheck5:
		beq $t5,$t7,printB5
		j p
	print5:	
		bgt $t1,$s5,target5
	    a5:
	    bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB5		
		li $v0,4
		la $a0,str5
		syscall		
		jr $ra
	target6:
		beq $t3,$t9,SpaceCheck6 
		j a6
	SpaceCheck6:
		beq $t5,$t7,printB6
		j p
	print6:
		bgt $t1,$s5,target6
	    a6:
		bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB6
		li $v0,4
		la $a0,str6
		syscall		
		jr $ra
	target7:
		beq $t3,$t9,SpaceCheck7 
		j a7
	SpaceCheck7:
		beq $t5,$t7,printB7
		j p
	print7:	
		bgt $t1,$s5,target7
	    a7:
	    bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB7
		li $v0,4
		la $a0,str7
		syscall		
		jr $ra
	target8:
		beq $t3,$t9,SpaceCheck8 
		j a8
	SpaceCheck8:
		beq $t5,$t7,printB8
		j p
	print8:	
		bgt $t1,$s5,target8
	    a8:
		bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB8
		li $v0,4
		la $a0,str8
		syscall		
		jr $ra
	target9:
		beq $t3,$t9,SpaceCheck9
		j a9
	SpaceCheck9:
		beq $t5,$t7,printB9
		j p
	print9:	
		bgt $t1,$s5,target9	    
	    a9:
		bne $t7,$t5,print
		bne $t4,$t5,print
		beq $a1,$s4,printB9
		li $v0,4
		la $a0,str9
		syscall		
		jr $ra		
	printB0:
		li $v0,4
		la $a0,Bstr0 #"Zero"
		syscall		
		jr $ra	
	printB1:
		li $v0,4
		la $a0,Bstr1 #"One"
		syscall		
		jr $ra
	printB2:
		li $v0,4
		la $a0,Bstr2 #"Two"
		syscall		
		jr $ra		
	printB3:
		li $v0,4
		la $a0,Bstr3 #"Three"
		syscall		
		jr $ra		
	printB4:
		li $v0,4
		la $a0,Bstr4 #"Four"
		syscall		
		jr $ra		
	printB5:
		li $v0,4
		la $a0,Bstr5 #"Five"
		syscall		
		jr $ra		
	printB6:
		li $v0,4
		la $a0,Bstr6 #"Six"
		syscall		
		jr $ra		
	printB7:
		li $v0,4
		la $a0,Bstr7 #"Seven"
		syscall		
		jr $ra		
	printB8:
		li $v0,4
		la $a0,Bstr8 #"Eight"
		syscall		
		jr $ra		
	printB9:
		li $v0,4
		la $a0,Bstr9 #"Nine"
		syscall		
		jr $ra
