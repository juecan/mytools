## 配置 GITLAB 邮件

### /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml

	email_from: Git@openvox.cn

### /opt/gitlab/embedded/service/gitlab-rails/config/environments/production.rb

	config.action_mailer.delivery_method = :smtp

### /opt/gitlab/embedded/service/gitlab-rails/config/initializers

	smtp_settings.rb

	if Rails.env.production?
		Gitlab::Application.config.action_mailer.delivery_method = :smtp

		ActionMailer::Base.smtp_settings = {
			address: "email.server.com",
			port: 456,
			user_name: "smtp",
			password: "123456",
			domain: "gitlab.company.com",
			authentication: :login,
			enable_starttls_auto: true
		}
	end