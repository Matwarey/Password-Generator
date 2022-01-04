@echo off
title Winpass
setlocal enabledelayedexpansion
:PassGen
cls
setlocal
set "set[1]=ABCDEFGHIJKLMNOPQRSTUVWXYZ"  &  set "len[1]=26"  &  set "num[1]=0"
set "set[2]=abcdefghijklmnopqrstuvwxyz"  &  set "len[2]=26"  &  set "num[2]=0"
set "set[3]=0123456789"                  &  set "len[3]=10"  &  set "num[3]=0"
set "set[4]=~!@#$%%"                     &  set "len[4]=6"   &  set "num[4]=0"
set "set[5]=~-=*_?"                      &  set "len[4]=6"   &  set "num[4]=0"

rem Create a list of 128 random numbers between 1 and 4;
rem the condition is that it must be at least one digit of each one

rem Initialize the list with 54 letters/numbers
set "list="
for /L %%i in (1,1,54) do (
   set /A rnd=!random! %% 4 + 1
   set "list=!list!!rnd! "
   set /A num[!rnd!]+=1
)

:checkList
rem Check that all digits appear in the list at least one time
set /A mul=num[1]*num[2]*num[3]*num[4]
if %mul% neq 0 goto listOK

   rem Change elements in the list until fulfill the condition

   rem Remove first element from list
   set /A num[%list:~0,1%]-=1
   set "list=%list:~2%"

   rem Insert new element at end of list
   set /A rnd=%random% %% 4 + 1
   set "list=%list%%rnd% "
   set /A num[%rnd%]+=1

goto checkList
:listOK

rem Generate the password with the sets indicated by the numbers in the list
set "RndAlphaNum="
set randompassname=Password%random%%2
for %%a in (%list%) do (
   set /A rnd=!random! %% len[%%a]
   for %%r in (!rnd!) do set "RndAlphaNum=!RndAlphaNum!!set[%%a]:~%%r,1!"
)
goto A
:A
>%randompassname%.txt echo !RndAlphaNum!
cls
madplay -Q ping.mp3
echo Password generated: !RndAlphaNum!
echo Do you want a another random password?
echo Y = Yes - N = No
set /p choice=Answer:
if "%choice%" == "y" goto PassGen
if "%choice%" == "n" goto Exit
if "%choice%" == "Y" goto PassGen
if "%choice%" == "N" goto Exit
goto A
:Exit
cls
echo Goodbye :(
timeout /t 1 >nul
exit
