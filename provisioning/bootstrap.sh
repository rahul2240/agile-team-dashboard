#!/usr/bin/env bash

echo 'solver.allowVendorChange = true' >> /etc/zypp/zypp.conf

# packages
zypper -q ref
zypper -q -n in -t pattern devel_basis
zypper -q -n in libopenssl-devel readline-devel \
    postgresql94-server postgresql94-devel libxml2-devel libxslt-devel

# rbenv
# Based on https://en.opensuse.org/User:Tsu2/Install_Ruby#When_do_I_need_to_install_Ruby.3F
zypper -q -n in automake gdbm-devel libyaml-devel ncurses-devel readline-devel zlib-devel

su - vagrant -c "git clone git://github.com/sstephenson/rbenv.git .rbenv"
su - vagrant -c "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
su - vagrant -c "source /etc/profile"

su - vagrant -c "rbenv install 2.4.0"
su - vagrant -c "rbenv rehash"
su - vagrant -c "rbenv global 2.4.0"

# postgresql
echo -e "\nsetting up postgresl...\n"
systemctl start postgresql
systemctl enable postgresql

sed -i 's/local.*all.*all.*peer/local    all         all                               trust/' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/host.*all.*all.*32.*ident/host    all         all          127\.0\.0\.1\/32         trust/' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/host.*all.*all.*128.*ident/host    all         all         ::1\/128               trust/' /var/lib/pgsql/data/pg_hba.conf

systemctl restart postgresql

echo -e "\nsetting up ruby...\n"
su - vagrant -c "ln -sf /usr/bin/ruby.ruby2.4 /home/vagrant/bin/ruby"

echo -e "\ndisabling versioned gem binary names...\n"
echo 'install: --no-format-executable' >> /etc/gemrc

echo -e "\ninstalling your bundle...\n"
su - vagrant -c "gem install bundler"
su - vagrant -c "bundle config build.nokogiri '--use-system-libraries'"
su - vagrant -c "cd /vagrant/; bundle install"

# Configure the database if it isn't
if [ ! -f /vagrant/config/database.yml ] && [ -f /vagrant/config/database.yml.example ]; then
  echo -e "\nSetting up your database from config/database.yml...\n"
  cp /vagrant/config/database.yml.example /vagrant/config/database.yml
  su - postgres -c 'psql -c "create role bsteam with superuser createdb login;";'
  su - postgres -c "psql -c \"alter role bsteam with password 'opensuse';\";"

  su - vagrant -c "cd /vagrant/; bundle exec rake db:setup"
else
  echo -e "\nnWARNING: You have already configured your database in config/database.yml."
  echo -e "WARNING: Please make sure this configuration works in this vagrant box!\n\n"
fi

echo -e "\nProvisioning of your TEAM DASHBOARD rails app done!"
echo -e "To start your development TEAM DASHBOARD run: vagrant exec rails s -b 0.0.0.0\n"
