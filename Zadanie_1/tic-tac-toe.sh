#!/bin/bash

board=( "0", "0", "0", "0", "0", "0", "0", "0", "0")

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
	echo
        echo "X start the game"

        write_board
}

function player_vs_player
{
 start_info

 while true; do

  player "X"

  player "O"

 done
}

function player() {
  x=0;
  while true; do

   echo "$@ turn"
   echo "Choose number from 1 to 9:"
   read x
    if [ $x -ge 1 ] && [ $x -le 9 ];
    then
     if [ ${board[$[x-1]]/,/} == "0" ];
     then
      board[$[x-1]]="$@"
      write_board
      check_win_draw
      break
     fi
     echo "This field is already filled, try again"
     continue
    fi

    echo "You choose wrong number or wrong letter, try again"

  done 
}

function game {
 while true; do
        player_vs_player
 done
}

game