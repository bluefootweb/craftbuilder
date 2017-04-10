#!/bin/sh


cd $PWD

read -p "Enter a site username : " username
git clone buddy@repo.bluefoot.com:bluefoot/dev $username


cd $username

rm -rf craft/app

mkdir tmp
cd tmp
curl -L http://buildwithcraft.com/latest.zip?accept_license=yes -o Craft.zip
unzip Craft.zip
rm -rf ../craft/app
mv craft/app ../craft
cd ..
rm -rf tmp
rm -rf Craft-*
rm -rf __MACOSX

cd craft/plugins

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

find . -type f -name 'buddy.yml' -exec sed -i '' s/dev/$username/ {} +

npm install

bower install

mv *.sublime-project $username.sublime-project
mv *.sublime-workspace $username.sublime-workspace

rm -rf .git
git init
git add .
git commit -m 'Initial Commit'
curl -d '{"name":"'$username'","display_name":"'$username'"}' -H "Authorization: Bearer 63dfe7d5-ffb2-4221-a0dc-f092cfe7da62" -H "Content-Type: application/json" https://repo.bluefoot.com/api/workspaces/bluefoot/projects
git remote add origin https://repo.bluefoot.com/bluefoot/$username
git push origin master



open http://$username.dev/admin
