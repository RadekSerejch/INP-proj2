; Vernamova sifra na architekture DLX
; Radek Šerejch xserej00
; r8-r11-r15-r29-r30-r0

;r8 iterátor
;r11 šifrovací klíè pro s
;r15 šifrovací klíè pro e
        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xserej00"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	;inicializace šifrovacích klíèù
	addi r11,r0,19
	addi r15,r0,5
	;inicializace iterátoru
	addi r8,r0,0
	
loop:
	lb r29,login(r8)	;naètení hodnoty
	sgti r30,r29,96		;kontrola jestli je hodnoty vìtší než 'a'
	beqz r30,pre_end	;pokud není, jdu na end, protože jsem dostal èíslo
	add r29,r29,r11		;inkrement znaku
	sgti r30,r29,122	;kontrola preteceni
	bnez r30,preteceni
preteceni_ok:
	sb cipher(r8),r29	;zapsání na výstup
	addi r8,r8,1
	
;pro druhý znak
	lb r29,login(r8)	;naètení hodnoty
	sgti r30,r29,96		;kontrola jestli je hodnoty vìtší než 'a'
	beqz r30,pre_end	;pokud není, jdu na end, protože jsem dostal èíslo
	sub r29,r29,r15		;dekrement znaku
	sgti r30,r29,96		;kontrola podteceni
	beqz r30,podteceni
podteceni_ok:
	sb cipher(r8),r29	;zapsání na výstup
	addi r8,r8,1		;inkrement iterátoru
	j loop


preteceni:
	subi r29,r29,26
	j preteceni_ok
	nop
podteceni:
	addi r29,r29,26
	j podteceni_ok
	nop
pre_end:
	addi r8,r8,1
	sb cipher(r8),r0
	nop
	
end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
	
	;addi r8,r0,97
	;sb cipher(r0),r8
	;addi r8,r0,1
	;sb cipher(r8),r0