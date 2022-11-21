cd $1/images/nginx
docker build -t nginx-hl-fabric .
cd $1/images/shell-cmd-utils
docker build -t shell-cmd-utils-hl-fabric .