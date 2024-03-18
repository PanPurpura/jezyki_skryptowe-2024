#!/bin/bash

board=( "0", "0", "0", "0", "0", "0", "0", "0", "0")
tPlayer="X"

function write_board
{
 x=0;
 echo
 while [ $x -lt 9 ]; do
 echo "-------"
 echo "|${board[$[x]]/,/}|${board[$[x+1]]/,/}|${board[$[x+2]]/,/}|"
 x=$[x+3]
 done
 echo "-------"
 echo
}

function check_win_draw
{
 x=0;
 while [ $x -lt 9 ]; do
  if [ ${board[$[x]]/,/} != "0" ] && [ ${board[$[x]]/,/} == ${board[$[x+1]]/,/} ] && [ ${board[$[x+1]]/,/} == ${board[$[x+2]]/,/} ];
  then
   echo "${board[$[x]]/,/} win the game!"
   sleep 2
   exit 0
  fi
  x=$[x+3]
 done

 x=0
 y=0
 while [ $x -lt 9 ]; do
  if [ ${board[$[y]]/,/} != "0" ] && [ ${board[$[y]]/,/} == ${board[$[y+3]]/,/}  ] && [ ${board[$[y+3]]/,/} == ${board[$[y+6]]/,/} ];
  then
   echo "${board[$[y]]/,/} win the game!"
   sleep 2
   exit 0
  fi
 y=$[y+1]
 x=$[x+3]
 done

 if [ ${board[0]/,/} != "0" ] && [ ${board[0]/,/} == ${board[4]/,/} ] && [ ${board[4]/,/} == ${board[8]/,/} ];
 then
  echo "${board[0]/,/} win the game!"
  sleep 2
  exit 0
 fi

 if [ ${board[2]/,/} != "0" ] && [ ${board[2]/,/} == ${board[4]/,/} ] && [ ${board[4]/,/} == ${board[6]/,/} ];
 then
  echo "${board[2]/,/} win the game!"
  sleep 2
  exit 0
 fi

 x=0
 while [ $x -lt 9 ]; do
 if [ ${board[$[x]]/,/} == "0" ];
 then
  break
 fi
 x=$[x+1]
 done

 if [ $x -eq 9 ];
 then
  echo "Draw!"
  sleep 2
  exit 0
 fi
}

function start_info {

        echo "The game start now"
        echo
	echo "Board has 9 fields, choose number from 1 to 9"
        echo "s - save, l - load, e - exit"
	echo
        echo "X start the game"

        write_board
}

function load 
{
        file="zapis.txt"
        i=1
        while read line; do
        if [ $i -eq 1 ];
        then
           tPlayer=$line
           i=$[i+1]
           continue
        fi
        board[i-2]=$line
        i=$[i+1]
        done < $file
}

function save
{
 echo "$tPlayer" > "zapis.txt"
 x=0;
 while [ $x -lt 9 ]; do
 echo "${board[$[x]]/,/}" >> "zapis.txt"
 x=$[x+1]
 done
}

function player_vs_player
{
 start_info

 while true; do

  player $tPlayer

  player $tPlayer

 done
}

function player_vs_PC {

 start_info

 while true; do
                
  player $tPlayer

  pc

 done
}

function player() {
  x=0;
  while true; do

   echo "$@ turn"
   echo "Choose number from 1 to 9:"
   read x
    if [ $x == "s" ];
    then
        save
        echo "Game saved"
        continue
    elif [ $x == "l" ];
    then
        load
        echo "Game loaded"
        write_board
        break;
    elif [ $x == "e" ];
    then
        echo "Exit the game"
        sleep 2
        exit 0
    fi
    if [ $x -ge 1 ] && [ $x -le 9 ];
    then
     if [ ${board[$[x-1]]/,/} == "0" ];
     then
      board[$[x-1]]="$@"
      write_board
      check_win_draw
      if [ $tPlayer == "X" ];
      then
        tPlayer="O"
      elif [ $tPlayer == "O" ];
      then
        tPlayer="X"
      fi
      break
     fi
     echo "This field is already filled, try again"
     continue
    fi

    echo "You choose wrong number or wrong letter, try again"

  done 
}

function pc() {
        while true; do
                echo "PC turn"
                field=$[$[$RANDOM % 9]+1]
                if [ ${board[$[field-1]]/,/} == "0" ]
                then
                 board[$[field-1]]="O"
                 write_board
                 check_win_draw
                 tPlayer="X"
                 break
                fi
        done
}

function game {
 while true; do
        x="u";
        echo "p - play with the player, c - play with computer"
        read x
        if [ $x == "p" ];
        then
                player_vs_player
        elif [ $x == "c" ];
        then
                player_vs_PC
        fi

        echo "You need to choose p or c!"
 done
}

game