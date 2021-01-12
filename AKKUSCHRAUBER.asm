; ***********************************************************
; * Akkuschrauber Code:                                     *
; * 4-stufiger Akkuschrauber mit 3 Eindrehgeschwindigkeiten *
; * und 1 Rausdrehgeschwindigkeit                           *
; * Modi: 20 RPM, 40RPM, 60 RPM, -20 RPM                    *
; * Ersteller: Grima04 und MatPhil2K                        *
; ***********************************************************

	CPU 80515				;MC selection (identical with 80C535)
	INCLUDE stddef51		      ;SFR definitions
	SEGMENT code			;Program code segment starts here

ORG 0000H 				    ;Adressz�hler
	JMP START				;Springe auf START

ORG 000BH             		;Adressz�hler f�r Z�hler 0 Interrupt
	SETB P4.5				;setzen des Takt Bits
	CLR P4.5				;L�schen des Takt Bits
	MOV TH0,R0 				;High-byte des Z�hlers wiederherstellen
	MOV TL0,R1				;Low-byte des Z�hlers wiederherstellen	
	RETI					;Verlasse den Interrupt
	
ORG 0100H				    ;Adressz�hler Hauptprogramm
START:
	MOV TMOD,#00000001B		;Betriebsart des Z�hlers setzen 
	SETB ET0				;Z�hler 0 freigeben
	SETB EAL				;Interrupts zulassen
	MOV R7,#4				;Setze Flag f�r Stop
	CALL AUSGABE_7SEGM		;Rufe Anzeige-Unterprogramm auf

CHECK_BTN:
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#01111111B,EQU7	;Verzweige, wenn Taste 8 nicht gedr�ckt
      JMP STEP1				;Springe auf Vorw�rtsdrehung 1
EQU7: 
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#10111111B,EQU6		;Verzweige, wenn Taste 7 nicht gedr�ckt
      JMP STEP2				;Springe auf Vorw�rtsdrehung 2
EQU6: 
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#11011111B,EQU5		;Verzweige, wenn Taste 6 nicht gedr�ckt
      JMP STEP3				;Springe auf Vorw�rtsdrehung 3
EQU5: 
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#11101111B,CHECK_BTN 	;Verzweige, wenn Taste 5 nicht gedr�ckt
      JMP REV				;Springe auf R�ckw�rtsdrehung

STEP1:
	MOV R7,#0				;Setze Flag f�r Vorw�rtsdrehung 1
	CALL AUSGABE_7SEGM		;Rufe Anzeige-Unterprogramm auf
	MOV R0,#085H  			;Speichere High-byte f�r Z�hler
	MOV R1,#0EEH			;Speichere Low-byte f�r Z�hler
	MOV TH0,R0				;High-byte des Z�hlers setzen
	MOV TL0,R1				;Low-byte des Z�hlers setzen			
	CLR P4.7 				;Setze Schrittweite auf Vollschritt
	SETB P4.6				;Setze Drehrichtung auf Rechts
	SETB TR0				;Starte Z�hler 0
	JMP ENT					;Springe zur Entprellung
STEP2:
	MOV R7,#1				;Setze Flag f�r Vorw�rtsdrehung 2
	CALL AUSGABE_7SEGM		;Rufe Anzeige-Unterprogramm auf
	MOV R0,#0C2H   			;Speichere High-byte f�r Z�hler
	MOV R1,#0F7H			;Speichere Low-byte f�r Z�hler
 	MOV TH0,R0				;High-byte des Z�hlers setzen
	MOV TL0,R1 				;Low-byte des Z�hlers setzen		
	CLR P4.7				;Setze Schrittweite auf Vollschritt	
	SETB P4.6				;Setze Drehrichtung auf Rechts
	SETB TR0				;Starte Z�hler 0
	JMP ENT					;Springe zur Entprellung
STEP3:
	MOV R7,#2				;Setze Flag f�r Vorw�rtsdrehung 3
CALL AUSGABE_7SEGM			;Rufe Anzeige-Unterprogramm auf
	MOV R0,#0D7H  			;Speichere High-byte f�r Z�hler
	MOV R1,#050H 	      	;Speichere Low-byte f�r Z�hler
	MOV TH0,R0 				;High-byte des Z�hlers setzen
	MOV TL0,R1 				;Low-byte des Z�hlers setzen		
	CLR P4.7 				;Setze Schrittweite auf Vollschritt
	SETB P4.6	 			;Setze Drehrichtung auf Rechts
	SETB TR0				;Starte Z�hler 0
	JMP ENT					;Springe zur Entprellung
REV:
	MOV R7,#3				;Setze Flag f�r R�ckw�rtsdrehung
	CALL AUSGABE_7SEGM		;Rufe Anzeige-Unterprogramm auf
	MOV R0,#0C2H  			;Speichere High-byte f�r Z�hler
	MOV R1,#0F7H 			;Speichere Low-byte f�r Z�hler
	MOV TH0,R0  			;High-byte des Z�hlers setzen
	MOV TL0,R1 				;Low-byte des Z�hlers setzen		
	SETB P4.7 				;Setze Schrittweite auf Halbschritt
	CLR P4.6				;Setze Drehrichtung auf Links
	SETB TR0				;Starte Z�hler 0
	JMP ENT					;Springe zur Entprellung

STOP: 
MOV R7,#4					;Setze Flag f�r Stop
	CALL AUSGABE_7SEGM		;Rufe Anzeige-Unterprogramm auf	
	CLR TR0					;Stoppe Z�hler 0
	JMP CHECK_BTN			;Springe auf Taster �berpr�fen

