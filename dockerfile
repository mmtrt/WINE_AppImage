FROM archlinux/base

COPY . /srv/wineappimage

WORKDIR /srv/wineappimage
RUN /srv/wineappimage/deploy.sh 
