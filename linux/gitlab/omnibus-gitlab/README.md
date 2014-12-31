## Config Gitlab

	检查 GITLAB: gitlab-rake gitlab:check
	gitlabctl start|stop|status

### BUG

	gitlab-7.4.3 BUG：备份文件中如有空项目，恢复时会失败

### Config E-mail

	For Gmail: Save smtp_settings.rb.gmail to opt/gitlab/embedded/service/gitlab-rails/config/initializers/smtp_settings.rb

### Backup

	For gitlab: Save gitlab-backup.sh to /opt/gitlab-backup.sh
	For crond job:
		Save crontab to /etc/crontab
		systemctl restart crond
