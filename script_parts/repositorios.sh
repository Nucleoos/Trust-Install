#!/bin/bash

cd $DIR_PADRAO

echo "Verificando server"
if [ -d server/ ]
then
	cd server
	brz pull
	cd ..
else
	bzr checkout --lightweight lp:ocb-server server
fi

echo "Verificando addons"
if [ -d addons/ ]
then
	cd addons
	bzr pull
	cd ..
else
	bzr checkout --lightweight lp:ocb-addons addons
fi

echo "Verificando web"
if [ -d web/ ]
then
	cd web
	bzr pull
	cd ..
else
	bzr checkout --lightweight lp:ocb-web web
fi

echo "Verificando nfe"
if [ -d nfe ]
then
	cd nfe
	git pull
	cd ..
else
	git clone https://github.com/openerpbrasil-fiscal/nfe.git nfe
fi

echo "Verificando core_br"
if [ -d core_br ]
then
	cd core_br
	git pull
	cd ..
else
	git clone https://github.com/openerpbrasil-fiscal/l10n_br_core.git core_br
	cd core-br
	git checkout 7.0
	cd ..
fi

echo "Verificando data_br"
if [ -d data_br ]
then
	cd data_br
	bzr pull
	cd ..
else
	bzr checkout --lightweight lp:brazilian-localization-data data_br
fi

echo "Verificando account_payment"
if [ -d account_payment ]
then
	cd account_payment
	bzr update
	cd ..
else
	bzr checkout --lightweight lp:account-payment/7.0 account_payment
fi

echo "Verificando account_payment_extension"
if [ -d account_payment_extension ]
then
	cd account_payment_extension
	git update
	cd ..
else
	git clone https://github.com/akretion/l10n_br_account_payment_extension.git account_payment_extension
fi

echo "Verificando fiscal_rules"
if [ -d fiscal_rules ]
then
	cd fiscal_rules
	bzr update
	cd ..
else
	bzr checkout --lightweight lp:openerp-fiscal-rules fiscal_rules
fi
