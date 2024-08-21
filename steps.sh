echo "creating schema script"
bash create\ table.sh schema.csv

echo "creating schema"
mysql -u root -p battery < schema.sql

echo "extracting data"
python3 charging.py

echo "loading data"
mysql --local-infile=1 -u root -p battery < load.sql

sudo rm /var/lib/mysql-files/final.csv

echo "cleaning data"
mysql -u root -p battery < clean.sql

sudo mv /var/lib/mysql-files/final.csv final.csv
sudo chmod ugo+rw final.csv

# mongoimport -d battery -c charging --file charging.json --drop -v
mongoimport -d battery -c charging --file final.json --drop -v

