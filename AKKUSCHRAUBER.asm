; ***********************************************************
; * Akkuschrauber Code:                                     *
; * 4-stufiger Akkuschrauber mit 3 Eindrehgeschwindigkeiten *
; * und 1 Rausdrehgeschwindigkeit                           *
; * Modi: 20 RPM, 40RPM, 60 RPM, -20 RPM                    *
; * Ersteller: Grima04 und MatPhil2K                        *
; * Datum: 14. Dezember 2020                                *
; ***********************************************************

	CPU 80515				;MC selection (identical with 80C535)
	INCLUDE stddef51		        ;SFR definitions
	SEGMENT code				;Program code segment starts here

ORG 0000H 				    	;Adresszähler
	JMP START				;Springe auf START

ORG 000BH             				;Adresszähler für Zähler 0 Interrupt
	SETB P4.5				;setzen des Takt Bits
	CLR P4.5				;Löschen des Takt Bits
	MOV TH0,R0 				;High-byte des Zählers wiederherstellen
	MOV TL0,R1				;Low-byte des Zählers wiederherstellen	
	RETI					;Verlasse den Interrupt
	
ORG 0100H				   	;Adresszähler Hauptprogramm
START:
	MOV TMOD,#00000001B			;Betriebsart des Zählers setzen 
	SETB ET0				;Zähler 0 freigeben
	SETB EAL				;Interrupts zulassen
	MOV R7,#4				;Setze Flag für Stop
	CALL AUSGABE_7SEGM			;Rufe Anzeige-Unterprogramm auf

CHECK_BTN:
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#01111111B,EQU7			;Verzweige, wenn Taste 8 nicht gedrückt
        JMP STEP1				;Springe auf Vorwärtsdrehung 1
EQU7: 
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#10111111B,EQU6			;Verzweige, wenn Taste 7 nicht gedrückt
        JMP STEP2				;Springe auf Vorwärtsdrehung 2
EQU6: 
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#11011111B,EQU5			;Verzweige, wenn Taste 6 nicht gedrückt
        JMP STEP3				;Springe auf Vorwärtsdrehung 3
EQU5: 
	MOV A,P1				;Kopiere Port1 auf Akku A
	CJNE A,#11101111B,CHECK_BTN 		;Verzweige, wenn Taste 5 nicht gedrückt
        JMP REV					;Springe auf Rückwärtsdrehung

STEP1:
	MOV R7,#0				;Setze Flag für Vorwärtsdrehung 1
	CALL AUSGABE_7SEGM			;Rufe Anzeige-Unterprogramm auf
	MOV R0,#085H  				;Speichere High-byte für Zähler
	MOV R1,#0EEH				;Speichere Low-byte für Zähler
	MOV TH0,R0				;High-byte des Zählers setzen
	MOV TL0,R1				;Low-byte des Zählers setzen			
	CLR P4.7 				;Setze Schrittweite auf Vollschritt
	SETB P4.6				;Setze Drehrichtung auf Rechts
	SETB TR0				;Starte Zähler 0
	JMP ENT					;Springe zur Entprellung
STEP2:
	MOV R7,#1				;Setze Flag für Vorwärtsdrehung 2
	CALL AUSGABE_7SEGM			;Rufe Anzeige-Unterprogramm auf
	MOV R0,#0C2H   				;Speichere High-byte für Zähler
	MOV R1,#0F7H				;Speichere Low-byte für Zähler
 	MOV TH0,R0				;High-byte des Zählers setzen
	MOV TL0,R1 				;Low-byte des Zählers setzen		
	CLR P4.7				;Setze Schrittweite auf Vollschritt	
	SETB P4.6				;Setze Drehrichtung auf Rechts
	SETB TR0				;Starte Zähler 0
	JMP ENT					;Springe zur Entprellung
STEP3:
	MOV R7,#2				;Setze Flag für Vorwärtsdrehung 3
CALL AUSGABE_7SEGM				;Rufe Anzeige-Unterprogramm auf
	MOV R0,#0D7H  				;Speichere High-byte für Zähler
	MOV R1,#050H 	      			;Speichere Low-byte für Zähler
	MOV TH0,R0 				;High-byte des Zählers setzen
	MOV TL0,R1 				;Low-byte des Zählers setzen		
	CLR P4.7 				;Setze Schrittweite auf Vollschritt
	SETB P4.6	 			;Setze Drehrichtung auf Rechts
	SETB TR0				;Starte Zähler 0
	JMP ENT					;Springe zur Entprellung
REV:
	MOV R7,#3				;Setze Flag für Rückwärtsdrehung
	CALL AUSGABE_7SEGM			;Rufe Anzeige-Unterprogramm auf
	MOV R0,#0C2H  				;Speichere High-byte für Zähler
	MOV R1,#0F7H 				;Speichere Low-byte für Zähler
	MOV TH0,R0  				;High-byte des Zählers setzen
	MOV TL0,R1 				;Low-byte des Zählers setzen		
	SETB P4.7 				;Setze Schrittweite auf Halbschritt
	CLR P4.6				;Setze Drehrichtung auf Links
	SETB TR0				;Starte Zähler 0
	JMP ENT					;Springe zur Entprellung

STOP: 
MOV R7,#4					;Setze Flag für Stop
	CALL AUSGABE_7SEGM			;Rufe Anzeige-Unterprogramm auf	
	CLR TR0					;Stoppe Zähler 0
	JMP CHECK_BTN				;Springe auf Taster überprüfen