ENT:     
	MOV A,P1				;Kopiere Port1 Auf Akku A
      MOV R3,#20			;Lade Entprell-Z�hler mit 20
ENT2:    
	CJNE A,P1,ENT			;Verzweige, wenn A ungleich Port1
	DJNZ R3,ENT2			;Ende der Schleife erreicht?
	MOV A,P1				;Kopiere Port1 Auf Akku A
EQUBTN8: 	
	CJNE A,#01111111B,EQUBTN7	;Verzweige, wenn Taste 8 nicht gedr�ckt
      MOV A,P1					;Kopiere Port1 Auf Akku A
      JMP EQUBTN8				;Wiederhole Tastenpr�fung
EQUBTN7: 
	CJNE A,#10111111B,EQUBTN6	;Verzweige, wenn Taste 7 nicht gedr�ckt
	MOV A,P1					;Kopiere Port1 Auf Akku A
      JMP EQUBTN7				;Wiederhole Tastenpr�fung
EQUBTN6: 
	CJNE A,#11011111B,EQUBTN5	;Verzweige, wenn Taste 6 nicht gedr�ckt
      MOV A,P1					;Kopiere Port1 Auf Akku A
      JMP EQUBTN6				;Wiederhole Tastenpr�fung


EQUBTN5: 
	CJNE A,#11101111B,STOP		;Verzweige, wenn Taste 5 nicht gedr�ckt
      MOV A,P1					;Kopiere Port1 Auf Akku A
 	JMP EQUBTN5					;Wiederhole Tastenpr�fung
	  
AUSGABE_7SEGM: 				
	CJNE R7,#0,RPM40			;Flag Vorw�rtsdrehung 1 gesetzt?
	MOV DPTR,#TR20              ;Zeiger auf Sprungtabelle TR20
	SJMP AUSGABE_7SEGM_2        ;Springe auf Anzeigenausgabe
RPM40:	   
	CJNE R7,#1,RPM60			;Flag Vorw�rtsdrehung 2 gesetzt?
      MOV DPTR,#TR40 			;Zeiger auf Sprungtabelle TR40
      SJMP AUSGABE_7SEGM_2		;Springe auf Anzeigenausgabe	   
RPM60:       
	CJNE R7,#2,NEG20RPM			;Flag Vorw�rtsdrehung 3 gesetzt?
      MOV DPTR,#TR60			;Zeiger auf Sprungtabelle TR60
	SJMP AUSGABE_7SEGM_2		;Springe auf Anzeigenausgabe
NEG20RPM:     
	CJNE R7,#3,AUSGESCH			;Flag R�ckw�rtsdrehung gesetzt?
      MOV DPTR,#NEGTR20			;Zeiger auf Sprungtabelle NEGTR20
      SJMP AUSGABE_7SEGM_2		;Springe auf Anzeigenausgabe   
AUSGESCH:      
	MOV DPTR,#OFF				;Zeiger auf Sprungtabelle OFF
      SJMP AUSGABE_7SEGM_2		;Springe auf Anzeigenausgabe
			   
AUSGABE_7SEGM_2: 
	CLR A						;Akku A l�schen
      CALL DPTR_ROUTINE			;Rufe Zeiger auf um Tabelle anzusteuern
      CLR P4.3				
      SETB P4.3					;Aktualisiere Segmentblock 3
      CLR A						;Akku A l�schen
      CALL DPTR_ROUTINE      	;Rufe Zeiger auf um Tabelle anzusteuern
      CLR P4.2
      SETB P4.2					;Aktualisiere Segmentblock 2
      CLR A						;Akku A l�schen
      CALL DPTR_ROUTINE			;Rufe Zeiger auf um Tabelle anzusteuern
      CLR P4.1
      SETB P4.1					;Aktualisiere Segmentblock 2
CLR A							;Akku A l�schen
      CALL DPTR_ROUTINE			;Rufe Zeiger auf um Tabelle anzusteuern
      CLR P4.0
      SETB P4.0					;Aktualisiere Segmentblock 2
      RET						;Verlasse Unterprogramm
   
DPTR_ROUTINE:    
	MOVC A,@A+DPTR				;Kopiere Inhalt von Tabellenzeile auf A
      INC DPTR					;Erh�he Zeiger um 1
      MOV P5,A					;Anzeige ausgeben
      RET                       ;Unterprogramm verlassen
 
TR20:    
	DB 10100100B 			;Ziffer 2
      DB 11000000B 			;Ziffer 0
 	DB 10000111B 			;Ziffer t
 	DB 10101111B 			;Ziffer r
TR40:    
	DB 10011001B 			;Ziffer 4
      DB 11000000B 			;Ziffer 0
	DB 10000111B 			;Ziffer t
 	DB 10101111B 			;Ziffer r
TR60:    
	DB 10000010B 			;Ziffer 4
      DB 11000000B 			;Ziffer 0
	DB 10000111B 			;Ziffer t
 	DB 10101111B 			;Ziffer r
NEGTR20: 
	DB 10111111B 			;Ziffer -
      DB 10100100B 			;Ziffer 2
      DB 11000000B 			;Ziffer 0
	DB 10000111B 			;Ziffer t
OFF:     
	DB 11111111B 			;Anzeige dunkel
      DB 11000000B 			;Ziffer 0
	DB 10001110B 			;Ziffer F
	DB 10001110B 			;Ziffer F
	  
