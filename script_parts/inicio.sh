#!/bin/bash

set -e
USUARIO=$1
DIR_PADRAO="/home/$USUARIO"

echo ""
echo "Executar atualização do sistema operacional? S ou N"
read ATUALIZAR

if [ "$ATUALIZAR" == "S" ];
then
	echo "Atualizando o sistema"
	apt-get update
	apt-get upgrade --yes

	if [ $UBUNTU == true ]; then
		echo "Instalando lingua português"
		apt-get install language-pack-pt --yes
		locale-gen pt_BR.UTF-8
		update-locale LANG=pt_BR.UTF-8
	fi
	if [ $DEBIAN == true ]; then
		apg-get install upstart --yes
	fi
fi

echo ""
echo "Confirma o usuario: $USUARIO ? S ou N"
echo "Se não existir será criado um novo usuário"
read CONFIRMAR

if [ "$CONFIRMAR" == "S" ]; then
	if id -u $USUARIO >/dev/null 2>&1; then
		echo "Usuário ja existe, passando adiante: $USUARIO"
	else
		echo "Criando usuário"
		adduser --system --home $DIR_PADRAO --group --shell /bin/bash $USUARIO
	fi
else
	echo "Usuário não especificado, abortando"
	exit -1
fi