ENT:     
	MOV A,P1				;Kopiere Port1 Auf Akku A
        MOV R3,#20				;Lade Entprell-Zähler mit 20
ENT2:    
	CJNE A,P1,ENT				;Verzweige, wenn A ungleich Port1
	DJNZ R3,ENT2				;Ende der Schleife erreicht?
	MOV A,P1				;Kopiere Port1 Auf Akku A
EQUBTN8: 	
	CJNE A,#01111111B,EQUBTN7		;Verzweige, wenn Taste 8 nicht gedrückt
        MOV A,P1				;Kopiere Port1 Auf Akku A
        JMP EQUBTN8				;Wiederhole Tastenprüfung
EQUBTN7: 
	CJNE A,#10111111B,EQUBTN6		;Verzweige, wenn Taste 7 nicht gedrückt
	MOV A,P1				;Kopiere Port1 Auf Akku A
        JMP EQUBTN7				;Wiederhole Tastenprüfung
EQUBTN6: 
        CJNE A,#11011111B,EQUBTN5		;Verzweige, wenn Taste 6 nicht gedrückt
        MOV A,P1				;Kopiere Port1 Auf Akku A
        JMP EQUBTN6				;Wiederhole Tastenprüfung


EQUBTN5: 
	CJNE A,#11101111B,STOP			;Verzweige, wenn Taste 5 nicht gedrückt
        MOV A,P1				;Kopiere Port1 Auf Akku A
 	JMP EQUBTN5				;Wiederhole Tastenprüfung
	  
AUSGABE_7SEGM: 				
	CJNE R7,#0,RPM40			;Flag Vorwärtsdrehung 1 gesetzt?
	MOV DPTR,#TR20              		;Zeiger auf Sprungtabelle TR20
	SJMP AUSGABE_7SEGM_2        		;Springe auf Anzeigenausgabe
RPM40:	   
	CJNE R7,#1,RPM60			;Flag Vorwärtsdrehung 2 gesetzt?
        MOV DPTR,#TR40 				;Zeiger auf Sprungtabelle TR40
        SJMP AUSGABE_7SEGM_2			;Springe auf Anzeigenausgabe	   
RPM60:       
	CJNE R7,#2,NEG20RPM			;Flag Vorwärtsdrehung 3 gesetzt?
        MOV DPTR,#TR60				;Zeiger auf Sprungtabelle TR60
	SJMP AUSGABE_7SEGM_2			;Springe auf Anzeigenausgabe
NEG20RPM:     
	CJNE R7,#3,AUSGESCH			;Flag Rückwärtsdrehung gesetzt?
        MOV DPTR,#NEGTR20			;Zeiger auf Sprungtabelle NEGTR20
        SJMP AUSGABE_7SEGM_2			;Springe auf Anzeigenausgabe   
AUSGESCH:      
	MOV DPTR,#OFF				;Zeiger auf Sprungtabelle OFF
        SJMP AUSGABE_7SEGM_2			;Springe auf Anzeigenausgabe
			   
AUSGABE_7SEGM_2: 
	CLR A					;Akku A löschen
        CALL DPTR_ROUTINE			;Rufe Zeiger auf um Tabelle anzusteuern
        CLR P4.3				
        SETB P4.3				;Aktualisiere Segmentblock 3
        CLR A					;Akku A löschen
        CALL DPTR_ROUTINE      			;Rufe Zeiger auf um Tabelle anzusteuern
        CLR P4.2
        SETB P4.2				;Aktualisiere Segmentblock 2
        CLR A					;Akku A löschen
        CALL DPTR_ROUTINE			;Rufe Zeiger auf um Tabelle anzusteuern
        CLR P4.1
        SETB P4.1				;Aktualisiere Segmentblock 1
CLR A						;Akku A löschen
        CALL DPTR_ROUTINE			;Rufe Zeiger auf um Tabelle anzusteuern
        CLR P4.0
        SETB P4.0				;Aktualisiere Segmentblock 0
        RET					;Verlasse Unterprogramm
   
DPTR_ROUTINE:    
	MOVC A,@A+DPTR				;Kopiere Inhalt von Tabellenzeile auf A
        INC DPTR				;Erhöhe Zeiger um 1
        MOV P5,A				;Anzeige ausgeben
        RET                       		;Unterprogramm verlassen
 
TR20:    
	DB 10100100B 				;Ziffer 2
        DB 11000000B 				;Ziffer 0
 	DB 10000111B 				;Ziffer t
 	DB 10101111B 				;Ziffer r
TR40:    
	DB 10011001B 				;Ziffer 4
        DB 11000000B 				;Ziffer 0
	DB 10000111B 				;Ziffer t
 	DB 10101111B 				;Ziffer r
TR60:    
	DB 10000010B 				;Ziffer 6
        DB 11000000B 				;Ziffer 0
	DB 10000111B 				;Ziffer t
 	DB 10101111B 				;Ziffer r
NEGTR20: 
	DB 10111111B 				;Ziffer -
        DB 10100100B 				;Ziffer 2
        DB 11000000B 				;Ziffer 0
	DB 10000111B 				;Ziffer t
OFF:     
	DB 11111111B 				;Anzeige dunkel
        DB 11000000B 				;Ziffer 0
	DB 10001110B 				;Ziffer F
	DB 10001110B 				;Ziffer F
	  
