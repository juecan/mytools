## Config Gitlab

### Config E-mail

	For Gmail: Save smtp_settings.rb.gmail to opt/gitlab/embedded/service/gitlab-rails/config/initializers/smtp_settings.rb

### Backup

	For gitlab: Save gitlab-backup.sh to /opt/gitlab-backup.sh
	For crond job:
		Save crontab to /etc/crontab
		systemctl restart crond

