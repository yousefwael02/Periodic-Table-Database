#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    PRINT_ELEMENT $1
  fi
}

PRINT_ELEMENT() {
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$INPUT' OR name = '$INPUT'") 
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$INPUT'")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = '$ATOMIC_NUMBER'")
    ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed 's/ //')
    NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number = '$ATOMIC_NUMBER'") | sed 's/ //g')
    SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number = '$ATOMIC_NUMBER'") | sed 's/ //g')
    TYPE=$(echo $($PSQL "SELECT type FROM types WHERE type_id = '$TYPE_ID'") | sed 's/ //g')
    MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = '$ATOMIC_NUMBER'") | sed 's/ //g')
    MELTING_POINT=$(echo $($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = '$ATOMIC_NUMBER'") | sed 's/ //g')
    BOILING_POINT=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = '$ATOMIC_NUMBER'") | sed 's/ //g')
    echo -e "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

MAIN_MENU $1