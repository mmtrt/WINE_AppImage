FROM archlinux/base

COPY . /srv/wineappimage

WORKDIR /srv/wineappimage
RUN useradd -m archie
RUN /srv/wineappimage/deploy.sh 
