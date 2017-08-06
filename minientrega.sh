#! /bin/bash

#ID_PRACTICA=$1

# Comprobamos que se llama con un único argumento
if [ $# != 1 ]
 then
	echo "minientrega.sh: Error(EX_USAGE), uso incorrecto del mandato. "Success""
	echo "minientrega.sh+ <<el script ha  sido  invocado  sin  argumentos  o  con  mas  de  uno>>"
	exit  64
fi

# Comprobamos que se llama pidiendo ayuda
if [ $1 = "-h" ] || [ $1 = "--help" ]
 then
	echo "minientrega.sh: Uso: $0 {nombre_archivo} o -h/--help para la ayuda"
	echo "minientrega.sh: Copia archivos los ficheros apropiados de un directorio del usuario a otro que es el de entrega"
	exit 0
fi
# Comprobamos que .......

if [ ! -e $MINIENTREGA_CONF ]
  then
    exit 64
fi

if [ ! -d $MINIENTREGA_CONF ]
  then
    exit 64
fi

if [ ! -r $MINIENTREGA_CONF ]
  then
    exit 64
fi
if [ ! -e $MINIENTREGA_CONF/$1 ]
  then
    exit 64
fi

if [ ! -r $MINIENTREGA_CONF/$1 ]
  then
    exit 64
fi


source ${MINIENTREGA_CONF}/$1 || exit 64

var1_ID=$MINIENTREGA_FECHALIMITE
var2_ID=$MINIENTREGA_DESTINO
var3_ID=$MINIENTREGA_FICHEROS

for i in {1..3}; do
   v="var${i}_ID"
   if [ -n "${!v}" ]; then        # <-- this expands to varX_ID
      continue
   else
      exit 64
   fi
done

ANO=`date +%Y`
MES=`date +%m`
DIA=`date +%d`

fecha_limite=$(cat $MINIENTREGA_CONF/$1 | grep "MINIENTREGA_FECHALIMITE" | cut -d '"' -f 2)

ANO_limite=$(expr substr "$fecha_limite" 1 4)
MES_limite=$(expr substr "$fecha_limite" 6 2)
DIA_limite=$(expr substr "$fecha_limite" 9 2)

if [ $MES_limite -lt 1 ] || [ $DIA_limite -lt 1 ] || [ $MES_limite -gt 12 ]
  then
    exit 65
fi

if [ $MES_limite = 1 ] || [ $MES_limite = 3 ] || [ $MES_limite = 5 ] || [ $MES_limite = 7 ] || [ $MES_limite = 8 ] || [ $MES_limite = 10 ] || [ $MES_limite = 12 ]
  then
    if [ $DIA_limite  -gt 31 ]
      then
        exit 65
    fi
fi

if [ $MES_limite = 4 ] || [ $MES_limite = 6 ] || [ $MES_limite = 9 ] || [ $MES_limite = 11 ]
then
  if [ $DIA_limite  -gt 30 ]
    then
      exit 65
  fi
fi

if [ $MES_limite = 2 ]
then
  if [ $DIA_limite  -gt 28 ]
    then
      exit 65
  fi
fi


if [ $ANO -gt $ANO_limite ]
	then
		exit 65
fi
if [ $ANO -eq $ANO_limite ]
	then
		if [ $MES -gt $MES_limite ]
			then
					exit 65
		elif [ $MES -eq $MES_limite ]
			then
				if [ $DIA -gt $DIA_limite ]
				    then
							exit 65
				fi
		fi
fi

for ficheros in $MINIENTREGA_FICHEROS
do
	if [ ! -e $ficheros ]
	then
  	exit 66
	fi
  if [ ! -r $ficheros ]
	then
  	exit 66
	fi
done

# Copiamos los archivos
#
# if [ ! -w $MINIENTREGA_DESTINO ]
# then
#   exit 73
# fi
#
# if [ ! -w $destino ]
# then
#   exit 73
# fi

mkdir -p $MINIENTREGA_DESTINO || exit 73
destino=$MINIENTREGA_DESTINO/${USER}
mkdir -p $destino || exit 73

cp $MINIENTREGA_FICHEROS $MINIENTREGA_DESTINO/$USER

exit 0
