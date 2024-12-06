git init
ssh -T git@github.com
git remote add origin git@github.com:Yuhi-Sato/isucon12-q-2.git 
cat << EOF >> .gitignore
php
java
node
nodejs
python
ruby
perl
rust
/webapp/sql/admin/90_data.sql
/webapp/tenant_db/1.db
/initial_data/1.db
/tool-config/alp/notify-slack.toml
/tool-config/slow-query/notify-slack.toml
EOF
make extract-queries
git add .
git commit -m 'first commit'
git branch -M main
git push origin main
