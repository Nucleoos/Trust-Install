FROM debian:7

MAINTAINER	Mackilem Van der Laan <mack.vdl@gmail.com> \
		Danimar Ribeiro <danimaribeiro@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

	##### Dependências #####

ADD apt-requirements /opt/sources/
ADD pip-requirements /opt/sources/
ADD http://ufpr.dl.sourceforge.net/project/wkhtmltopdf/0.12.2.1/wkhtmltox-0.12.2.1_linux-wheezy-amd64.deb /opt/sources/wkhtmltox.deb

WORKDIR /opt/sources/
RUN apt-get update && apt-get install -y python-dev nginx supervisor
RUN apt-get install -y --no-install-recommends $(grep -v '^#' apt-requirements)

RUN pip install -r pip-requirements && \
    dpkg -i wkhtmltox.deb

	##### Repositórios #####

ADD https://github.com/OCA/OCB/archive/8.0.tar.gz /opt/odoo/OCB.tar.gz
ADD https://github.com/Trust-Code/l10n-brazil/archive/8.0.zip /opt/odoo/l10n-brazil.zip
ADD https://github.com/Trust-Code/account-fiscal-rule/archive/8.0.zip /opt/odoo/account-fiscal-rule.zip
ADD https://github.com/Trust-Code/server-tools/archive/8.0.zip /opt/odoo/server-tools.zip
ADD https://github.com/Trust-Code/odoo-brazil-eletronic-documents/archive/8.0.zip /opt/odoo/odoo-brazil-eletronic-documents.zip
ADD https://github.com/Trust-Code/trust-addons/archive/8.0.zip /opt/odoo/trust-addons.zip

RUN apt-get install -y unzip

WORKDIR /opt/odoo/
RUN tar -zxvf OCB.tar.gz && rm OCB.tar.gz && mv OCB-8.0 OCB
RUN unzip l10n-brazil.zip && rm l10n-brazil.zip && mv l10n-brazil-8.0 l10n-brazil
RUN unzip account-fiscal-rule.zip && rm account-fiscal-rule.zip && mv account-fiscal-rule-8.0 account-fiscal-rule
RUN unzip server-tools.zip && rm server-tools.zip && mv server-tools-8.0 server-tools
RUN unzip odoo-brazil-eletronic-documents.zip && rm odoo-brazil-eletronic-documents.zip && mv odoo-brazil-eletronic-documents-8.0 odoo-brazil-eletronic-documents
RUN unzip trust-addons.zip && rm trust-addons.zip && mv trust-addons-8.0 trust-addons


	##### Configurações Odoo #####

ADD conf/odoo.conf /etc/odoo/
ADD conf/nginx.conf /etc/nginx/
ADD conf/supervisord.conf /etc/supervisor/supervisord.conf
#mkdir -p /var/log/supervisor


RUN mkdir /var/log/odoo && \
    mkdir /opt/dados && \
    touch /var/log/odoo/odoo.log && \
    touch /var/run/odoo.pid && \
    ln -s /opt/odoo/OCB/openerp-server /usr/bin/odoo-server && \
    useradd --system --home /opt/odoo --shell /bin/bash odoo && \
    chown -R odoo:odoo /opt/odoo && \
    chown -R odoo:odoo /etc/odoo/odoo.conf && \
    chown -R odoo:odoo /opt/dados && \
    chown -R odoo:odoo /var/log/odoo && \
    chown odoo:odoo /var/run/odoo.pid

	##### Limpeza da Instalação #####

RUN apt-get --purge remove -y python-pip && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /opt/sources/

	##### Finalização do Container #####

VOLUME ["/opt/", "/etc/odoo"]
EXPOSE 80 8090
CMD ["/usr/bin/supervisord"]
