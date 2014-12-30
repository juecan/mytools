## GITLAB 升级

	omnibus gitlab
	[omnibus-gitlab-update](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/doc/update.md)

### 从 7.4.3 升级至 7.6.1

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