## omnibus-gitlab

### 安装 omnibus-gitlab

	rpm -Uvh gitlab-7.4.3_omnibus.1-1.el6.x86_64.rpm
	vi /etc/gitlab/gitlab.rb
		external_url 'http://172.16.0.222'
	gitlab-ctl reconfigure
	gitlab-ctl restart
	
### 使用

	检查 GITLAB: gitlab-rake gitlab:check
	gitlabctl start|stop|status

### BUG

	gitlab-7.4.3 BUG：备份文件中如有空项目，恢复时会失败

### GITLAB 备份

	将 gitlab-backup.sh 保存为 /opt/gitlab-backup.sh
	添加 crond 定时任务: 
		echo "30 23 * * * root /opt/gitlab-backup.sh" >> /etc/crontab

### GITLAB 恢复备份的文件

	rm -rf /var/opt/gitlab/backups/*
	cp 备份文件 /var/opt/gitlab/backups/
	gitlab-rake gitlab:backup:restore
	
### 配置 GITLAB 邮件

	vi /opt/gitlab/embedded/service/gitlab-rails/config/gitlab.yml
		email_from: Git@openvox.cn

![email_from](image/email_from.png)

	vi /opt/gitlab/embedded/service/gitlab-rails/config/environments/production.rb
		config.action_mailer.delivery_method = :smtp

![smtp](image/smtp.png)

	vi /opt/gitlab/embedded/service/gitlab-rails/config/initializers/smtp_settings.rb

![email_settings](image/email_settings.png)

### 从 7.4.3 升级至 7.6.1

[omnibus-gitlab-update](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/update.md)

	1. 备份
	2. 
		gitlab-ctl stop unicorn
		gitlab-ctl stop sidekiq
	3. 升级
		rpm -Uvh gitlab-7.6.1_omnibus.5.3.0.ci.1-1.el6.x86_64.rpm
	4. 配置
		gitlab-ctl reconfigure
	5. 重启 GITLAB
		gitlab-ctl restart
		
### 重装

	yum erase gitlab
	rm -rf /etc/gitlab /opt/gitlab /var/opt/gitlab
	reboot your system
	rpm -ivh gitlab-7.4.3_omnibus.1-1.el6.x86_64.rpm
	sed -i "s/external_url 'localhost'/external_url 'http:\/\/172.16.0.223'/g" /etc/gitlab/gitlab.rb
	gitlab-ctl reconfigure
	gitlab-ctl restart