;-----------------------------------------------------------------------------
;-----------------------------------Piyu--------------------------------------
;-----------------------------------------------------------------------------

;Project by D14 for Microprocessor and Peripheral Interfacing
; 53 - Samarth Shahu
; 54 - Prithvi Sharma
; 70 - Tanmay Lotankar

.Model Small
.Stack 1000H
.Data
piyuSpeed db 5
finalScore db 30
bmLocY db 02h
bmLocX db 19h
dot db 3h
mine db 15
helpTitle db "Help"
help1 db "1.Use Arrows To Move",0
help1Len dw 21
help2 db "2.Point for Each Dot",0
help2Len dw 21
help3 db "3.'r' Repeat Game.",0
help3Len dw 19
help4 db "4.ESC to Exit",0
help4Len dw 14
scoreMsg db "Score  0000",0
scoreMsgLen dw 11
exitMsg db "     Thanks For Playing!",10,13              
exitMsgLen dw 27
doneByMsg db " Project by D14A :- 53,54 and 70 ",1h,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13,10,13
doneByMsgLen dw 56
levelCompleteMsg db "  !!! CONGRATULATIONS !!!"
levelCompleteMsgLen dw 25
livesMsg db "Lives   ", 01,00,01,00,01
livesMsgLen dw 8
gameOverMsg db "  !!! GAME OVER CHOTE !!!        "
gameOverMsgLen dw 32
pressAnyKeyMsg db " Press Any Key To Continue...  "
pressAnyKeyMsgLen dw 29
right db 77
left db 75
up db 72
down db 80
quit db 1bh
restart db 'r'
level1Positions dw 1030h,113CH,061AH,0737h,0549h,1149h
dw 1019h,1122h,0623h,0727h,034Ch,1242h
dw 0519h,0936h,101Fh,062AH,0949h,074Ch
dw 021DH,0924h,1035h,063AH,072Fh,0943h
dw 021Fh,0530h,092DH,061DH,071CH,0C42h
doubleNumOfDots dw 60
t1 db 01
t2 db 01
td db 01
level1Mines			dw 1045h,0330H,071FH,0732h,0242h
dw 0824h,1327h,0F1Ch,0D4Dh,0233h
level1MinesCopy		dw 1045h,0330H,071FH,0732h,0242h
dw 0824h,1327h,0F1Ch,0D4Dh,0233h
level1MinesNum dw 20              
level1BeginingBlocks	dw 0240h,0D40h,0C19h,0425h,0B25h,1125h,0425h,082Dh,0919h
level1EndingBlocks		dw 0941h,1441h,0C36h,0B26h,1126h,1136h,043Bh,0832h,091Fh
level1BlocksNum	dw	18
finishFlag db 0
currentDirection db 0
initialbmLocY db 02h
initialbmLocX db 19h
score db 48,48,48,48
scoreInteger db 0 
piyuFace db 1h 
piyuColor db 0Eh 
dotsColor db 0Bh
minesColor db 04h 
broll db 176 
brollL dw 1
brollColor db 08h 
borderColor db 10h 
helpAreaColor db 0FH
boardBeginingXY dw 0118H
boardEndingXY dw 154EH
scoreAreaBeginingXY dw 0100H
scoreAreaEndingXY dw 0315H
livesAreaBeginingXY dw 0500H
livesAreaEndingXY dw 0715H
helpAreaBeginingXY dw 0D00H
helpAreaEndingXY dw 1515H
lives db 51
scoreAreaColor db ?
levelTmpMines			dw	(?)
levelTmpPositions 		dw 	(?)
.Code
.startup
mov     ah, 1
mov     ch, 2bh
mov     cl, 0bh
int     10h
CALL cls 			
CALL buildHelpArea 		
call buildInitialScreen
mov ah, 00h
int 16h
CALL copyPositions
restartGame:
mov lives, 51
begining:
CALL cls 				
CALL buildBoard  		
call putBlocks			
CALL buildScoreArea 	
CALL buildLivesArea 			
CALL buildHelpArea 		
call fillBoard			
call putMines			
CALL putpiyu		
waitActionMain:
MOV AH,06h
MOV DL,0FFh
INT 21h
jz waitActionMain
CALL changeDirection
exit:
CALL exitArea
MOV AH,4CH
INT 21h
proc buildInitialScreen
MOV AH,06H
MOV AL,00H
MOV BH,0C4H
MOV CX,0D1AH
MOV DX,1549H
INT 10H
MOV AH,06H
MOV AL,00H
MOV BH,0E0H
MOV CX,0E1BH
MOV DX,1448H
INT 10H
MOV BX,CX
add BX,0101h
CALL setXY
MOV DX, offset DoneByMsg
MOV CX, DoneByMsgLen
CALL printLine
CALL setXY
MOV DX, offset exitMsg
MOV CX, exitMsgLen
CALL printLine
add BX,0211h
CALL setXY
MOV DX, offset pressAnyKeyMsg
MOV CX, pressAnyKeyMsgLen
CALL printLine
RET
buildInitialScreen endp
Proc copyPositions
push di
push bx
SUB DI,DI
@@copyLoop:
MOV  BX,[level1Positions+DI]
MOV [levelTmpPositions+DI],BX
ADD DI, 2
CMP DI,doubleNumOfDots
JNE @@copyLoop
pop bx
pop di
RET
copyPositions EndP
Proc reCopyPositions
push di
push bx
SUB DI,DI
@@copyLoop2:
MOV  BX,[leveltmpPositions+DI]
MOV [level1Positions+DI],BX
ADD DI, 2
CMP DI,doubleNumOfDots
JNE @@copyLoop2
pop bx
pop di
RET
reCopyPositions EndP
Proc reCopyMines
push di
push bx
SUB DI,DI
@@copyLoopMines2:
MOV  BX,[level1MinesCopy+DI]
MOV [level1Mines+DI],BX
ADD DI, 2
CMP DI,level1MinesNum
JNE @@copyLoopMines2
pop bx
pop di
RET
reCopyMines EndP
proc fillBoard
sub si,si
@@putDots:
MOV BX,[level1Positions+SI] 
CALL setXY	
MOV CX,BX
MOV DX,BX
MOV AH,06H     
MOV AL,00H   
MOV BH,dotsColor
INT 10H
ADD SI,2
MOV AH,06h
MOV DL ,dot
INT 21h		
CMP SI,doubleNumOfDots
JNE @@putDots	
ret
endp
proc putMines
sub si,si
@@putMines:
MOV BX,[level1Mines+SI]
CALL setXY
MOV CX,BX
MOV DX,BX
MOV AH,06H     
MOV AL,00H    
MOV BH,minesColor
INT 10H
ADD SI,2
MOV AH,06h
MOV DL ,mine
INT 21h 
CMP SI,level1MinesNum
JNE @@putMines	
ret
endp putMines
proc putBlocks
sub si,si
@@putBlocks:
MOV CX,[level1BeginingBlocks+SI]	
MOV DX,[level1EndingBlocks+SI]		
MOV AH,06H    
MOV AL,00H     
MOV BH,borderColor
INT 10H		
ADD SI,2
CMP SI,level1BlocksNum
JNE @@putBlocks
ret
endp
proc waitActionToMove
@@waitAction:
MOV AH,06h
MOV DL,0FFh
INT 21h
ret
waitActionToMove endp
Proc moveRight
@@moveRight2:
call canMoveRight?
cmp dx,1
JE @@dontMoveRight
CALL pmRemove	
INC bmLocX		
CALL search		
CALL putpiyu	
call delay			
MOV AH,06h		
MOV DL,0FFh
INT 21h
JZ @@moveRight2	
cmp al,quit		
je @@exitRight
@@dontMoveRight:
call waitActionToMove
@@return1:
RET
@@exitRight:
jmp exit
moveRight EndP
proc canMoveRight?
sub dx,dx				
MOV BL, bmLocX
mov AX, boardEndingXY
sub al,2
CMP BL, al			
JG 	@@canNotMoveRight	
sub di,di	
@@checkRightBlocks:
mov ax,[level1BeginingBlocks+di]
mov dx,[level1EndingBlocks+di]
sub al,2
cmp BL,al
JLE 	@@ContinueCheckRight
cmp BL,dl
JG	 	@@ContinueCheckRight
cmp bmLocY,ah
JNGE	@@ContinueCheckRight
cmp bmLocY,dh
JNLE 	@@ContinueCheckRight
jmp @@canNotMoveRight
@@ContinueCheckRight:
add di,2
cmp di,level1BlocksNum
jne @@checkRightBlocks
@@canMoveRight:
sub dx,dx
ret
@@canNotMoveRight:
mov dx,1
ret
canMoveRight? endp
Proc moveLeft
@@moveLeft2:
call canMoveLeft?
cmp dx,1
je @@dontMoveLeft
CALL pmRemove
DEC bmLocX
CALL search
CALL putpiyu
CALL delay
MOV AH,06h
MOV DL,0FFh
INT 21h
JZ @@moveLeft2
cmp al,quit
je @@exitLeft
@@dontMoveLeft:
call waitActionToMove
@@return2:
RET
@@exitLeft:
jmp exit
moveLeft EndP
proc canMoveLeft?
sub dx,dx
MOV BL, bmLocX
mov AX, boardBeginingXY
add al,2
cmp bl,al
JL @@canNotMoveLeft
sub di,di
@@checkLeftBlocks:
mov ax,[level1BeginingBlocks+di]
mov dx,[level1EndingBlocks+di]
add dl,1
cmp BL,dl
JG 	@@ContinueCheckLeft
cmp BL,al
JL 	@@ContinueCheckLeft
cmp bmLocY,ah
JNGE	@@ContinueCheckLeft
cmp bmLocY,dh
JNLE 	@@ContinueCheckLeft
jmp @@canNotMoveLeft
@@ContinueCheckLeft:
add di,2
cmp di,level1BlocksNum
jne @@checkLeftBlocks
@@canMoveLeft:
sub dx,dx
ret
@@canNotMoveLeft:
mov dx,1
ret
canMoveLeft? endp
Proc moveUp
@@moveUp2:
call canMoveUp?
cmp dx,1
je @@dontMoveUp
CALL pmRemove
DEC bmLocY
CALL search
CALL putpiyu
CALL delay
MOV AH,06h
MOV DL,0FFh
INT 21h
JZ @@moveUp2
cmp al,quit
je @@exitUp
@@dontMoveUp:
call waitActionToMove
@@return3:
RET
@@exitUp:
jmp exit
moveUp EndP
proc canMoveUp?
sub dx,dx
MOV BH, bmLocY
mov ax, boardBeginingXY
add ah,2
CMP BH, ah
JL @@canNotMoveUp
sub di,di
@@checkUpBlocks:
mov ax,[level1BeginingBlocks+di]
mov dx,[level1EndingBlocks+di]
add dh,1
cmp bmLocY,dh
JG	@@ContinueCheckUp
cmp bmLocY,ah
JL	@@ContinueCheckUp
cmp bmLocX,al
JL	@@ContinueCheckUp
cmp bmLocX,dl
JG 	@@ContinueCheckUp
jmp @@canNotMoveUp
@@ContinueCheckUp:
add di,2
cmp di,level1BlocksNum
jne @@checkUpBlocks
@@canMoveUp:
sub dx,dx
ret
@@canNotMoveUp:
mov dx,1
ret
canMoveUp? endp
Proc moveDown
@@moveDown2:
call canMoveDown?
cmp dx,1
je @@dontMoveDown
CALL pmRemove
INC bmLocY
CALL search
CALL putpiyu
call delay
MOV AH,06h
MOV DL,0FFh
INT 21h
JZ @@moveDown2
cmp al,quit
je @@exitDown
@@dontMoveDown:
call waitActionToMove
@@return:
RET
@@exitDown:
jmp exit
moveDown EndP
proc canMoveDown?
sub dx,dx
MOV BH, bmLocY
mov ax, boardEndingXY
sub ah,2
CMP BH, ah
JG @@canNotMoveDown
sub di,di
@@checkDownBlocks:
mov ax,[level1BeginingBlocks+di]
mov dx,[level1EndingBlocks+di]
sub ah,1
cmp bmLocY,ah
JL	@@ContinueCheckDown
cmp bmLocY,dh
JG	@@ContinueCheckDown
cmp bmLocX,al
JL	@@ContinueCheckDown
cmp bmLocX,dl
JG 	@@ContinueCheckDown
jmp @@canNotMoveDown
@@ContinueCheckDown:
add di,2
cmp di,level1BlocksNum
jne @@checkDownBlocks
@@canMoveDown:	
sub dx,dx
ret
@@canNotMoveDown:
mov dx,1
ret
canMoveDown? endp
proc initialize
sub di,di
@@zeroScore:
mov [score+di],48	
inc di
cmp di, 4
jne @@zeroScore
mov scoreInteger,0		
mov dl,initialbmLocY 
mov dh,initialbmLocX
mov bmLocY,dl
mov bmLocX,dh
mov currentDirection,0	
CALL reCopyPositions	
CALL reCopyMines
ret
initialize endp
Proc changeDirection
@@WAIT:
CMP AL,restart
Je @@restartGame
CMP AL,quit
JE @@exit
CMP AL,right
JE @@changeToRight
CMP AL,left
JE @@changeToLeft
CMP AL,up
JE @@changeToUp
CMP AL,down
JE @@changeToDown
cmp currentDirection,0
je @@stillTheFirstMove
MOV al,currentDirection
JMP @@wait
@@restartGame:
call initialize
jmp restartGame
ret
@@begining:
call initialize
jmp begining
ret
@@stillTheFirstMove:
call waitActionToMove
jmp @@WAIT
@@changeToLeft:
MOV currentDirection,AL
CALL moveLeft
jmp @@WAIT
RET
@@changeToRight:
MOV currentDirection,AL
CALL moveRight
jmp @@WAIT
RET
@@changeToUp:
MOV currentDirection,AL
CALL moveUp
jmp @@WAIT
RET
@@changeToDown:
MOV currentDirection,AL
CALL moveDown
jmp @@WAIT
RET
@@doNth2:
SUB AL,AL
RET
@@exit:
CALL exitArea
MOV AH,4CH
INT 21h
RET
changeDirection EndP
Proc putpiyu
MOV BH,bmLocY
MOV BL,bmLocX
CALL setXY
MOV AH,06H
MOV AL,00H
MOV BH,piyuColor
mov ch,bmLocY	
mov dh,bmLocY
mov cl,bmLocX
mov dl,bmLocX
INT 10H
MOV DL ,piyuFace
MOV AH,06h 
INT 21h
RET
putpiyu EndP
Proc search
SUB DI,DI
MOV BH,bmLocY
MOV BL,bmLocX
@@searchLoopForDots:	
CMP  BX,[level1Positions+DI]	
JE @@eatDot
ADD DI, 2
CMP DI,doubleNumOfDots
JNE @@searchLoopForDots
SUB DI,DI
@@searchLoopForMines:	
CMP  BX,[level1Mines+DI]
JE @@eatMine
ADD DI, 2
CMP DI,level1MinesNum
JNE @@searchLoopForMines
JMP @@doNth 
@@eatDot:
MOV [level1Positions+DI],0
CALL incScore
ret
@@eatMine:
MOV [level1Mines+DI],0
CALL decLives
@@doNth:
RET
RET
search EndP
Proc incScore
MOV DI,4
@@incProcess:
DEC DI
CMP [score+DI],'9'
JE @@zeroCurrent
JMP @@incCurrent
@@zeroCurrent:
MOV [score+DI],'0'
JMP @@incProcess
@@incCurrent:
INC [score+DI]
MOV BX, scoreAreaBeginingXY
add bx,0108h
CALL setXY
MOV DX, offset score
MOV CX, 4
CALL printLine
inc scoreInteger
mov dh,finalScore
cmp scoreInteger,dh
je @@levelComplete
RET
@@levelComplete:
call levelComplete
RET
incScore EndP
Proc decLives
dec lives
cmp lives,48 	
je @@gameOver
call initialize
jmp begining	
@@gameOver:
call gameOver
RET
decLives EndP
Proc pmRemove
MOV BH,bmLocY
MOV BL,bmLocX
CALL setXY
MOV AH,06h
MOV DL,' '	
INT 21h
RET
pmRemove EndP
Proc buildBoard
MOV AH,06H
MOV AL,00H
MOV BH,borderColor
MOV CX , boardBeginingXY   
MOV DX,boardEndingXY    	
INT 10H
MOV AH,06H
MOV AL,00H
MOV BH,brollColor
add cx, 0101h
sub dx, 0101h
INT 10H
mov bx, boardBeginingXY
add bx, 0101h
putbroll:
call setXY
add bx, 0100h
mov dx, offset broll
mov cx, brollL
call printLine
mov ax,boardEndingXY
cmp bh, ah
jl putbroll
mov bh,02h
add bx, 0001h
mov ax,boardEndingXY
cmp bl, al
jl putbroll
RET
buildBoard EndP
Proc printLine param:word
PUSH BX
MOV AH,40H
MOV BX,0
INT 21H
POP BX
RET
printLine EndP
Proc setXY
PUSH BX
MOV AH, 02H 
MOV DX, BX
MOV BH, 00 
INT 10H
POP BX
RET
setXY EndP
Proc cls
MOV AH, 06h
MOV BH, 7
MOV CX, 0000h
MOV DX, 184fh
INT 10h
RET
cls EndP
proc centerBoard
MOV AH,06H
MOV AL,00H
MOV BH,004H
MOV CX,071FH
MOV DX,0E41H
INT 10H
MOV AH,06H
MOV AL,00H
MOV BH,0A0H
MOV CX,0820H
MOV DX,0D40H
INT 10H
MOV BX,CX
add BX,0101h
CALL setXY
ret
centerBoard endp
Proc exitArea
call centerBoard
MOV DX, offset exitMsg
MOV CX, exitMsgLen
CALL printLine
INC BH
INC BH
CALL setXY
MOV DX, offset DoneByMsg
MOV CX, DoneByMsgLen
CALL printLine
RET
exitArea EndP
proc levelComplete
call centerBoard
MOV BX,CX
add BX,0203h
CALL setXY
MOV DX, offset levelCompleteMsg
MOV CX, levelCompleteMsgLen
CALL printLine
add BX,0200h
CALL setXY
MOV DX, offset pressAnyKeyMsg
MOV CX, pressAnyKeyMsgLen
CALL printLine
sub al,al
@@pressAnyKey:
mov ah,06h
mov dl,0FFh
int 21h
jz @@pressAnyKey
cmp al, quit
je @@exitGame
call initialize
jmp restartGame
RET
@@exitGame:
jmp exit
ret
levelComplete endp
proc gameOver
call centerBoard
MOV BX,CX
add BX,0203h
CALL setXY
MOV DX, offset gameOverMsg
MOV CX, gameOverMsgLen
CALL printLine
add BX,0200h
CALL setXY
MOV DX, offset pressAnyKeyMsg
MOV CX, pressAnyKeyMsgLen
CALL printLine
sub al,al
@@pressAnyKey2:
mov ah,06h
mov dl,0FFh
int 21h
jz @@pressAnyKey2
cmp al, quit
je @@exitGame2
call initialize
jmp restartGame
RET
@@exitGame2:
jmp exit
ret
gameOver endp
Proc buildHelpArea
MOV AH,06H
MOV AL,00H
MOV BH,helpAreaColor
MOV CX,helpAreaBeginingXY
MOV DX,helpAreaEndingXY
INT 10H
MOV BX,helpAreaBeginingXY
add bx, 0101h
CALL setXY
MOV DX, offset helpTitle
MOV CX, 4
CALL printLine
ADD BH,2
CALL setXY
MOV DX, offset help1
MOV CX, help1Len
CALL printLine
ADD BH,1
CALL setXY
MOV DX, offset help2
MOV CX, help2Len
CALL printLine
ADD BH,1
CALL setXY
MOV DX, offset help3
MOV CX, help3Len
CALL printLine
ADD BH,1
CALL setXY
MOV DX, offset help4
MOV CX, help4Len
CALL printLine
RET
buildHelpArea EndP
Proc buildScoreArea
MOV AH,06H
MOV AL,00H
MOV BH,4FH
MOV CX,scoreAreaBeginingXY
MOV DX,scoreAreaEndingXY
INT 10H
MOV BX, cx
add bx,0101h
CALL setXY
MOV DX, offset scoreMsg
MOV CX, scoreMsgLen
CALL printLine
RET
buildScoreArea EndP
Proc buildLivesArea
MOV AH,06H
MOV AL,00H
MOV BH,3EH
MOV CX,livesAreaBeginingXY
MOV DX,livesAreaEndingXY
INT 10H
MOV BX, cx
add bx,0101h
CALL setXY
MOV DX, offset livesMsg
MOV CX, livesMsgLen
CALL printLine
mov ax,48
@@putLivesFaces:
inc ax
mov dx, offset  piyuFace
mov cx,1
push ax
CALL printLine
pop ax
cmp al,lives
jl @@putLivesFaces
RET
buildLivesArea EndP
delay Proc
MOV     AH,2CH
INT    	21h  
mov [si],dl	
@@myDelay:
INT 21h
sub dl,[si]
cmp dl,piyuSpeed
jb @@myDelay
RET
delay EndP
Proc oneSecond
PUSH 	CX BX AX DX
MOV     BH,01h
MOV     AH,2CH
INT    	21h
cmp 	t1,0		
jne 	@@Label1	
MOV     td,0		
mov 	t1,dh		
MOV    	t2,DH
@@Label1:
INT     21h		
SUB     DH,t2
CMP     DH,BH		
JB  	@@Label2	
mov 	td,1		
mov 	t2,0		
mov 	t1,0
@@Label2:
POP 	DX AX BX CX
RET
oneSecond EndP
End