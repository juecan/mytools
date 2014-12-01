## 配置 GITLAB 邮件

### /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml

	email_from: Git@openvox.cn

### /opt/gitlab/embedded/service/gitlab-rails/config/environments/production.rb

	config.action_mailer.delivery_method = :smtp

### /opt/gitlab/embedded/service/gitlab-rails/config/initializers

	smtp_settings.rb
