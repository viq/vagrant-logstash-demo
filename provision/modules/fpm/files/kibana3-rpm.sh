#!/bin/bash -x

#install pre-reqs
#yum -y install java-1.7.0-openjdk

PKG_VERSION=$(date '+%Y%m%d%H%M')
BUILD_DIR=/usr/src/kibana3

mkdir -p $BUILD_DIR
cd $BUILD_DIR

wget https://github.com/elasticsearch/kibana/archive/master.tar.gz
mkdir -p $BUILD_DIR/build/usr/share
tar xvzf master
mv kibana-master $BUILD_DIR/build/usr/share/kibana3

cat << 'EOF' > post-install
#!/bin/sh
chown -R www-data:www-data /usr/share/kibana3
EOF

cd /vagrant/packages/rpm
fpm -s dir -t rpm \
  --architecture all \
  -d 'httpd' \
  -n kibana3 \
  -v ${PKG_VERSION} \
  --prefix / \
  --after-install $BUILD_DIR/post-install \
  -C $BUILD_DIR/build usr
