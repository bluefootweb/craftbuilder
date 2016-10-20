#!/bin/sh


cd $PWD

read -p "Enter a site username : " username
git clone git@github.com:bluefootweb/bluefoot-dev.git $username

cd $username/craft

./github-downloader.sh https://github.com/pixelandtonic/Craft-Release/tree/master/app

cd plugins

./github-downloader.sh https://github.com/selvinortiz/craft.patrol/tree/master/patrol
./github-downloader.sh https://github.com/fruitstudios/Icons/tree/master/fruiticons
./github-downloader.sh https://github.com/engram-design/ImageResizer/tree/master/imageresizer
./github-downloader.sh https://github.com/supercool/Pimp-My-Matrix/tree/master/pimpmymatrix
./github-downloader.sh https://github.com/engram-design/SuperTable/tree/master/supertable
./github-downloader.sh https://github.com/lindseydiloreto/craft-cpcss/tree/master/cpcss
./github-downloader.sh https://github.com/lindseydiloreto/craft-cpjs/tree/master/cpjs
./github-downloader.sh https://github.com/Staplegun-US/craft-video-embed-utility/tree/master/videoembedutility
./github-downloader.sh https://github.com/jmuspratt/craft-fieldguide/tree/master/fieldguide
./github-downloader.sh https://github.com/engram-design/CPNav/tree/master/cpnav
./github-downloader.sh https://github.com/taylordaughtry/Craft-Brief/tree/master/brief
./github-downloader.sh https://github.com/benjamminf/craft-embedded-assets/tree/master/embeddedassets
./github-downloader.sh https://github.com/TopShelfCraft/Hue/tree/master/hue
./github-downloader.sh https://github.com/benjamminf/craft-neo/tree/master/neo
./github-downloader.sh https://github.com/benjamminf/craft-relabel/tree/master/relabel
./github-downloader.sh https://github.com/benjamminf/craft-quick-field
./github-downloader.sh https://github.com/mmikkel/Reasons-Craft/tree/master/reasons
./github-downloader.sh https://github.com/mmikkel/CpSortableCustomColumns-Craft/tree/master/cpsortcols
./github-downloader.sh https://github.com/mmikkel/CpFieldLinks-Craft/tree/master/cpfieldlinks

wait

rm -rf onedashboard
git clone https://github.com/boboldehampsink/onedashboard

rm -rf trimmer
git clone https://github.com/rkingon/Craft-Plugin--Trimmer trimmer

rm -rf amnav
git clone https://github.com/am-impact/amnav

rm -rf antiallentries
git clone https://github.com/Harry-Harrison/antiallentries

rm -rf automin
git clone https://github.com/aelvan/AutoMin-Craft automin

rm -rf seomatic
git clone https://github.com/nystudio107/seomatic

rm -rf columnwidth
git clone https://github.com/encryptdesigns/Craft-Column-Widths columnwidth

rm -rf amforms
git clone https://github.com/am-impact/amforms

rm -rf simplemap
git clone https://github.com/ethercreative/SimpleMap simplemap

find . -name .git -exec rm -rf {} \;

cd ../..

tablename=$username'_cms'

mysql.server restart
  
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS $tablename"
mysql -u root -proot $tablename < bluefoot-dev.sql

mysql.server restart

rm bluefoot-dev.sql

cd craft

mkdir storage

cd config

find . -type f -name 'db.php' -exec sed -i '' s/bluefootuser/$username/ {} +
cd ../..

npm install

bower install

rm -rf .git
git init
git add .
git commit -m 'Initial Commit'
git remote add origin https://65.40.73.219/bluefoot/$username
git push origin master

mv *.sublime-project $username.sublime-project
mv *.sublime-workspace $username.sublime-workspace

open http://$username.dev/admin
