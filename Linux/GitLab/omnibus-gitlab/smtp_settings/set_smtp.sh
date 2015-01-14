#!/bin/bash
# omnibus gitlab

# 配置访问 GITLAB 的地址
sed -i "s/external_url 'localhost'/external_url 'http:\/\/172.16.0.223'/g" /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure

# 配置 GITLAB 邮件
sed -i 's/email_from: Git@openvox.cn/email_from: gitlab@172.16.0.223/g' /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
#sed -n '/email_from: gitlab@172.16.0.223/p' /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
sed -i 's/config.action_mailer.delivery_method = :sendmail/config.action_mailer.delivery_method = :smtp/g' /opt/gitlab/embedded/service/gitlab-rails/config/environments/production.rb
cp smtp_settings.rb.openvox /opt/gitlab/embedded/service/gitlab-rails/config/initializers/smtp_settings.rb
gitlab-ctl restart